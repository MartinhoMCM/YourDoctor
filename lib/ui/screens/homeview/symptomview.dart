import 'package:jitsi_meet_example/models/paciente.dart';
import 'package:jitsi_meet_example/models/symptom.dart';
import 'package:jitsi_meet_example/service/authentication_service.dart';
import 'package:jitsi_meet_example/ui/colors/colorsUI.dart';
import 'package:jitsi_meet_example/ui/fonts/text_style.dart';
import 'package:jitsi_meet_example/ui/helper/UIHelper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';

class SymptomView extends StatefulWidget {
  final ValueChanged<int> onPush;
  final String localEndPoint;
  final ValueChanged<List<Symptom>> onPushSelectedSymptoms;
  SymptomView({this.onPush, this.localEndPoint, this.onPushSelectedSymptoms});
  @override
  _SymptomViewState createState() => _SymptomViewState();
}

class _SymptomViewState extends State< SymptomView> {
  List<bool> inputs ;
  List<Symptom> list;
  List<Symptom> selectedSymptom;
  List<bool> others;
  bool control;
  //After click Avancar bottom, this variable helps to hide Widgets in SymptomView class
  bool visible=false;
  int controlItem;
  ScrollController _scrollController=ScrollController();
  AuthenticationService authenticationService =AuthenticationService();
  TextEditingController  _textEditingController =TextEditingController();
  
  int pkProvince, county;
    var _longitude, _latitude;
      Geolocator _geolocator;





