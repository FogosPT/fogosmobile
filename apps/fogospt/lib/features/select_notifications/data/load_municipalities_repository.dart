import 'dart:async';

import 'package:dart_mappable/dart_mappable.dart';
import 'package:fogospt/features/select_notifications/domain/municipality_data.dart';
import 'package:warnings/warnings.dart';

class LoadMunicipalitiesRepository {
  MunicipalitiesData? _municipalitiesData;

  Future<List<MunicipalityValue>> getMunicipalities() async {
    if (_municipalitiesData == null) {
      _municipalitiesData = await _processMunicipalitiesData();
    }
    return _municipalitiesData!.data;
  }

  Future<String> _loadMunicipalitiesData() async {
    final json = await loadJsonFromAssets('assets/data/concelhos.json');
    return json;
  }

  Future<MunicipalitiesData> _processMunicipalitiesData() async {
    try {
      final rawData = await _loadMunicipalitiesData();
      final municipalitiesData = MunicipalitiesDataMapper.fromJson(rawData);
      municipalitiesData.data.sort((a, b) => a.key.compareTo(b.key));
      return municipalitiesData;
    } on MapperException catch (e) {
      throw Exception('Failed to load municipalities data: $e');
    }
  }
}
