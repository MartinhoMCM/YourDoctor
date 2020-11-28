import 'dart:async';

import 'package:jitsi_meet_example/models/candidatedoctor.dart';
import 'package:jitsi_meet_example/models/symptom.dart';
import 'package:jitsi_meet_example/service/api.dart';
import 'package:jitsi_meet_example/ui/colors/colorsUI.dart';
import 'package:jitsi_meet_example/ui/fonts/text_style.dart';
import 'package:jitsi_meet_example/ui/helper/UIHelper.dart';
import 'package:jitsi_meet_example/ui/helper/getLocation.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_html_view/flutter_native_html_view.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

class FindAllDoctors extends StatefulWidget {
  final ValueChanged<int> onPush;
  ValueChanged<CandidateDoctor> candidateDoctor;
  List<Symptom> symptoms = new List();

  FindAllDoctors({this.onPush, this.symptoms, this.candidateDoctor});

  @override
  FindAllDoctorsState createState() => FindAllDoctorsState();
}

class FindAllDoctorsState extends State<FindAllDoctors> {
  static double _latitude = 0.0;
  static double _longitude = 0.0;
  bool _isMockLocation;
  Geolocator _geolocator;

  String html_String = "";
  int stopTrust = 0;

  //Set the postion of doctor card
  double positionCard = 250.0;

  // List<Doctor> doctors = List();

  Color _selectedColor, _unselectedColor;
  List<Color> colors;
  //Check if location service is operational
  //final GeolocationResult result = await Geolocation.isLocationOperational();

  // Esta variavel ajuda a tornar visivel ou nao, a lista de doctores quando se desliza no map
  bool isDoctorScrolledListVisible;
  double sideHeight = 175.0;
  double sideWidth = 160.0;

  bool Isminimized = true;

  ScrollController _scrollController;
  bool _isDoctorFound = false;
  Api _api;

  //Variables doctor
  List<RadioDoctor> _radioDoctor;
  String doctorName;

  Future<List<CandidateDoctor>> future;
  List<CandidateDoctor> listaCandidato = [];

  Timer timer;
  AppBar _appBar(BuildContext context) {
    return AppBar(
      backgroundColor: whiteColor,
      title: Text('Buscando doctor ...', style: titleStyle),
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
    );
  }

 Future<void> _handleLocation() async {
    await PermissionHandler().requestPermissions(
      [PermissionGroup.location, PermissionGroup.locationAlways],
    );
  }

  @override
  void initState() {
    _selectedColor = selectedColor;
    _unselectedColor = unselectedColor;
    isDoctorScrolledListVisible = true;
    _geolocator = Geolocator();
   requestLocationPermission();
    //permitLocation();
        getLocation();
        _scrollController = new ScrollController();
        _api = new Api();
    
        setRadioDoctor();
    
       future=  _api.findOlineDoctor();
    
        updateDoctor();
    
        super.initState();
      }
    
      int index = 0;
      updateDoctor() {
      
        timer = new Timer.periodic(Duration(seconds: 10), (_) {
    
          print('updating...');
    
          setState(() {
            future=  _api.findOlineDoctor();
          });
         
        });
    
        setState(() {});
      }
    
      @override
      void dispose() {
        timer.cancel();
        _api.dispose();
        super.dispose();
      }
    
      void requestLocationPermission() async {
        try {
          _geolocator.checkGeolocationPermissionStatus(
              locationPermission: GeolocationPermission.locationAlways);
          _geolocator.checkGeolocationPermissionStatus(
              locationPermission: GeolocationPermission.locationAlways);
        } catch (e) {
          print('geolocation');
        }
      }
    
      Future<void> getLocation() async {
        try {
          Position position = await _geolocator.getCurrentPosition(
              desiredAccuracy: LocationAccuracy.high);
          setState(() {
            _latitude = position.latitude;
            print('latidue $_latitude');
            _longitude = position.longitude;
          });
          html_String = MyLocation.getMyLocation(_latitude, _longitude);
        } on PlatformException catch (e) {
          print('PlatformException $e');
        }
      }
    
