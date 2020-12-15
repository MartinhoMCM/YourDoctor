import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jitsi_meet_example/models/appoitment.dart';
import 'package:jitsi_meet_example/models/message.dart';


class ServiceMessage{

      final  Firestore  _firebase  =  Firestore.instance ;
      List<MessageUserFirebase> _listaMessage=new List();
      List<Notify> notifies =new List();

      static var controlMessageStream=true;

      //  StreamControlller
      static StreamController<List<MessageUserFirebase> > _controller = new StreamController.broadcast();
      Stream<List<MessageUserFirebase>>  saidaMessagem = _controller.stream;

      static StreamController<List<Notify>> notifyController = new StreamController.broadcast();
      Stream<List<Notify>> saidaNotify =notifyController.stream;

    

    close()
    {
     //notifyController.close();
      
    }

      void dispose(){
          _controller.close();
        //  notifyController.close();
      }

     void EnviarMessage(MessageUserFirebase  sms) async{
              var SEND = await   _firebase.collection("ChatURl")
             .add(sms.toMap());
          
     }


     void getAllMesaages(int iddoctor , int idpaciente) async{

       print('iddoctor $iddoctor');
       print('idpaciente $idpaciente');
        controlMessageStream =false;
        var  QUERY =  _firebase.collection("ChatURl")
            .where('iddoctor',isEqualTo: iddoctor)
            .where('idpaciente',isEqualTo: idpaciente).
            snapshots();
            QUERY.listen((dados) {
             if(dados !=  null){
               print('escutando!!');
             this.LimpandoChat();
                 for(int index = 0 ;  index <dados.documents.length ; ++index){
                     MessageUserFirebase _novo =MessageUserFirebase.jsonFormato(dados.documents[index]);
                     this._listaMessage.add(_novo);
                 }

                 OrdenarLista();
                  _controller.sink.add(this._listaMessage);
                  

              }
           });

     }

         void OrdenarLista()  {
             Future.delayed(Duration(seconds: 1) , (){
               this._listaMessage.sort((a, b)=> a.recievedateTime.compareTo(b.recievedateTime));
               _controller.sink.add(this._listaMessage);
             });

     }


     void LimpandoChat(){
       _listaMessage.clear();
       _controller.sink.add(_listaMessage);
     }

    
      Future<void> addAppointment(Map data) async
     {
       await _firebase.collection("appointment").add(data).then(
         (value) => null
         );
     }

     Future<List<Appointment>> fetchMyAppoitment({String iddoctor, String idpatient}) async
     {

       List<Appointment> appointmens=new List();
       
       try{
      var response= await _firebase.collection("appointment").where("iddoctor", isEqualTo: '2').snapshots();
       response.listen((event) { 
         if(event!=null)
         {
           event.documents.forEach((element) {

             appointmens.add(Appointment.fromJson(element.data));
            });
         }
       
       });

       }
       catch(e)
       {

         print('error %e');

       }

       return appointmens;
      
     }


 

}


class Notify
{
  int doctorId;
  int patientId;
  String url;
  Timestamp fieldValue;
  String status; 
  Notify({this.doctorId, this.patientId, this.url});

  Notify.fromJson(Map map)
  {

    this.doctorId =map['iddoctor'];
    this.patientId =map['idpaciente'];
    this.url =map['url'];
    this.fieldValue =map['dateTime'];
    this.status=map['statusnome'];

  }

}