
import 'package:get_it/get_it.dart';
import 'package:jitsi_meet_example/service/api.dart';
import 'package:jitsi_meet_example/service/authentication_service.dart';
import 'package:jitsi_meet_example/viewmodel/logincontroller.dart';
import 'package:jitsi_meet_example/viewmodel/symptomsmodel.dart';


final locator = GetIt.instance;

void setupLocator() {
  //locator.registerLazySingleton(() => AuthenticationService());
  locator.registerLazySingleton<AuthenticationService>(() => AuthenticationService());
  locator.registerLazySingleton(()=>Api());
  locator.registerLazySingleton(()=>LoginController());
  locator.registerLazySingleton(()=>SymptomsModel());
}