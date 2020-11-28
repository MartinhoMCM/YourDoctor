
import 'package:flutter/material.dart';
import 'package:jitsi_meet_example/enums/enums.dart';
import 'package:jitsi_meet_example/models/Doctor.dart';

class DoctorController with ChangeNotifier
{

  ViewState state=ViewState.Idle;


  setState(ViewState state)
  {
    this.state=state;
    notifyListeners();
  }

  Future<Doctor> checkDoctorStatus()
  {

    setState(ViewState.Busy);

    List<Doctor> doctors;

  //  doctors =

  }

}