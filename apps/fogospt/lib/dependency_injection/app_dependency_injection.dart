import 'package:fogos_api/features/mobile_contributors/data/contributors_service.dart';
import 'package:fogos_api/networking/fogos_base_client.dart'
    show FogosBaseClient;
import 'package:fogospt/features/select_notifications/application/fetch_municipalities_service.dart';
import 'package:fogospt/features/select_notifications/data/load_municipalities_repository.dart';
import 'package:get_it/get_it.dart';

Future<void> setupAppDependencyInjection() async {
  GetIt.I.registerLazySingleton(() => LoadMunicipalitiesRepository());
  GetIt.I.registerLazySingleton(() => FetchMunicipalitiesService());
  GetIt.I.registerLazySingleton(
    () => ContributorsService(GetIt.I.get<FogosBaseClient>()),
  );
}
