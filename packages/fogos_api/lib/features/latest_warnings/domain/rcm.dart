import 'package:fogos_api/features/latest_warnings/domain/ated.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'rcm.freezed.dart';
part 'rcm.g.dart';

@freezed
abstract class RCM with _$RCM {
  const factory RCM({
    // ignore: invalid_annotation_target
    @JsonKey(name: '_id') required String id,
    required String concelho,
    required DateTime date,
    required String hoje,
    required String amanha,
    required String depois,
    required String depois2,
    required String depois3,
    required String dico,
    required Ated updated,
    required Ated created,
  }) = _RCM;

  factory RCM.fromJson(Map<String, dynamic> json) => _$RCMFromJson(json);
}
