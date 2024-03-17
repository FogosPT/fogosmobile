import 'package:warnings_api/environment.dart';

abstract class BaseClient {
  final Environment environment;

  BaseClient({required this.environment});
}
