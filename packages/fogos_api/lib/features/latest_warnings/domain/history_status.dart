import 'package:fogos_api/features/latest_warnings/domain/ated.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'history_status.freezed.dart';
part 'history_status.g.dart';

@freezed
abstract class HistoryStatus with _$HistoryStatus {
  const factory HistoryStatus({
    String? id,
    int? sharepointId,
    String? location,
    required String status,
    required int statusCode,
    required String label,
    required dynamic created,
    Ated? updated,
  }) = _HistoryStatus;

  factory HistoryStatus.fromJson(Map<String, dynamic> json) =>
      _$HistoryStatusFromJson(json);
}
