import 'dart:io';

import 'package:jitsi_meet_example/enums/enums.dart';
import 'package:jitsi_meet_example/service/api.dart';
import 'package:flutter/cupertino.dart';

enum PaymentResult { SENT, NOTSENT }

class PaymentController extends ChangeNotifier {
  Api _api = new Api();
  PaymentResult paymentResult = PaymentResult.NOTSENT;

  ViewState state = ViewState.Idle;

  PaymentResult get payment => paymentResult;

  void setState(ViewState viewState) {
    state = viewState;
    notifyListeners();
  }

  void setResult(PaymentResult payment) {
    paymentResult = payment;
    notifyListeners();
  }

  Future<bool> postFiles(
      {File document, int pkPatient, int pkSpecialidade, double preco}) async {
    setState(ViewState.Busy);
    setResult(PaymentResult.NOTSENT);
    bool result = await _api.PostFiles(
        document: document,
        pkPatient: pkPatient,
        pkSpecialidade: pkSpecialidade,
        preco: preco);

    if (result) setResult(PaymentResult.SENT);

    setState(ViewState.Idle);
    return result;
  }

 Future<bool> finalizarConsulta({int pkMedico, int pkUsuario, int fkEspecialidade}) async
 {
   print('pkPaciente $pkMedico pkUsuario $pkUsuario');
   var res=false;
    res= await _api.finalizarConsulta(pkPaciente: pkMedico,pkUsuario: pkUsuario, fkEspecialidade: fkEspecialidade);

    return res;
 }
}
