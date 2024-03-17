import 'package:fogos_api/fogos_environment.dart';
import 'package:warnings_api/networking/base_client.dart';

abstract class FogosBaseClient extends BaseClient {
  final String version;
  FogosBaseClient(this.version, {required FogosEnvironment fogosEnvironment})
      : super(environment: fogosEnvironment);

  // getActiveFires
  // void getActiveFires();
  // searchIncidents
  // void getSearchIncidents();

  // Future<List<Incident>> getIncidents() async {
  //   final response = await get('v1/incidents');
  //   final List<dynamic> json = jsonDecode(response.body);
  //   return json.map((e) => Incident.fromJson(e)).toList();
  // }
}
