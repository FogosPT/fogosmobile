import 'package:fogospt/features/notifications/data/municipalities_repository.dart';
import 'package:fogospt/features/notifications/domain/municipality_data.dart';
import 'package:get_it/get_it.dart';

class MunicipalitiesService {
  MunicipalitiesRepository _municipalitiesRepository =
      GetIt.I.get<MunicipalitiesRepository>();

  Future<List<Municipality>> fetchAllMunicipalities() async {
    return _municipalitiesRepository.getMunicipalities();
  }

  Future<Municipality?> getMunicipalityById(String key) async {
    final municipalities = await _municipalitiesRepository.getMunicipalities();
    return municipalities.firstWhere(
      (element) => element.key == key,
    );
  }
}
