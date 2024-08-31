import 'package:fogospt/features/select_notifications/application/fetch_municipalities_service.dart';
import 'package:fogospt/features/select_notifications/data/load_municipalities_repository.dart';
import 'package:get_it/get_it.dart';

Future<void> setupAppDependencyInjection() async {
  GetIt.I.registerLazySingleton(() => LoadMunicipalitiesRepository());
  GetIt.I.registerLazySingleton(() => FetchMunicipalitiesService());
}
