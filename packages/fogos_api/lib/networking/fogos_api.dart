import 'package:http/http.dart' as http;
import 'package:sentry_flutter/sentry_flutter.dart';

import 'fogos_base_client.dart';

class FogosApi extends FogosBaseClient {
  late final SentryHttpClient client;

  FogosApi({required super.fogosEnvironment}) {
    client = SentryHttpClient(client: http.Client());
  }

  @override
  Future<http.Response> listActiveFires() {
    return client.get(Uri.parse("${environment.baseUrl}/v2/incidents/active"));
  }

  @override
  Future<http.Response> getFireHistoryResourcesManAerialTerrain(String id) {
    return client.get(Uri.parse("${environment.baseUrl}/fires/data?id=$id"));
  }

  @override
  Future<http.Response> getFireHistoryStatus(String id) {
    return client.get(Uri.parse("${environment.baseUrl}/fires/status?id=$id"));
  }

  @override
  Future<http.Response> getFireRCMForTodayTomorrowAndAfter(String id) {
    return client.get(Uri.parse("${environment.baseUrl}/fires/danger?id=$id"));
  }

  @override
  Future<http.Response> getSingleFireInformation(String id) {
    return client.get(Uri.parse("${environment.baseUrl}/fires?id=$id"));
  }

  @override
  void dispose() {
    client.close();
  }
  
  @override
  Future<http.Response> getMobileContributors() {
    return client.get(
      Uri.parse("${environment.baseUrl}/v1/mobile-contributors"),
    );
  }
}
