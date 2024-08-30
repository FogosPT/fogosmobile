import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> setupAppDependencyInjectionDataSources() async {
  GetIt.I.registerLazySingletonAsync(() => SharedPreferences.getInstance());
}
