

import 'package:cloud_firestore/cloud_firestore.dart';

class MessageUserFirebase
{
 
 String iddoctor;

 String idpaciente;

 String message;

 Timestamp recievedateTime;

 String email;

 FieldValue senddateTime;

   MessageUserFirebase({this.idpaciente ,this.iddoctor, this.message ,this.recievedateTime ,this.senddateTime, this.email });



   factory MessageUserFirebase.jsonFormato(DocumentSnapshot maps){

       return MessageUserFirebase(
           idpaciente: maps['idpaciente'],
           iddoctor:  maps['iddoctor'],
           email: maps['email'],
           message: maps['message'],
           recievedateTime: maps['recievedateTime']
       );
   }




 Map<String, dynamic>  toMap (){
      return {
          "message":this.message ,
          "recievedateTime":this.senddateTime,
          "email":this.email,
          "idpaciente":this.idpaciente,
          "iddoctor":this.iddoctor
      };
   }



  
}