// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'municipality_data.dart';

class MunicipalitiesDataMapper extends ClassMapperBase<MunicipalitiesData> {
  MunicipalitiesDataMapper._();

  static MunicipalitiesDataMapper? _instance;
  static MunicipalitiesDataMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = MunicipalitiesDataMapper._());
      MunicipalityMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'MunicipalitiesData';

  static List<Municipality> _$data(MunicipalitiesData v) => v.data;
  static const Field<MunicipalitiesData, List<Municipality>> _f$data =
      Field('data', _$data, key: 'rows');

  @override
  final MappableFields<MunicipalitiesData> fields = const {
    #data: _f$data,
  };

  static MunicipalitiesData _instantiate(DecodingData data) {
    return MunicipalitiesData(data: data.dec(_f$data));
  }

  @override
  final Function instantiate = _instantiate;

  static MunicipalitiesData fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<MunicipalitiesData>(map);
  }

  static MunicipalitiesData fromJson(String json) {
    return ensureInitialized().decodeJson<MunicipalitiesData>(json);
  }
}

mixin MunicipalitiesDataMappable {
  String toJson() {
    return MunicipalitiesDataMapper.ensureInitialized()
        .encodeJson<MunicipalitiesData>(this as MunicipalitiesData);
  }

  Map<String, dynamic> toMap() {
    return MunicipalitiesDataMapper.ensureInitialized()
        .encodeMap<MunicipalitiesData>(this as MunicipalitiesData);
  }

  MunicipalitiesDataCopyWith<MunicipalitiesData, MunicipalitiesData,
          MunicipalitiesData>
      get copyWith => _MunicipalitiesDataCopyWithImpl(
          this as MunicipalitiesData, $identity, $identity);
  @override
  String toString() {
    return MunicipalitiesDataMapper.ensureInitialized()
        .stringifyValue(this as MunicipalitiesData);
  }

  @override
  bool operator ==(Object other) {
    return MunicipalitiesDataMapper.ensureInitialized()
        .equalsValue(this as MunicipalitiesData, other);
  }

  @override
  int get hashCode {
    return MunicipalitiesDataMapper.ensureInitialized()
        .hashValue(this as MunicipalitiesData);
  }
}

extension MunicipalitiesDataValueCopy<$R, $Out>
    on ObjectCopyWith<$R, MunicipalitiesData, $Out> {
  MunicipalitiesDataCopyWith<$R, MunicipalitiesData, $Out>
      get $asMunicipalitiesData =>
          $base.as((v, t, t2) => _MunicipalitiesDataCopyWithImpl(v, t, t2));
}

abstract class MunicipalitiesDataCopyWith<$R, $In extends MunicipalitiesData,
    $Out> implements ClassCopyWith<$R, $In, $Out> {
  ListCopyWith<$R, Municipality,
      MunicipalityCopyWith<$R, Municipality, Municipality>> get data;
  $R call({List<Municipality>? data});
  MunicipalitiesDataCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
      Then<$Out2, $R2> t);
}

