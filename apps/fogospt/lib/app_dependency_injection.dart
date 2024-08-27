import 'package:fogospt/features/notifications/application/municipalities_service.dart';
import 'package:fogospt/features/notifications/data/municipalities_repository.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> setupAppDependencyInjectionData() async {
  GetIt.I.registerLazySingletonAsync(() => SharedPreferences.getInstance());
}

Future<void> setupAppDependencyInjection() async {
  GetIt.I.registerLazySingleton(() => MunicipalitiesRepository());
  GetIt.I.registerLazySingleton(() => MunicipalitiesService());
}
