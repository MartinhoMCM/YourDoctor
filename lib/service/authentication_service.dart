import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:jitsi_meet_example/enums/enums.dart';
import 'package:jitsi_meet_example/models/paciente.dart';
import 'package:jitsi_meet_example/models/symptom.dart';
import 'package:jitsi_meet_example/models/user.dart';


import '../locator.dart';
import 'api.dart';


class AuthenticationService with ChangeNotifier {

  ViewState viewState=ViewState.Idle;

  setState(ViewState viewState)
  {
    viewState=viewState;
    notifyListeners();
  }
  Api _api = locator<Api>();

  static String error="null";
  static User user;
  static int patientFirstLog=0;

  StreamController<Patient> userController = StreamController<Patient>();

  Future<bool> login(String email, String password) async {
      try{
        int fetchID;
        user =await _api.getUserProfile(email: email, password: password);
        
        if(user!=null){
          fetchID =user.pkUsuario;
          print('fetchID  ${user.pkUsuario}');
          }
         Patient patient= await _api.getPatient(pkUsuario: fetchID);

         if(patient!=null)
         {
            userController.add(patient); 
             patientFirstLog =patient.primeiroLog;   
            return true;
         }
         else{
           print('Paciente Null');
         }
         return false;
      }
      on Exception catch(e){
          print('error in AuthenticationService $e');
      }
    return false;
  }

  Future<List<Symptom>> symptons({String localEndPoint}) async
  {
    try {
      List<Symptom> list =new List();

       var fetchSymptons = await _api.symptoms(localEndPoint: localEndPoint);
      var hasSymptons =fetchSymptons!=null;
      if(hasSymptons){
        return fetchSymptons;
      }

      return list;
    }
    on Exception catch(e)
    {
      debugPrint("Erro1 $e");
    }
  }


  Future<bool> sendSymptom(List<Symptom >symptom, int userId, {int pkProvince, int pkCounty, double latitude, double longitude}) async
  {
    bool fetchResult;
    try{
       fetchResult= await _api.sendSymptom(symptoms: symptom, userId: userId, pkProvince: pkProvince, pkCounty: pkCounty, latitude: latitude, longitude: longitude);
      return fetchResult;
    }
    catch(e){
      print('$e');
     
    }
  return false;
  }

  Future getUploadFile(File image) async
  {
    var response = await _api.GetUploadFile(image);
  }

}