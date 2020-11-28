import 'package:jitsi_meet_example/enums/enums.dart';
import 'package:jitsi_meet_example/locator.dart';
import 'package:jitsi_meet_example/models/symptom.dart';
import 'package:jitsi_meet_example/service/api.dart';
import 'package:jitsi_meet_example/service/authentication_service.dart';
import 'package:flutter/material.dart';

class SymptomsModel extends ChangeNotifier{
  final AuthenticationService _authenticationService = locator<AuthenticationService>();
  String errorMessage;

  ViewState _state=ViewState.Idle;
  ViewState get state =>_state;

  void setState(ViewState state)
  {
    _state =state;
    notifyListeners();
  }
  Future<List<Symptom>> getSympton() async
  {

    setState(ViewState.Busy);

    var success =await _authenticationService.symptons();
    if(success==null)
    {
      errorMessage=Api.error;
    }
    setState(ViewState.Idle);
    return success;
  }
}