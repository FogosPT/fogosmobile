import 'package:fogos_api/features/latest_warnings/data/fires_service.dart'
    show FiresService;
import 'package:fogos_api/features/mobile_contributors/data/contributors_service.dart'
    show ContributorsService;
import 'package:fogos_api/fogos_environment.dart';
import 'package:fogos_api/networking/fogos_api.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

void setupFogosAPIDependencyInjection() {

  final environment = FogosEnvironment.dev();

  getIt.registerLazySingleton<FiresService>(
    () => FiresService(FogosApi(fogosEnvironment: environment)),
    dispose: (obj) => obj.dispose(),
  );

  getIt.registerLazySingleton<ContributorsService>(
    () => ContributorsService(FogosApi(fogosEnvironment: environment),
    ),
    dispose: (obj) => obj.dispose(),
  );
}
