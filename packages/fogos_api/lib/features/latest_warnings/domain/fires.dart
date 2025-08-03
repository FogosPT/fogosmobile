import 'package:fogos_api/features/latest_warnings/domain/fire.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'fires.freezed.dart';
part 'fires.g.dart';

@freezed
abstract class Fires with _$Fires {
  const factory Fires({
    required bool success,
    required List<Fire> data,
  }) = _Fires;

  factory Fires.fromJson(Map<String, dynamic> json) => _$FiresFromJson(json);
}
