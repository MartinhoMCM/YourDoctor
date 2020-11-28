

import 'Doctor.dart';
import 'paciente.dart';

class Chat
{

  Patient patient;
  Doctor doctor;
  String patientMessage;
  String doctorMessage;

  Chat.fromPatientMessage(Map map)
  {
    patientMessage = map['patientMessage'];

  }

  Chat.fromDoctorMessage(Map map)
  {

    patientMessage = map['doctorMessage'];

  }

  Map toPatient()
  {
    return {
      'doctorMessage':doctorMessage
    };
  }

  Map toDoctor()
  {
    return {
    'patientMessage':patientMessage
  };
  }

}