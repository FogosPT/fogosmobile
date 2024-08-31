import 'package:dart_mappable/dart_mappable.dart';

part 'municipality_data.mapper.dart';

@MappableClass()
class MunicipalitiesData with MunicipalitiesDataMappable {
  @MappableField(key: 'rows')
  final List<Municipality> data;

  MunicipalitiesData({required this.data});
}

@MappableClass()
class Municipality with MunicipalityMappable {
  /// aka DICO
  final String key;
  final MunicipalityValue value;

  Municipality({
    required this.key,
    required this.value,
  });
}

@MappableClass()
class MunicipalityValue with MunicipalityValueMappable {
  final String name;

  @MappableField(key: 'dId')
  final String districtId;
  @MappableField(key: 'dName')
  final String districtName;

  MunicipalityValue({
    required this.name,
    required this.districtId,
    required this.districtName,
  });
}

@MappableClass()
class District with DistrictMappable {
  final String id;
  final String name;

  const District({
    required this.id,
    required this.name,
  });
}
