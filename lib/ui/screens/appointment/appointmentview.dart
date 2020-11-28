
import 'package:jitsi_meet_example/models/consulta.dart';
import 'package:jitsi_meet_example/models/paciente.dart';
import 'package:jitsi_meet_example/service/api.dart';
import 'package:jitsi_meet_example/ui/colors/colorsUI.dart';
import 'package:jitsi_meet_example/ui/fonts/text_style.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class AppointmentView extends StatefulWidget {
  final int pkPatient;
  final ValueChanged<int> onPush;

 final ValueChanged<Consulta> onConsulta;

  AppointmentView({this.pkPatient, this.onPush, this.onConsulta});
  @override
  AppointmentViewState createState() => AppointmentViewState();
}

class AppointmentViewState extends State<AppointmentView>
    with SingleTickerProviderStateMixin {
  List _selectedEvents;


  Api _api;
  @override
  void initState() {
    
  
    _selectedEvents = new List();
    _api =new Api();


  
   // atualizar();
    super.initState();
  }

  @override
  void dispose() {
    _api.dispose();

    super.dispose();
  }

  void atualizar() async{
        await _api.getConsultas(pkPaciente:widget.pkPatient);

  }

  @override
  Widget build(BuildContext context) {
   
   int patientId = Provider.of<Patient>(context).pkPaciente;

    return Scaffold(
      // backgroundColor: solidWhiteColor,
      appBar: AppBar(
  title: Text('Minhas consultas', style: titleStyle),
  backgroundColor: whiteColor,
      ),
      body: NestedScrollView(
          scrollDirection: Axis.vertical,
          headerSliverBuilder: (context, bool innerBoxIsScrolled) {
            return <Widget>[
             
             
            ];
          },
          body: FutureBuilder<List<Consulta>>(
            future: _api.getConsultas(pkPaciente: patientId),
            builder: (context, snapshot)
          {
            
            if(snapshot.hasData)
            {
              return Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _showEvent(snapshot.data),
            ],
          );
            }
            else{
              return Container(
                color: whiteColor,
                child: Dialog(
                  child: contentWidget(),
                ),
              );
            }
          }),
    ));
  }
  Widget contentWidget()
  {
    return Container(
        width: 40.0,
        height: 40.0,
        // padding: EdgeInsets.symmetric(horizontal: 8.0),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('Buscando as consultas...',style: TextStyle(color: blueColor), ),
              SizedBox(width: 10.0,),
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


  Widget _showEvent(List<Consulta> consultas) {
    return Expanded(
        flex: 2,
        child: ListView(
          children:consultas.map((event) {
            return Container(
              height: 100.0,
              margin: EdgeInsets.all(0.0),
              decoration: BoxDecoration(
                  color: whiteColor, borderRadius: BorderRadius.circular(5.0)),
              child: Card(
                elevation: 2.0,
                child: ListTile(
                  title: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(
                        height: 5.0,
                      ),
                      Text(
                        'Consulta de Urologia',
                        style: appoTitleStyle,
                      ),
                      //Text('${event.toString()}'),
                      SizedBox(
                        height: 3.0,
                      ),
                      Text(
                        'Especialista ${event.nomeDoctor}',
                        style:TextStyle(fontSize: 14.0,  color: blueColor, ),
                      ),
                      SizedBox(
                        height: 3.0,
                      ),
                      trailingWidget(event.dataConsulta)
                    ],
                  ),
                  trailing: Container(
                    height: 30.0,
                    width: 30.0,
                    child: Icon(
                      Icons.chat,
                      color: setColor(),
                      size: 30.0,
                    ),
                  ),
                  onTap: () {
                    print('event ${event.dataConsulta}');
                    widget.onConsulta(event);
                    widget.onPush(1);
                  },
                ),
              ),
            );
          }).toList(),
        ));
  }

  void sortManuallyEvent() {
    setState(() {
      int length = 0;
      dynamic aux;
      for (int iterator = _selectedEvents.length - 1;
          iterator > _selectedEvents.length / 2;
          iterator--) {
        aux = _selectedEvents[iterator];
        _selectedEvents[iterator] = _selectedEvents[length];
        _selectedEvents[length] = aux;
        length++;
      }
    });
  }

  Widget trailingWidget(String dateTime) {
   
    return trailingWidgetText('hoje', dateTime);
  }

  Widget trailingWidgetText(String schedule, String dateTime) {
    return Container(
      width: 70.0,
      height: 30.0,
      decoration: BoxDecoration(
          color: setColor(),
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(5.0)),
      child: Center(
          child: Text(
        '$schedule',
        style: appoTextStyle,
      )),
    );
  }

  Color setColor() {
    
      return blueColor;
  }
}
