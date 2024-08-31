import 'package:dart_mappable/dart_mappable.dart';

part 'municipality_data.mapper.dart';

@MappableClass()
class MunicipalitiesData with MunicipalitiesDataMappable {
  @MappableField(key: 'rows')
  final List<MunicipalityValue> data;

  MunicipalitiesData({required this.data});
}

@MappableClass()
class MunicipalityValue with MunicipalityValueMappable {
  /// aka DICO
  final String key;
  final MunicipalityInformationValue value;

  MunicipalityValue({
    required this.key,
    required this.value,
  });
}

@MappableClass()
class MunicipalityInformationValue with MunicipalityInformationValueMappable {
  final String name;

  @MappableField(key: 'dId')
  final String districtId;
  @MappableField(key: 'dName')
  final String districtName;

  MunicipalityInformationValue({
    required this.name,
    required this.districtId,
    required this.districtName,
  });
}

@MappableClass()
class DistrictValue with DistrictValueMappable {
  final String id;
  final String name;

  const DistrictValue({
    required this.id,
    required this.name,
  });
}
