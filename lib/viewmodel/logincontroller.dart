import 'package:jitsi_meet_example/enums/enums.dart';
import 'package:jitsi_meet_example/locator.dart';
import 'package:jitsi_meet_example/service/api.dart';
import 'package:jitsi_meet_example/service/authentication_service.dart';
import 'package:flutter/material.dart';

class LoginController with ChangeNotifier {
  final AuthenticationService _authenticationService =
      locator<AuthenticationService>();
  String errorMessage='';

  ViewState _state = ViewState.Idle;
  ViewState get state => _state;
  String get message=>errorMessage;

 void setMessage(String message)
  {
       errorMessage=message;
       notifyListeners();
  }

  LoginController();

  void setState(ViewState state) {
    _state = state;
    notifyListeners();
  }

  Future<bool> login(
      {String userIdText, String userEmail, String userPassword}) async {
    var success;
    try {
      // The state is busy, because is starting to get user login authentication
      setState(ViewState.Busy);

      success = await _authenticationService.login(userEmail, userPassword);
      if (success == false) {
  
        print('not success');
        errorMessage = Api.error;
         setMessage('Usuário não existe');
          setState(ViewState.Idle);
      }
      else{

      }
       
    } catch (e) 
    { 
      setState(ViewState.Idle);
       setMessage(e);
      print('error patient $e');
    }
    return success;
  }
}
