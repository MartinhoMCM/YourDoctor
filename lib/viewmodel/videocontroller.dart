


import 'package:flutter/cupertino.dart';
import 'package:jitsi_meet_example/enums/enums.dart';
import 'package:jitsi_meet_example/service/messsage_service.dart';

class VideoController extends ChangeNotifier
{

  ServiceMessage _serviceMessage = new ServiceMessage();
  ViewState viewState=ViewState.Idle;
 ServiceMessage serviceMessage=new ServiceMessage();

  VideoController()
  {
    viewState=ViewState.Idle;
       // _serviceMessage.getDoctorNotifcation();
    
  }

  setState(ViewState state)
  {
    viewState =state;
    notifyListeners();

    print('make visible');
  }


  Stream<List<Notify>> getDoctorCalling() {

   Stream<List<Notify>> stream= this._serviceMessage.saidaNotify;

   if(stream!=null){
     setState(ViewState.Busy);
   }

   return stream;
  }

}