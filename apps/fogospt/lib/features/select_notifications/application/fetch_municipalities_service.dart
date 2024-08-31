import 'package:fogospt/features/select_notifications/data/load_municipalities_repository.dart';
import 'package:fogospt/features/select_notifications/domain/municipality_data.dart';
import 'package:get_it/get_it.dart';

class FetchMunicipalitiesService {
  LoadMunicipalitiesRepository _municipalitiesRepository =
      GetIt.I.get<LoadMunicipalitiesRepository>();

  Future<List<MunicipalityValue>> fetchAllMunicipalities() async {
    return _municipalitiesRepository.getMunicipalities();
  }

  // Future<Municipality?> getMunicipalityById(String key) async {
  //   final municipalities = await _municipalitiesRepository.getMunicipalities();
  //   return municipalities.firstWhere(
  //     (element) => element.key == key,
  //   );
  // }

  // Future<List<Municipality>> getMunicipalitiesByDistrictId(
  //   String districtId,
  // ) async {
  //   final municipalities = await _municipalitiesRepository.getMunicipalities();
  //   return municipalities
  //       .where((element) => element.value.districtId == districtId)
  //       .toList();
  // }

  // Future<List<Municipality>> getMunicipalitiesByDistrictName(
  //   String districtName,
  // ) async {
  //   final municipalities = await _municipalitiesRepository.getMunicipalities();
  //   return municipalities
  //       .where((element) => element.value.districtName == districtName)
  //       .toList();
  // }

  // Future<List<Municipality>> getMunicipalitiesByDistrictIdAndDistrictName(
  //   String districtId,
  //   String districtName,
  // ) async {
  //   final municipalities = await _municipalitiesRepository.getMunicipalities();
  //   return municipalities
  //       .where((element) =>
  //           element.value.districtId == districtId &&
  //           element.value.districtName == districtName)
  //       .toList();
  // }

  Future<Map<DistrictValue, List<MunicipalityValue>>>
      getMunicipalitiesPerDistrict() async {
    final municipalities = await _municipalitiesRepository.getMunicipalities();
    final municipalitiesPerDistrict =
        Map<DistrictValue, List<MunicipalityValue>>();

    municipalities.forEach(
      (municip) {
        final district = DistrictValue(
          id: municip.value.districtId,
          name: municip.value.districtName,
        );

        if (municipalitiesPerDistrict.containsKey(district)) {
          municipalitiesPerDistrict[district]!.add(municip);
        } else {
          municipalitiesPerDistrict[district] = [municip];
        }
      },
    );

    return municipalitiesPerDistrict;
  }
}