      void setDoctorVisible(bool isHovering) {
        setState(() {
          sideHeight = (isHovering) ? 0.0 : 200.0;
          sideWidth = (isHovering) ? 0.0 : 160.0;
        });
      }
    
      @override
      void didUpdateWidget(FindAllDoctors oldWidget) {
        super.didUpdateWidget(oldWidget);
      }
    
      @override
      Widget build(BuildContext context) {
        double height = MediaQuery.of(context).size.height;
        var padding = MediaQuery.of(context).padding;
        var appHeight = AppBar().preferredSize.height;
        double newheight = height - padding.top - padding.bottom - appHeight;
    
        return Scaffold(
          appBar: AppBar(
            backgroundColor: whiteColor,
            title: Text('Buscando doctor ...', style: titleStyle),
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
          backgroundColor: solidWhiteColor,
          body: _latitude != null &&
                  _latitude != 0.0 &&
                  _longitude != 0.0 &&
                  html_String.isNotEmpty
              ? Container(
                  child: Stack(
                    children: [
                      Positioned(
                        top: 0.0,
                        right: 0.0,
                        left: 0.0,
                        bottom: 0.0,
                        child: Container(
                          margin: EdgeInsets.only(
                              top: 0.0, bottom: 0.0, left: 0.0, right: 0.0),
                          child: Container(
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
                      ),
                      Positioned(
                          top: 0.0,
                          left: 0.0,
                          right: 0.0,
                          height: 25.0,
                          child: doctorName != null
                              ? Container(
                                  decoration: BoxDecoration(
                                      color: Colors.transparent,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(5.0))),
                                  child: Center(
                                      child: RichText(
                                    text: TextSpan(
                                        text: 'Selecionaste o(a) especialista ',
                                        style: normalStyle,
                                        children: [
                                          TextSpan(
                                              text: '$doctorName',
                                              style: normalStyleBlue)
                                        ]),
                                  )),
                                )
                              : Container()),
                      Isminimized
                          ? Positioned(
                              top: newheight - (!Isminimized ? 262.0 : 350.0),
                              left: 0.0,
                              right: 0.0,
                              height: 210.0,
                              child: StreamBuilder<List<CandidateDoctor>>(
                                stream: _api.onVariableChanged,
                                builder: (context, snapshot) {
                                  if (snapshot.hasData && snapshot.data.length>0) {
                                    List<CandidateDoctor> doctors = snapshot.data;
                                    List<CandidateDoctor> datas = snapshot.data;
                                    var elementDoctor;
                                    var elementData;
    
                                    for (int val = 0; val < datas.length; val++) {
                                      elementData = datas[val].fkMedico;
                                      for (int j = val + 1; j <= val; j++) {
                                        elementDoctor = doctors[j].fkMedico;
                                        if (elementData == elementDoctor) {
                                          doctors.removeAt(j);
                                        }
                                      }
                                    }
    
                                    return SizedBox(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 0.0, vertical: 8.0),
                                        child: ListView.builder(
                                          itemBuilder:
                                              (BuildContext context, index) =>
                                                  DoctorCard(doctors[index], index),
                                          shrinkWrap: true,
                                          scrollDirection: Axis.horizontal,
                                          itemCount: doctors.length,
                                        ),
                                      ),
                                    );
                                  } else {
                                    return findDoctor();
                                  }
                                },
                              ))
                          : Container(),
                      Isminimized
                          ? Positioned(
                              height: 150.0,
                              width: MediaQuery.of(context).size.width,
                              right: 0.0,
                              bottom: 0.0,
                              //top: MediaQuery.of(context).size.height - 240.0,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  // UIHelper.verticalSpaceSmall()
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        Isminimized = !Isminimized;
                                      });
                                    },
                                    child: Container(
                                      height: 50.0,
                                      width: 60.0,
                                      decoration: BoxDecoration(
                                          color: whiteColor,
                                          shape: BoxShape.rectangle,
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(10.0),
                                          )),
                                      child: Icon(
                                        Icons.keyboard_arrow_up,
                                        size: 40.0,
                                      ),
                                    ),
                                  ),
    
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Container(
                                        // height: 110.0,
                                        width: MediaQuery.of(context).size.width,
                                        decoration: BoxDecoration(
                                          color: whiteColor,
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.symmetric(
                                                    vertical: 8.0, horizontal: 8.0),
                                                child: Text('Sintomas selecionados  ${listaCandidato.length}',
                                                    style: chatTitleStyle),
                                              ),
                                              SizedBox(
                                                height: 40.0,
                                                child: Scrollbar(
                                                  controller: _scrollController,
                                                  child: ListView.builder(
                                                    controller: _scrollController,
                                                    itemBuilder:
                                                        (BuildContext context,
                                                                index) =>
                                                            ItemSymptoms(index),
                                                    shrinkWrap: true,
                                                    scrollDirection:
                                                        Axis.horizontal,
                                                    itemCount:
                                                        widget.symptoms.length,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ))
                          : Positioned.fill(
                              top: newheight - 90,
                              child: Align(
                                alignment: Alignment.topRight,
                                child: InkWell(
                                  onTap: () {
                                    print('newHeight $newheight');
                                    setState(() {
                                      Isminimized = !Isminimized;
                                    });
                                  },
                                  child: Container(
                                    height: 50.0,
                                    width: 60.0,
                                    decoration: BoxDecoration(
                                        color: whiteColor,
                                        shape: BoxShape.rectangle,
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(10.0),
                                        )),
                                    child: Icon(
                                      Icons.keyboard_arrow_down,
                                      size: 40.0,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                    ],
                  ),
                )
              : Dialog(
                  child: contentWidget(),
                  backgroundColor: whiteColor,
                ),
        );
      }
    
      void checkColor(int index) {
        setState(() {
          if (colors[index] == _unselectedColor) {
            colors[index] = _selectedColor;
          } else if (colors[index] == _selectedColor) {
            colors[index] = _unselectedColor;
          }
        });
        setColor(index);
      }
    
      void setColor(int index) {
        setState(() {
          for (int color = 0; color < colors.length; color++) {
            if (color == index) continue;
            colors[color] = _unselectedColor;
          }
        });
      }
    
      Widget DoctorCard(CandidateDoctor doctor, int index) {
        return Card(
            elevation: 4.0,
            color: _radioDoctor[index].color,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
            child: InkWell(
              onTap: () {
                print(
                    'doctor latitude 1 ${doctor.latitude}, longitude ${doctor.longitude}');
                setState(() {
                  _radioDoctor.forEach((element) {
                    element.color = Colors.white;
                    element.isSelected = false;
                  });
    
                  _radioDoctor[index].color = Colors.transparent;
                  _radioDoctor[index].isSelected = true;
                  doctorName = doctor.name;
    
                  //latitude1 and longitude1 is from doctor
                  html_String = MyLocation.getMyLocation(_latitude, _longitude,
                      latitude1: double.parse(doctor.latitude),
                      longitude1: double.parse(doctor.longitude));
                });
              },
              child: Container(
                width: 170.0,
                margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          Container(
                            width: 70.0,
                            height: 70.0,
                            decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                border:
                                    Border.all(width: 1.0, color: Colors.grey[100]),
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(10.0)),
                                image: DecorationImage(
                                  image: AssetImage(
                                    'assets/doctor.png',
                                  ),
                                  fit: BoxFit.cover,
                                )),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 0.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.star,
                                  color: Colors.red,
                                ),
                                Text(
                                  '0',
                                  style: subtitleStyle,
                                )
                              ],
                            ),
                          )
                        ]),
                    Padding(
                      padding: EdgeInsets.all(0.0),
                      child: Text(
                        '${doctor.name}',
                        style: patternTextBoldStyle,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(0.0),
                      child: Text(
                        '${doctor.especialidade}',
                        style: chatTextBlueStyle,
                      ),
                    ),
                    UIHelper.verticalSpaceSmall(),
                    FlatButton(
                        onPressed: () {
                           timer.cancel();
                          _api.dispose();
                          print('Doctor info ${doctor.name} fkMedico ${doctor.fkMedico} longitude ${doctor.longitude}');
                          CandidateDoctor candidateDoctor = CandidateDoctor(
                              name: doctor.name,
                              latitude: doctor.latitude,
                              longitude: doctor.longitude,
                              fkMedico: doctor.fkMedico,
                              especialidade: doctor.especialidade,
                              fkSpecialidade: widget.symptoms[0].fk_especialidade);
    
                          widget.candidateDoctor(candidateDoctor);
                          widget.onPush(11);
                        },
                        child: Container(
                          width: 100.0,
                          height: 30.0,
                          padding: EdgeInsets.all(0.0),
                          margin: EdgeInsets.all(0.0),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              color: blueColor),
                          child: Center(
                              child: Text(
                            'Conectar',
                            style: patternTextBoldWhiteStyle,
                          )),
                        )),
                  ],
                ),
              ),
            ));
        ;
      }
    
      Widget ItemSymptoms(int index) {
        return Container(
            padding: EdgeInsets.all(8.0),
            decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                border: Border.all(width: 1.0, color: Colors.grey[300])),
            margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
            child: Text('${index + 1}. ${widget.symptoms[index].sintoma}',
                style: chatTextStyle));
      }
    
      void setRadioDoctor() {
        _radioDoctor = new List(100);
        for (int j = 0; j < 100; j++) {
          _radioDoctor[j] = new RadioDoctor(color: Colors.white, isSelected: false);
        }
      }
    
      void permitLocation() async{
        await _handleLocation();
      }
}

