import 'package:fogos_api/features/latest_warnings/data/fires_repository.dart';
import 'package:fogos_api/fogos_environment.dart';
import 'package:fogos_api/networking/fogos_api.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

void setupFogosAPIDependencyInjection() {
  getIt.registerLazySingleton<FiresRepository>(
    () => FiresRepository(
      FogosApi(fogosEnvironment: FogosEnvironment.dev()),
    ),
    dispose: (obj) => obj.dispose(),
  );
}
