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
      MunicipalityValueMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'MunicipalitiesData';

  static List<MunicipalityValue> _$data(MunicipalitiesData v) => v.data;
  static const Field<MunicipalitiesData, List<MunicipalityValue>> _f$data =
      Field('data', _$data, key: r'rows');

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
      get copyWith => _MunicipalitiesDataCopyWithImpl<MunicipalitiesData,
          MunicipalitiesData>(this as MunicipalitiesData, $identity, $identity);
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
      get $asMunicipalitiesData => $base.as(
          (v, t, t2) => _MunicipalitiesDataCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class MunicipalitiesDataCopyWith<$R, $In extends MunicipalitiesData,
    $Out> implements ClassCopyWith<$R, $In, $Out> {
  ListCopyWith<$R, MunicipalityValue,
          MunicipalityValueCopyWith<$R, MunicipalityValue, MunicipalityValue>>
      get data;
  $R call({List<MunicipalityValue>? data});
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
  ListCopyWith<$R, MunicipalityValue,
          MunicipalityValueCopyWith<$R, MunicipalityValue, MunicipalityValue>>
      get data => ListCopyWith(
          $value.data, (v, t) => v.copyWith.$chain(t), (v) => call(data: v));
  @override
  $R call({List<MunicipalityValue>? data}) =>
      $apply(FieldCopyWithData({if (data != null) #data: data}));
  @override
  MunicipalitiesData $make(CopyWithData data) =>
      MunicipalitiesData(data: data.get(#data, or: $value.data));

  @override
  MunicipalitiesDataCopyWith<$R2, MunicipalitiesData, $Out2> $chain<$R2, $Out2>(
          Then<$Out2, $R2> t) =>
      _MunicipalitiesDataCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class MunicipalityValueMapper extends ClassMapperBase<MunicipalityValue> {
  MunicipalityValueMapper._();

  static MunicipalityValueMapper? _instance;
  static MunicipalityValueMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = MunicipalityValueMapper._());
      MunicipalityInformationValueMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'MunicipalityValue';

  static String _$key(MunicipalityValue v) => v.key;
  static const Field<MunicipalityValue, String> _f$key = Field('key', _$key);
  static MunicipalityInformationValue _$value(MunicipalityValue v) => v.value;
  static const Field<MunicipalityValue, MunicipalityInformationValue> _f$value =
      Field('value', _$value);

  @override
  final MappableFields<MunicipalityValue> fields = const {
    #key: _f$key,
    #value: _f$value,
  };

  static MunicipalityValue _instantiate(DecodingData data) {
    return MunicipalityValue(key: data.dec(_f$key), value: data.dec(_f$value));
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
      get copyWith =>
          _MunicipalityValueCopyWithImpl<MunicipalityValue, MunicipalityValue>(
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
      get $asMunicipalityValue => $base
          .as((v, t, t2) => _MunicipalityValueCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class MunicipalityValueCopyWith<$R, $In extends MunicipalityValue,
    $Out> implements ClassCopyWith<$R, $In, $Out> {
  MunicipalityInformationValueCopyWith<$R, MunicipalityInformationValue,
      MunicipalityInformationValue> get value;
  $R call({String? key, MunicipalityInformationValue? value});
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
  MunicipalityInformationValueCopyWith<$R, MunicipalityInformationValue,
          MunicipalityInformationValue>
      get value => $value.value.copyWith.$chain((v) => call(value: v));
  @override
  $R call({String? key, MunicipalityInformationValue? value}) =>
      $apply(FieldCopyWithData(
          {if (key != null) #key: key, if (value != null) #value: value}));
  @override
  MunicipalityValue $make(CopyWithData data) => MunicipalityValue(
      key: data.get(#key, or: $value.key),
      value: data.get(#value, or: $value.value));

  @override
  MunicipalityValueCopyWith<$R2, MunicipalityValue, $Out2> $chain<$R2, $Out2>(
          Then<$Out2, $R2> t) =>
      _MunicipalityValueCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class MunicipalityInformationValueMapper
    extends ClassMapperBase<MunicipalityInformationValue> {
  MunicipalityInformationValueMapper._();

  static MunicipalityInformationValueMapper? _instance;
  static MunicipalityInformationValueMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals
          .use(_instance = MunicipalityInformationValueMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'MunicipalityInformationValue';

  static String _$name(MunicipalityInformationValue v) => v.name;
  static const Field<MunicipalityInformationValue, String> _f$name =
      Field('name', _$name);
  static String _$districtId(MunicipalityInformationValue v) => v.districtId;
  static const Field<MunicipalityInformationValue, String> _f$districtId =
      Field('districtId', _$districtId, key: r'dId');
  static String _$districtName(MunicipalityInformationValue v) =>
      v.districtName;
  static const Field<MunicipalityInformationValue, String> _f$districtName =
      Field('districtName', _$districtName, key: r'dName');

  @override
  final MappableFields<MunicipalityInformationValue> fields = const {
    #name: _f$name,
    #districtId: _f$districtId,
    #districtName: _f$districtName,
  };

  static MunicipalityInformationValue _instantiate(DecodingData data) {
    return MunicipalityInformationValue(
        name: data.dec(_f$name),
        districtId: data.dec(_f$districtId),
        districtName: data.dec(_f$districtName));
  }

  @override
  final Function instantiate = _instantiate;

  static MunicipalityInformationValue fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<MunicipalityInformationValue>(map);
  }

  static MunicipalityInformationValue fromJson(String json) {
    return ensureInitialized().decodeJson<MunicipalityInformationValue>(json);
  }
}

mixin MunicipalityInformationValueMappable {
  String toJson() {
    return MunicipalityInformationValueMapper.ensureInitialized()
        .encodeJson<MunicipalityInformationValue>(
            this as MunicipalityInformationValue);
  }

  Map<String, dynamic> toMap() {
    return MunicipalityInformationValueMapper.ensureInitialized()
        .encodeMap<MunicipalityInformationValue>(
            this as MunicipalityInformationValue);
  }

  MunicipalityInformationValueCopyWith<MunicipalityInformationValue,
          MunicipalityInformationValue, MunicipalityInformationValue>
      get copyWith => _MunicipalityInformationValueCopyWithImpl<
              MunicipalityInformationValue, MunicipalityInformationValue>(
          this as MunicipalityInformationValue, $identity, $identity);
  @override
  String toString() {
    return MunicipalityInformationValueMapper.ensureInitialized()
        .stringifyValue(this as MunicipalityInformationValue);
  }

  @override
  bool operator ==(Object other) {
    return MunicipalityInformationValueMapper.ensureInitialized()
        .equalsValue(this as MunicipalityInformationValue, other);
  }

  @override
  int get hashCode {
    return MunicipalityInformationValueMapper.ensureInitialized()
        .hashValue(this as MunicipalityInformationValue);
  }
}

extension MunicipalityInformationValueValueCopy<$R, $Out>
    on ObjectCopyWith<$R, MunicipalityInformationValue, $Out> {
  MunicipalityInformationValueCopyWith<$R, MunicipalityInformationValue, $Out>
      get $asMunicipalityInformationValue => $base.as((v, t, t2) =>
          _MunicipalityInformationValueCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class MunicipalityInformationValueCopyWith<
    $R,
    $In extends MunicipalityInformationValue,
    $Out> implements ClassCopyWith<$R, $In, $Out> {
  $R call({String? name, String? districtId, String? districtName});
  MunicipalityInformationValueCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
      Then<$Out2, $R2> t);
}

class _MunicipalityInformationValueCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, MunicipalityInformationValue, $Out>
    implements
        MunicipalityInformationValueCopyWith<$R, MunicipalityInformationValue,
            $Out> {
  _MunicipalityInformationValueCopyWithImpl(
      super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<MunicipalityInformationValue> $mapper =
      MunicipalityInformationValueMapper.ensureInitialized();
  @override
  $R call({String? name, String? districtId, String? districtName}) =>
      $apply(FieldCopyWithData({
        if (name != null) #name: name,
        if (districtId != null) #districtId: districtId,
        if (districtName != null) #districtName: districtName
      }));
  @override
  MunicipalityInformationValue $make(CopyWithData data) =>
      MunicipalityInformationValue(
          name: data.get(#name, or: $value.name),
          districtId: data.get(#districtId, or: $value.districtId),
          districtName: data.get(#districtName, or: $value.districtName));

  @override
  MunicipalityInformationValueCopyWith<$R2, MunicipalityInformationValue, $Out2>
      $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
          _MunicipalityInformationValueCopyWithImpl<$R2, $Out2>(
              $value, $cast, t);
}

class DistrictValueMapper extends ClassMapperBase<DistrictValue> {
  DistrictValueMapper._();

  static DistrictValueMapper? _instance;
  static DistrictValueMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = DistrictValueMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'DistrictValue';

  static String _$id(DistrictValue v) => v.id;
  static const Field<DistrictValue, String> _f$id = Field('id', _$id);
  static String _$name(DistrictValue v) => v.name;
  static const Field<DistrictValue, String> _f$name = Field('name', _$name);

  @override
  final MappableFields<DistrictValue> fields = const {
    #id: _f$id,
    #name: _f$name,
  };

  static DistrictValue _instantiate(DecodingData data) {
    return DistrictValue(id: data.dec(_f$id), name: data.dec(_f$name));
  }

  @override
  final Function instantiate = _instantiate;

  static DistrictValue fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<DistrictValue>(map);
  }

  static DistrictValue fromJson(String json) {
    return ensureInitialized().decodeJson<DistrictValue>(json);
  }
}

mixin DistrictValueMappable {
  String toJson() {
    return DistrictValueMapper.ensureInitialized()
        .encodeJson<DistrictValue>(this as DistrictValue);
  }

  Map<String, dynamic> toMap() {
    return DistrictValueMapper.ensureInitialized()
        .encodeMap<DistrictValue>(this as DistrictValue);
  }

  DistrictValueCopyWith<DistrictValue, DistrictValue, DistrictValue>
      get copyWith => _DistrictValueCopyWithImpl<DistrictValue, DistrictValue>(
          this as DistrictValue, $identity, $identity);
  @override
  String toString() {
    return DistrictValueMapper.ensureInitialized()
        .stringifyValue(this as DistrictValue);
  }

  @override
  bool operator ==(Object other) {
    return DistrictValueMapper.ensureInitialized()
        .equalsValue(this as DistrictValue, other);
  }

  @override
  int get hashCode {
    return DistrictValueMapper.ensureInitialized()
        .hashValue(this as DistrictValue);
  }
}

extension DistrictValueValueCopy<$R, $Out>
    on ObjectCopyWith<$R, DistrictValue, $Out> {
  DistrictValueCopyWith<$R, DistrictValue, $Out> get $asDistrictValue =>
      $base.as((v, t, t2) => _DistrictValueCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class DistrictValueCopyWith<$R, $In extends DistrictValue, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({String? id, String? name});
  DistrictValueCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _DistrictValueCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, DistrictValue, $Out>
    implements DistrictValueCopyWith<$R, DistrictValue, $Out> {
  _DistrictValueCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<DistrictValue> $mapper =
      DistrictValueMapper.ensureInitialized();
  @override
  $R call({String? id, String? name}) => $apply(FieldCopyWithData(
      {if (id != null) #id: id, if (name != null) #name: name}));
  @override
  DistrictValue $make(CopyWithData data) => DistrictValue(
      id: data.get(#id, or: $value.id), name: data.get(#name, or: $value.name));

  @override
  DistrictValueCopyWith<$R2, DistrictValue, $Out2> $chain<$R2, $Out2>(
          Then<$Out2, $R2> t) =>
      _DistrictValueCopyWithImpl<$R2, $Out2>($value, $cast, t);
}