//ShowDialog Processing...
Widget findDoctor() {
  return Container(
      width: 60.0,
      height: 10.0,
      padding: EdgeInsets.symmetric(horizontal: 8.0),
      margin: EdgeInsets.symmetric(horizontal: 8.0),
      decoration: BoxDecoration(color: Colors.transparent),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Flexible(
                child: Padding(
                    padding: EdgeInsets.only(left: 4.0, top: 2.0, bottom: 2.0),
                    child: Text(
                      'Buscando doctores',
                      style: TextStyle(color: blueColor),
                    ))),
            SizedBox(
              width: 1.0,
            ),
            UIHelper.horizontalSpaceSmall(),
            Container(
                width: 20.0,
                height: 20.0,
                child: Padding(
                  padding: EdgeInsets.only(right: 4.0),
                  child: CircularProgressIndicator(
                    strokeWidth: 2.0,
                  ),
                )),
            SizedBox(
              width: 5.0,
            ),
          ],
        ),
      ));
}

Widget contentWidget() {
  return Container(
      width: 60.0,
      height: 50.0,
      // padding: EdgeInsets.symmetric(horizontal: 8.0),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Flexible(
                child: Padding(
                    padding: EdgeInsets.only(left: 4.0, top: 2.0, bottom: 2.0),
                    child: Text(
                      'certifique que o GPS está ativo e aguarde...',
                      style: TextStyle(color: blueColor),
                    ))),
            SizedBox(
              width: 1.0,
            ),
            Container(
                width: 20.0,
                height: 20.0,
                child: Padding(
                  padding: EdgeInsets.only(right: 4.0),
                  child: CircularProgressIndicator(
                    strokeWidth: 2.0,
                  ),
                )),
            SizedBox(
              width: 5.0,
            ),
          ],
        ),
      ));
}

class RadioDoctor {
  Color color;
  bool isSelected;

  RadioDoctor({this.color, this.isSelected});
}
