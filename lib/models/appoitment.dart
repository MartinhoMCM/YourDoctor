
import 'package:cloud_firestore/cloud_firestore.dart';

class Appointment
{

  String idDoctor;
  String idPatient;
  Timestamp appointmentTime;
  String description;
  
  Appointment({this.idDoctor, this.appointmentTime, this.idPatient});

 
  Appointment.fromJson(Map json)
  {
    idDoctor =json['iddoctor'];
    idPatient =json['idpatient'];
    appointmentTime=json['appointmentTime'];
    description =json['description'];
  }

  Map toJson()
  {
    
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['appointmentTime'] = this.appointmentTime;
    data['iddoctor'] = this.idDoctor;
    data['idpatient'] = this.idPatient;
    data['description']=this.description; 
    return data;

  }

}