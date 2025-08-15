import 'package:fogos_api/features/mobile_contributors/domain/contributor.dart'
    show Contributor;
import 'package:fogos_api/networking/fogos_base_client.dart'
    show FogosBaseClient;

class ContributorsService {
  final FogosBaseClient _fogosApi;

  ContributorsService(this._fogosApi);

  Future<List<Contributor>> getContributors() async {
    final response = await _fogosApi.getMobileContributors();

    if (response.statusCode != 200) {
      throw Exception('Failed to fetch contributors');
    }

    final body = response.body as Map<String, dynamic>;
    final contributors = Contributor.fromList(body['data'] as List<dynamic>);

    return contributors;
  }

  void dispose() {
    _fogosApi.dispose();
  }
}
