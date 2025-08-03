import 'package:freezed_annotation/freezed_annotation.dart';

part 'resources.freezed.dart';
part 'resources.g.dart';

@freezed
abstract class Resources with _$Resources {
  const factory Resources({
    required String label,
    required int man,
    required int terrain,
    required int aerial,
    required int created,
    String? location,
    String? personId,
    String? id,
  }) = _Resources;

  factory Resources.fromJson(Map<String, dynamic> json) =>
      _$ResourcesFromJson(json);
}
