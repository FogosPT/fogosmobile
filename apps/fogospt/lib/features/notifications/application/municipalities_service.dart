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

  Future<List<Municipality>> getMunicipalitiesByDistrictId(
    String districtId,
  ) async {
    final municipalities = await _municipalitiesRepository.getMunicipalities();
    return municipalities
        .where((element) => element.value.districtId == districtId)
        .toList();
  }

  Future<List<Municipality>> getMunicipalitiesByDistrictName(
    String districtName,
  ) async {
    final municipalities = await _municipalitiesRepository.getMunicipalities();
    return municipalities
        .where((element) => element.value.districtName == districtName)
        .toList();
  }

  Future<List<Municipality>> getMunicipalitiesByDistrictIdAndDistrictName(
    String districtId,
    String districtName,
  ) async {
    final municipalities = await _municipalitiesRepository.getMunicipalities();
    return municipalities
        .where((element) =>
            element.value.districtId == districtId &&
            element.value.districtName == districtName)
        .toList();
  }

  Future<Map<District, List<Municipality>>>
      getMunicipalitiesPerDistrict() async {
    final municipalities = await _municipalitiesRepository.getMunicipalities();
    final municipalitiesPerDistrict = Map<District, List<Municipality>>();

    municipalities.forEach((element) {
      final districtId = element.value.districtId;
      final districtName = element.value.districtName;
      final district = District(id: districtId, name: districtName);

      if (municipalitiesPerDistrict.containsKey(district)) {
        municipalitiesPerDistrict[element.value.districtId]!.add(element);
      } else {
        municipalitiesPerDistrict[district] = [element];
      }
    });

    return municipalitiesPerDistrict;
  }
}
