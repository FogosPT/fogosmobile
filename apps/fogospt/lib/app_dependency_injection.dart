import 'package:fogospt/features/notifications/application/municipalities_service.dart';
import 'package:fogospt/features/notifications/data/municipalities_repository.dart';
import 'package:get_it/get_it.dart';

Future<void> setupAppDependencyInjection() async {
  GetIt.I.registerLazySingleton(() => MunicipalitiesRepository());
  GetIt.I.registerLazySingleton(() => MunicipalitiesService());
}
