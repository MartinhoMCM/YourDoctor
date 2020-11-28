import 'package:jitsi_meet_example/models/candidatedoctor.dart';
import 'package:jitsi_meet_example/service/api.dart';
import 'package:jitsi_meet_example/ui/colors/colorsUI.dart';
import 'package:jitsi_meet_example/ui/fonts/text_style.dart';
import 'package:jitsi_meet_example/ui/helper/UIHelper.dart';
import 'package:jitsi_meet_example/ui/helper/getLocation.dart';
import 'package:jitsi_meet_example/ui/screens/homeview/findAllDoctors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_html_view/flutter_native_html_view.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';

class SpecialistProfile extends StatefulWidget {
  final ValueChanged<int> onPush;
  final CandidateDoctor candidateDoctor;
  ValueChanged<CandidateDoctor> onDoctor;
  ValueChanged<double> onGetPrice;

  SpecialistProfile({this.onPush, this.candidateDoctor, this.onDoctor, this.onGetPrice});

  @override
  _SpecialistProfileState createState() => _SpecialistProfileState();
}

class _SpecialistProfileState extends State<SpecialistProfile> {
  double latitude=0.0;

  double longitude=0.0;

  @override
  void initState() {

    _api =new Api();
    _geolocator= new Geolocator();
  
    getDoctorLocation();

    super.initState();
  }

  static double _latitude = 0.0;
  static double _longitude = 0.0;
  Geolocator _geolocator;
  String html_String = "";
  CandidateDoctor _candidateDoctor;
  Api _api;
  double price=0.0;

  Future<void> getDoctorLocation() async {
    try {
      await myLocation();
      _latitude = double.parse(widget.candidateDoctor.latitude);
      _longitude = double.parse(widget.candidateDoctor.longitude);

      html_String = MyLocation.getMyLocation(latitude, longitude, latitude1: _latitude, longitude1: _longitude);
     
    } on PlatformException catch (e) {
      print('PlatformException $e');
    }
  }

  Future<void> myLocation() async {
        try {
          Position position = await _geolocator.getCurrentPosition(
              desiredAccuracy: LocationAccuracy.high);
          setState(() {
            latitude = position.latitude;
            print('latidue $latitude');
            longitude = position.longitude;
          });
         
        } on PlatformException catch (e) {
          print('PlatformException $e');
        }
      }
 String numberFormat(double number)
      {
        var f = NumberFormat('###,###,##0.00',);
         
         return f.format(number);
      }
      
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: solidWhiteColor,
      body: FutureBuilder<double>(

       future: _api.getPrice(widget.candidateDoctor.fkSpecialidade),
        builder: (context, snapshot) {

        

          if(snapshot.hasData){

             print('CandidateDoctor info ${widget.candidateDoctor.name} latitude ${widget.candidateDoctor.latitude} longitude ${widget.candidateDoctor.longitude}');
              price =snapshot.data;
       return CustomScrollView(
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            slivers: <Widget>[
              SliverAppBar(
                //forceElevated: true,
                elevation: 1.0,
                pinned: false,
                floating: true,
                backgroundColor: whiteColor,
                expandedHeight: 40.0,
                flexibleSpace: FlexibleSpaceBar(
                  title: Text('Perfil do onDoctor', style: titleStyle),
                ),
                leading: IconButton(
                  icon: const Icon(
                    Icons.arrow_back,
                    size: 25,
                    color: blueColor,
                  ),
                  tooltip: 'Add new entry',
                  color: blueColor,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              SliverList(
                delegate: SliverChildListDelegate([
                  Container(
                    height: 100.0,
                    margin: EdgeInsets.all((8.0)),
                    child: Row(
                      children: <Widget>[
                        Container(
                          width: 100.0,
                          height: 150.0,
                          margin: EdgeInsets.only(left: 0.0, top: 8.0, right: 8.0),
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage('assets/doctor.png'),
                                fit: BoxFit.cover,
                              ),
                              border: Border.all(color: dialogColor),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0))),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Flexible(
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(top: 16.0, left: 8.0),
                                child: Text('${widget.candidateDoctor.name}',
                                    style: TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.w600)),
                              ),
                            ),
                            UIHelper.verticalSpaceTooSmall(),
                             Flexible(
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(top: 0.0, left: 8.0),
                                child: Text('${widget.candidateDoctor.especialidade}',
                                    style: normalStyleBlue)
                              ),
                            ),
                        ],
                        )
                      ],
                    ),
                  ),
                  UIHelper.verticalSpaceSmall(),
                  Center(
                    child: Container(
                      height: 45.0,
                      width: 200.0,
                      margin: EdgeInsets.symmetric(
                        horizontal: 8,
                      ),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(5.0)),
                          color: blueColor),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: InkWell(
                          
                          child: Center(
                              child: Text('CONTINUAR',
                                  style: TextStyle(
                                      fontSize: 13.0,
                                      fontWeight: FontWeight.w500,
                                      color: whiteColor))),
                          onTap: () {
                            widget.onGetPrice(price);
                            widget.onDoctor(widget.candidateDoctor);
                            widget.onPush(12);

                            print('longitude ${widget.candidateDoctor.especialidade}');
                          },
                        ),
                      ),
                    ),
                  ),
                  UIHelper.verticalSpaceMedium(),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 8.0),
                    child: Padding(
                      padding: EdgeInsets.all(0.0),
                      child: Text(
                        'Informações',
                        style: chatTitleStyle,
                      ),
                    ),
                  ),
                  UIHelper.verticalSpaceSmall(),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal:8.0),
                    child: RichText(
                      text: TextSpan(
                          text: 'Especialidade - ',
                          style: subtitleNormalStyle,
                          children: [
                            TextSpan(
                              text: '${widget.candidateDoctor.especialidade}',
                              style: subtitleNormalStyle,
                            )
                          ]),
                    ),
                  ),
                  UIHelper.verticalSpaceSmall(),
                   Container(
                    margin: EdgeInsets.symmetric(horizontal:8.0),
                    child: RichText(
                      text: TextSpan(
                          text: 'Preço da consulta - ',
                          style: subtitleNormalStyle,
                          children: [
                            TextSpan(
                              text: '${numberFormat(price)} AOA',
                              style: titleStyle,
                            )
                          ]),
                    ),
                  ),
                  UIHelper.verticalSpaceMedium(),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 8.0),
                    child: Padding(
                      padding: EdgeInsets.all(0.0),
                      child: Text(
                        'Location',
                        style: chatTitleStyle,
                      ),
                    ),
                  ),
                  UIHelper.verticalSpaceMedium(),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 8.0),
                    child: Container(
                      height: 250.0,
                      child: FlutterNativeHtmlView(
                        htmlData: html_String,
                        onLinkTap: (String url) {
                          print(url);
                        },
                        onError: (String message) {
                          print(message);
                        },
                      ),
                    ),
                  ),
                  UIHelper.verticalSpaceMedium(),
                ]),
              )
            ],
          );
     
          }
          else{
            return Container(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
      }
      ),
    );
  }
}
