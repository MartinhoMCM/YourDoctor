import 'package:jitsi_meet_example/models/consultas.dart';
import 'package:jitsi_meet_example/service/api.dart';
import 'package:jitsi_meet_example/ui/colors/colorsUI.dart';
import 'package:jitsi_meet_example/ui/fonts/text_style.dart';
import 'package:flutter/material.dart';

class InformationView extends StatefulWidget {
  InformationView({Key key, this.onPush, this.index}) : super(key: key);

  final ValueChanged<int> onPush;
  final int index;

  @override
  _InformationViewState createState() => _InformationViewState();
}

class _InformationViewState extends State<InformationView> {
  List<String> AppBartitles = [
    'Consultas',
    'Tratamentos',
    'Exames Laboratorias'
  ];
  int index;
  Api _api;

  @override
  void initState() {
    // TODO: implement initState
    _api =new Api();
    index = widget.index - 14;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: whiteColor,
        appBar: AppBar(
          backgroundColor: whiteColor,
          elevation: 0.0,
          title: Align(
              alignment: Alignment.topLeft,
              child:
                  Text('Historico ${AppBartitles[index]}', style: titleStyle)),
          leading: InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(
                Icons.arrow_back,
                color: blueColor,
              )),
        ),
        body:FutureBuilder<List<Consultas>>(
          future:_api.historicoConsultas(),
          builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Container(
              color: whiteColor,
              margin: EdgeInsets.symmetric(horizontal: 8.0),
              child: ListView.builder(
                  itemCount: 5,
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      child: Card(
                        child: ListTile(
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                'Exames Laboratoriais',
                                style: patternTextBoldStyle,
                              ),
                            ],
                          ),
                          subtitle: Text(
                            '0 exames',
                            style: patternTextStyle,
                          ),
                        ),
                      ),
                    );
                  }),
            );
          } else {
            return Dialog(
              child: contentWidget(),
              backgroundColor: whiteColor,
            );
          }
        }));
  }

  Widget contentWidget() {
    return Container(
        width: 40.0,
        height: 40.0,
        // padding: EdgeInsets.symmetric(horizontal: 8.0),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Processando...',
                style: TextStyle(color: blueColor),
              ),
              SizedBox(
                width: 10.0,
              ),
              Container(
                  width: 20.0,
                  height: 20.0,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.0,
                  ))
            ],
          ),
        ));
  }
}
