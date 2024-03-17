import 'package:warnings_api/networking/base_api.dart';

class FogosApi extends BaseApi {
  final String version;
  FogosApi(String apiUrl, this.version) : super(apiUrl: apiUrl);

  // Future<List<Incident>> getIncidents() async {
  //   final response = await get('v1/incidents');
  //   final List<dynamic> json = jsonDecode(response.body);
  //   return json.map((e) => Incident.fromJson(e)).toList();
  // }
}
