
import 'package:flutter/material.dart';
import 'package:jitsi_meet_example/models/Doctor.dart';
import 'package:jitsi_meet_example/models/candidatedoctor.dart';
import 'package:jitsi_meet_example/models/symptom.dart';
import 'package:jitsi_meet_example/service/api.dart';
import 'package:jitsi_meet_example/ui/screens/chat/messageuser.dart';
import 'package:jitsi_meet_example/ui/screens/homeview/findAllDoctors.dart';
import 'package:jitsi_meet_example/ui/screens/homeview/homeview.dart';
import 'package:jitsi_meet_example/ui/screens/homeview/informationview.dart';
import 'package:jitsi_meet_example/ui/screens/homeview/specialistdescription.dart';
import 'package:jitsi_meet_example/ui/screens/homeview/symptomview.dart';
import 'package:jitsi_meet_example/ui/screens/payment/paymentview.dart';
import '../enums/enums.dart';
import '../main.dart';

class TabNavigatorRoutes
{
  static const String root = '/';
  static const String detail = '/detail';
  static const String specialistDescription='/specialistDescription';
  //static const String specialistProfile ='/profile';
  static const String profileSpecialist ='/profileSpecialist';
  static const String payment ='/payment';
  static const String consultant ='/consultant';
  static const String treat ='/treat';
  static const String exam ='/exam';

}

class TabNavigatorHome extends StatelessWidget
{
  BuildContext mContext;
  TabNavigatorHome({this.navigatorKey, this.tabItem, this.mContext});
  final GlobalKey<NavigatorState> navigatorKey;
  final TabItem tabItem;
  int index=11;

  List<Symptom> selectedSymptoms=new List();
  CandidateDoctor candidateDoctor,doctor;
  double price=0.0;


  void _push(BuildContext context, {int materialIndex: -1, List<Doctor> doctors, List<Symptom> symptoms, CandidateDoctor doctor})

  {

    var routeBuilders =_routeBuilders(context, materialIndex: materialIndex, doctors: doctors);

    // The number 1 indicator Symptom class, that is added to the stack through onPush(1)
    //called by HomeView callback class onPush(1) inside Drawer Widget item
    if(materialIndex>=0 && materialIndex<=5){
      Navigator.push(context,
          MaterialPageRoute(
              builder: (context) =>
                  routeBuilders[TabNavigatorRoutes.detail](context)));
    }
    else if(symptoms!=null && materialIndex==10){
    Navigator.push(context,
        MaterialPageRoute(
        builder: (context) =>
            routeBuilders[TabNavigatorRoutes.specialistDescription](context)));
    }
    else if(materialIndex==6){
       Navigator.pushAndRemoveUntil(mContext, MaterialPageRoute(
         builder: (_)=>MyApp(),
       ), (route) => false);
    }
    else if(materialIndex==11){
      Navigator.push(context,
          MaterialPageRoute(
              builder: (context) =>
                  routeBuilders[TabNavigatorRoutes.profileSpecialist](context)));
    }
    else if(materialIndex==12)
    {
      Navigator.push(context,
          MaterialPageRoute(
              builder: (context) =>
                  routeBuilders[TabNavigatorRoutes.payment](context)));
    }
    else if(materialIndex>=14 && materialIndex<=16){
      Navigator.push(context,
          MaterialPageRoute(
              builder: (context) =>
                  routeBuilders[TabNavigatorRoutes.consultant](context)));
    }
     else if(materialIndex==19)
    {
     
           Navigator.pushAndRemoveUntil(context,
            MaterialPageRoute(
              builder: (context) =>
                  routeBuilders[TabNavigatorRoutes.root](context)),
                  (route)=>false);
    }
    
  }

  Map<String,WidgetBuilder> _routeBuilders(BuildContext context, {int materialIndex: 500, String key, List<Doctor> doctors, Doctor theDoctor, List<Symptom> symptoms})
  {
    print('map');
    return {
      TabNavigatorRoutes.root: (context) => HomeView(
        onPush: (materialIndex)=>_push(context, materialIndex: materialIndex),
      ),
      TabNavigatorRoutes.detail: (context) =>SymptomView(
          onPushSelectedSymptoms: (value){
            selectedSymptoms=value;
           symptoms=selectedSymptoms;
          },
          localEndPoint:Api.ListOfEndpoints[materialIndex] ,
          onPush: (materialIndex){
            if(materialIndex==10)
            {
              _push(context, materialIndex: materialIndex,symptoms: selectedSymptoms);

            }else{
              _push(context, materialIndex:  materialIndex, );
            }
          }
      ),
      TabNavigatorRoutes.specialistDescription:(context)=>
          FindAllDoctors(
           candidateDoctor:(theValue)=>candidateDoctor=theValue,
        symptoms: selectedSymptoms,
           onPush:(materialIndex)=> {_push(context, materialIndex:  materialIndex),

      } ,
    ),
     TabNavigatorRoutes.profileSpecialist: (context) => SpecialistProfile(
       candidateDoctor: candidateDoctor,
       onPush:(materialIndex)=>_push(context, materialIndex: materialIndex),
       onDoctor: (value)=>doctor=value,
       onGetPrice: (valor)=>price=valor,
       
      ),

      TabNavigatorRoutes.payment: (context) => PaymentView(
        candidateDoctor: doctor,
        price: price,
        onPush: (materialIndex)=>_push(context, materialIndex: materialIndex),
        onGetDoctor: (medico)=>candidateDoctor=medico,

      ),
      TabNavigatorRoutes.consultant: (context) => InformationView(
        onPush: (materialIndex)=>_push(context, materialIndex: materialIndex),
        index: materialIndex,
      ),
  
      };
  }

  @override
  Widget build(BuildContext context){
    final routeBuilders = _routeBuilders(context);
    return Navigator(
      key: navigatorKey,
      initialRoute: TabNavigatorRoutes.root,
      onGenerateRoute:(routeSettings) {
        return  MaterialPageRoute(
            builder: (context) => routeBuilders[routeSettings.name](context));
      },
    );
  }
}