import 'package:warnings_api/environment.dart';

class FogosEnvironment extends Environment {
  const FogosEnvironment({required super.baseUrl});

  factory FogosEnvironment.dev() {
    return const FogosEnvironment(baseUrl: 'https://api.fogos.pt/');
  }
  factory FogosEnvironment.production() {
    return const FogosEnvironment(baseUrl: 'https://api.fogos.pt/');
  }
  factory FogosEnvironment.staging() {
    return const FogosEnvironment(baseUrl: 'https://api.fogos.pt/');
  }
}