class _MunicipalitiesDataCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, MunicipalitiesData, $Out>
    implements MunicipalitiesDataCopyWith<$R, MunicipalitiesData, $Out> {
  _MunicipalitiesDataCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<MunicipalitiesData> $mapper =
      MunicipalitiesDataMapper.ensureInitialized();
  @override
  ListCopyWith<$R, Municipality,
          MunicipalityCopyWith<$R, Municipality, Municipality>>
      get data => ListCopyWith(
          $value.data, (v, t) => v.copyWith.$chain(t), (v) => call(data: v));
  @override
  $R call({List<Municipality>? data}) =>
      $apply(FieldCopyWithData({if (data != null) #data: data}));
  @override
  MunicipalitiesData $make(CopyWithData data) =>
      MunicipalitiesData(data: data.get(#data, or: $value.data));

  @override
  MunicipalitiesDataCopyWith<$R2, MunicipalitiesData, $Out2> $chain<$R2, $Out2>(
          Then<$Out2, $R2> t) =>
      _MunicipalitiesDataCopyWithImpl($value, $cast, t);
}

class MunicipalityMapper extends ClassMapperBase<Municipality> {
  MunicipalityMapper._();

  static MunicipalityMapper? _instance;
  static MunicipalityMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = MunicipalityMapper._());
      MunicipalityValueMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'Municipality';

  static String _$key(Municipality v) => v.key;
  static const Field<Municipality, String> _f$key = Field('key', _$key);
  static MunicipalityValue _$value(Municipality v) => v.value;
  static const Field<Municipality, MunicipalityValue> _f$value =
      Field('value', _$value);

  @override
  final MappableFields<Municipality> fields = const {
    #key: _f$key,
    #value: _f$value,
  };

  static Municipality _instantiate(DecodingData data) {
    return Municipality(key: data.dec(_f$key), value: data.dec(_f$value));
  }

  @override
  final Function instantiate = _instantiate;

  static Municipality fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<Municipality>(map);
  }

  static Municipality fromJson(String json) {
    return ensureInitialized().decodeJson<Municipality>(json);
  }
}

mixin MunicipalityMappable {
  String toJson() {
    return MunicipalityMapper.ensureInitialized()
        .encodeJson<Municipality>(this as Municipality);
  }

  Map<String, dynamic> toMap() {
    return MunicipalityMapper.ensureInitialized()
        .encodeMap<Municipality>(this as Municipality);
  }

  MunicipalityCopyWith<Municipality, Municipality, Municipality> get copyWith =>
      _MunicipalityCopyWithImpl(this as Municipality, $identity, $identity);
  @override
  String toString() {
    return MunicipalityMapper.ensureInitialized()
        .stringifyValue(this as Municipality);
  }

  @override
  bool operator ==(Object other) {
    return MunicipalityMapper.ensureInitialized()
        .equalsValue(this as Municipality, other);
  }

  @override
  int get hashCode {
    return MunicipalityMapper.ensureInitialized()
        .hashValue(this as Municipality);
  }
}

extension MunicipalityValueCopy<$R, $Out>
    on ObjectCopyWith<$R, Municipality, $Out> {
  MunicipalityCopyWith<$R, Municipality, $Out> get $asMunicipality =>
      $base.as((v, t, t2) => _MunicipalityCopyWithImpl(v, t, t2));
}

abstract class MunicipalityCopyWith<$R, $In extends Municipality, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  MunicipalityValueCopyWith<$R, MunicipalityValue, MunicipalityValue> get value;
  $R call({String? key, MunicipalityValue? value});
  MunicipalityCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _MunicipalityCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, Municipality, $Out>
    implements MunicipalityCopyWith<$R, Municipality, $Out> {
  _MunicipalityCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<Municipality> $mapper =
      MunicipalityMapper.ensureInitialized();
  @override
  MunicipalityValueCopyWith<$R, MunicipalityValue, MunicipalityValue>
      get value => $value.value.copyWith.$chain((v) => call(value: v));
  @override
  $R call({String? key, MunicipalityValue? value}) => $apply(FieldCopyWithData(
      {if (key != null) #key: key, if (value != null) #value: value}));
  @override
  Municipality $make(CopyWithData data) => Municipality(
      key: data.get(#key, or: $value.key),
      value: data.get(#value, or: $value.value));

  @override
  MunicipalityCopyWith<$R2, Municipality, $Out2> $chain<$R2, $Out2>(
          Then<$Out2, $R2> t) =>
      _MunicipalityCopyWithImpl($value, $cast, t);
}

class MunicipalityValueMapper extends ClassMapperBase<MunicipalityValue> {
  MunicipalityValueMapper._();

  static MunicipalityValueMapper? _instance;
  static MunicipalityValueMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = MunicipalityValueMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'MunicipalityValue';

  static String _$name(MunicipalityValue v) => v.name;
  static const Field<MunicipalityValue, String> _f$name = Field('name', _$name);
  static String _$districtId(MunicipalityValue v) => v.districtId;
  static const Field<MunicipalityValue, String> _f$districtId =
      Field('districtId', _$districtId, key: 'dId');
  static String _$districtName(MunicipalityValue v) => v.districtName;
  static const Field<MunicipalityValue, String> _f$districtName =
      Field('districtName', _$districtName, key: 'dName');

  @override
  final MappableFields<MunicipalityValue> fields = const {
    #name: _f$name,
    #districtId: _f$districtId,
    #districtName: _f$districtName,
  };

  static MunicipalityValue _instantiate(DecodingData data) {
    return MunicipalityValue(
        name: data.dec(_f$name),
        districtId: data.dec(_f$districtId),
        districtName: data.dec(_f$districtName));
  }

  @override
  final Function instantiate = _instantiate;

  static MunicipalityValue fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<MunicipalityValue>(map);
  }

  static MunicipalityValue fromJson(String json) {
    return ensureInitialized().decodeJson<MunicipalityValue>(json);
  }
}

mixin MunicipalityValueMappable {
  String toJson() {
    return MunicipalityValueMapper.ensureInitialized()
        .encodeJson<MunicipalityValue>(this as MunicipalityValue);
  }

  Map<String, dynamic> toMap() {
    return MunicipalityValueMapper.ensureInitialized()
        .encodeMap<MunicipalityValue>(this as MunicipalityValue);
  }

  MunicipalityValueCopyWith<MunicipalityValue, MunicipalityValue,
          MunicipalityValue>
      get copyWith => _MunicipalityValueCopyWithImpl(
          this as MunicipalityValue, $identity, $identity);
  @override
  String toString() {
    return MunicipalityValueMapper.ensureInitialized()
        .stringifyValue(this as MunicipalityValue);
  }

  @override
  bool operator ==(Object other) {
    return MunicipalityValueMapper.ensureInitialized()
        .equalsValue(this as MunicipalityValue, other);
  }

  @override
  int get hashCode {
    return MunicipalityValueMapper.ensureInitialized()
        .hashValue(this as MunicipalityValue);
  }
}

extension MunicipalityValueValueCopy<$R, $Out>
    on ObjectCopyWith<$R, MunicipalityValue, $Out> {
  MunicipalityValueCopyWith<$R, MunicipalityValue, $Out>
      get $asMunicipalityValue =>
          $base.as((v, t, t2) => _MunicipalityValueCopyWithImpl(v, t, t2));
}

abstract class MunicipalityValueCopyWith<$R, $In extends MunicipalityValue,
    $Out> implements ClassCopyWith<$R, $In, $Out> {
  $R call({String? name, String? districtId, String? districtName});
  MunicipalityValueCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
      Then<$Out2, $R2> t);
}

class _MunicipalityValueCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, MunicipalityValue, $Out>
    implements MunicipalityValueCopyWith<$R, MunicipalityValue, $Out> {
  _MunicipalityValueCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<MunicipalityValue> $mapper =
      MunicipalityValueMapper.ensureInitialized();
  @override
  $R call({String? name, String? districtId, String? districtName}) =>
      $apply(FieldCopyWithData({
        if (name != null) #name: name,
        if (districtId != null) #districtId: districtId,
        if (districtName != null) #districtName: districtName
      }));
  @override
  MunicipalityValue $make(CopyWithData data) => MunicipalityValue(
      name: data.get(#name, or: $value.name),
      districtId: data.get(#districtId, or: $value.districtId),
      districtName: data.get(#districtName, or: $value.districtName));

  @override
  MunicipalityValueCopyWith<$R2, MunicipalityValue, $Out2> $chain<$R2, $Out2>(
          Then<$Out2, $R2> t) =>
      _MunicipalityValueCopyWithImpl($value, $cast, t);
}

class DistrictMapper extends ClassMapperBase<District> {
  DistrictMapper._();

  static DistrictMapper? _instance;
  static DistrictMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = DistrictMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'District';

  static String _$id(District v) => v.id;
  static const Field<District, String> _f$id = Field('id', _$id);
  static String _$name(District v) => v.name;
  static const Field<District, String> _f$name = Field('name', _$name);

  @override
  final MappableFields<District> fields = const {
    #id: _f$id,
    #name: _f$name,
  };

  static District _instantiate(DecodingData data) {
    return District(id: data.dec(_f$id), name: data.dec(_f$name));
  }

  @override
  final Function instantiate = _instantiate;

  static District fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<District>(map);
  }

  static District fromJson(String json) {
    return ensureInitialized().decodeJson<District>(json);
  }
}

mixin DistrictMappable {
  String toJson() {
    return DistrictMapper.ensureInitialized()
        .encodeJson<District>(this as District);
  }

  Map<String, dynamic> toMap() {
    return DistrictMapper.ensureInitialized()
        .encodeMap<District>(this as District);
  }

  DistrictCopyWith<District, District, District> get copyWith =>
      _DistrictCopyWithImpl(this as District, $identity, $identity);
  @override
  String toString() {
    return DistrictMapper.ensureInitialized().stringifyValue(this as District);
  }

  @override
  bool operator ==(Object other) {
    return DistrictMapper.ensureInitialized()
        .equalsValue(this as District, other);
  }

  @override
  int get hashCode {
    return DistrictMapper.ensureInitialized().hashValue(this as District);
  }
}

extension DistrictValueCopy<$R, $Out> on ObjectCopyWith<$R, District, $Out> {
  DistrictCopyWith<$R, District, $Out> get $asDistrict =>
      $base.as((v, t, t2) => _DistrictCopyWithImpl(v, t, t2));
}

abstract class DistrictCopyWith<$R, $In extends District, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({String? id, String? name});
  DistrictCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _DistrictCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, District, $Out>
    implements DistrictCopyWith<$R, District, $Out> {
  _DistrictCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<District> $mapper =
      DistrictMapper.ensureInitialized();
  @override
  $R call({String? id, String? name}) => $apply(FieldCopyWithData(
      {if (id != null) #id: id, if (name != null) #name: name}));
  @override
  District $make(CopyWithData data) => District(
      id: data.get(#id, or: $value.id), name: data.get(#name, or: $value.name));

  @override
  DistrictCopyWith<$R2, District, $Out2> $chain<$R2, $Out2>(
          Then<$Out2, $R2> t) =>
      _DistrictCopyWithImpl($value, $cast, t);
}