  Future<void> getLocation() async {
    try {
      Position position = await _geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      setState(() {
        _latitude = position.latitude;
        print('latidue $_latitude');
        _longitude = position.longitude;
      });
      
    } on PlatformException catch (e) {
      print('PlatformException $e');
    }
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



 @override
  void initState() {

   inputs= new List<bool>();
   others =new List(1);
   control=false;
   controlItem=1;
   _geolocator =new Geolocator();
   requestLocationPermission();
   getLocation() ;

    super.initState();
  }
  void ItemChange(bool val,int index, {bool control}){
    setState(() {
      inputs[index] = val;

      this.control=control;
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    inputs.clear();
    authenticationService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    
     pkProvince=Provider.of<Patient>(context).pkProvince;
     county=Provider.of<Patient>(context).pkCounty;
     int pkUser =Provider.of<Patient>(context).pkPaciente;
  

         return Scaffold(
             appBar: AppBar(
               backgroundColor: whiteColor,
               elevation: 0.0,
               title: Align(
                   alignment: Alignment.topLeft,
                   child: Text('', style:titleStyle)
               ),
               leading: InkWell(
                   onTap: (){
                     Navigator.pop(context);
                   },
                   child: Icon(Icons.arrow_back, color: blueColor,)
               ),
             ),
             body: Container(
                 margin: EdgeInsets.only(left: 16.0, top: 8.0, bottom: 8.0, right: 8.0),
                 child:FutureBuilder<List<Symptom>>(
                   future: authenticationService.symptons(localEndPoint: widget.localEndPoint),
                     builder:(context, snapshot){
                     //('lenght ${snapshot.data.length}');
                       if(snapshot.hasData){
                         list =List();
                         for(int i =0; i<snapshot.data.length; i++){
                           list.add(snapshot.data[i]);

                           inputs.add(false);
                         }
                         return Column(
                           mainAxisAlignment: MainAxisAlignment.start,
                           crossAxisAlignment: CrossAxisAlignment.start,
                           children: <Widget>[
                             UIHelper.verticalSpaceSmall(),
                             Padding(
                               padding: const EdgeInsets.only(left: 0.0, bottom: 4.0),
                               child: Text('Selecione o(s) sintoma(s) ',style:titleStyle),
                             ),
                             Padding(
                               padding: const EdgeInsets.only(left: 0.0),
                               child: Text('que estás sentindo ',style:subtitleStyle),
                             ),
                             UIHelper.verticalSpaceSmall(),
                             Flexible(
                               child: Padding(
                                 padding: const EdgeInsets.all(0.0),
                                 child: Column(
                                   mainAxisSize: MainAxisSize.max,
                                   mainAxisAlignment: MainAxisAlignment.start,
                                   crossAxisAlignment: CrossAxisAlignment.start,
                                   children: <Widget>[
                                     Expanded(
                                       flex: 5,
                                       child: Padding(
                                         padding: const EdgeInsets.all(0.0),
                                         child: ListView.builder(
                                             itemCount: snapshot.data.length,
                                             controller: _scrollController,
                                             itemBuilder: (BuildContext context, int index){
                                               return ListTileTheme(
                                                 contentPadding: EdgeInsets.all(0),
                                                 child: CheckboxListTile(
                                                   activeColor:  blueColor,
                                                   title: Text('${list[index].sintoma}', style: normalStyle,),
                                                   value: inputs[index],
                                                   controlAffinity: ListTileControlAffinity.leading,
                                                   onChanged: (bool val){
                                                     
                                                     if(index==snapshot.data.length-1){
                                                       control =control?false:true;
                                                       ItemChange(val, index, control: control);
                                                     }
                                                     else{
                                                       ItemChange(val, index, control: false);
                                                     }
                                                   },
                                                 ),
                                               );
                                             }),
                                       ),
                                     ),
                                     Padding(
                                       padding: EdgeInsets.all(0.0),
                                       child:control?showOtherItems():Padding(padding: EdgeInsets.all(0.0),) ,),
                                   ],
                                 ),
                               ),
                             ),
                             UIHelper.verticalSpaceSmall(),
                             Padding(
                               padding: const EdgeInsets.all(0.0),
                               child: Row(
                                 crossAxisAlignment: CrossAxisAlignment.start,
                                 mainAxisAlignment: MainAxisAlignment.start,
                                 children: <Widget>[
                                   Container(
                                     height: 40.0,
                                     decoration: BoxDecoration(
                                         borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                         color: blueColor
                                     ),
                                     child: Padding(
                                       padding: const EdgeInsets.all(8.0),
                                       child: InkWell(
                                         onTap: (){
                                           bool controlItem=false;
                                           for(int i=0; i<inputs.length; i++){
                                             if(inputs[i]){
                                               controlItem=true;
                                               break;
                                             }
                                           }
                                           if(controlItem){
                                             selectedOption(pkUser,pkCounty: county, pkProv: pkProvince );
                                           }
                                         },
                                         child:Center(
                                             child: Text('AVANÇAR', style: TextStyle(fontSize: 13.0,
                                                 fontWeight: FontWeight.w500, color: whiteColor))),
                                       ),
                                     ),
                                   ),
                                   UIHelper.horizontalSpaceSmall(),
                                   Container(
                                     height: 40.0,
                                     decoration: BoxDecoration(
                                         borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                         border: Border.all(
                                             color: Colors.black26,
                                             width: 1.0
                                         )
                                     ),
                                     child: Padding(
                                       padding: const EdgeInsets.all(8.0),
                                       child: InkWell(
                                           onTap: (){
                                             //Set inputs array with false value to all items after tapped
                                             setState(() {
                                               for(int i=0;i<inputs.length;i++){
                                                 inputs[i]=false;
                                               }
                                             });
                                           },
                                           child: Center(child: Text('APAGAR TODOS', style: TextStyle(fontSize: 13.0, fontWeight: FontWeight.w500, color: blueColor)))),
                                     ),
                                   ),
                                 ],
                               ),
                             ),
                             UIHelper.verticalSpaceSmall(),
                           ],
                         );
                       }
                       else{
                        return Dialog(
                          child: contentWidget(),
                          backgroundColor: whiteColor,
                        );
                       }

                     } ),
               ),

           );
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
              Text('Buscando os sintomas...',style: TextStyle(color: blueColor), ),
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

  //Sintomas selecionadas pelo paciente
  void selectedOption(int pkUsuario, {int pkProv, int pkCounty} ) async {

   List<Symptom> symptons =new List();
      if(list.length>0){
        for(int i=0; i<list.length; i++){
          if(inputs[i])
            {
              symptons.add(list[i]);
            }
        }
      }

      if(_textEditingController.text.isNotEmpty){
        List<String> lists=_textEditingController.text.split(',');
        for(int index=0; index>lists.length; index++)
        {
          symptons.add(new Symptom(fk_especialidade:list[0].fk_especialidade, fk_sintomas: list[0].fk_sintomas,
              pkSintomaEspecialidade: list[0].pkSintomaEspecialidade, sintoma: lists[index]));
        }
      }

   print('pk Patient $pkUsuario');   
   
   bool retorno = await authenticationService.sendSymptom(symptons, pkUsuario,pkCounty:  pkCounty, pkProvince: pkProv, latitude: _latitude, longitude: _longitude);
       if(retorno)
       {
         widget.onPushSelectedSymptoms(symptons);
         widget.onPush(10);
       }
       else
         {
           debugPrint('O retorno no symptoview $retorno');
         }

          //Codigo adicionado para trabalhar sem o server
        //widget.onPushSelectedSymptoms(symptons);
        //widget.onPush(10);
    }


  Widget showOtherItems()
  {
    _scrollToBottom();
    return Padding(
              padding: EdgeInsets.symmetric(horizontal: 50.0),
              child:
                  TextField(
                    style: subtitleStyle,
                    minLines: 1,
                    maxLines: 20,
                    controller: _textEditingController,
                    decoration: new InputDecoration(
                        hintText: 'Escreva os sintomas e separe por vírgulas',
                    ),
              ),
            );
  }
  _scrollToBottom(){
   _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
  }

  }
