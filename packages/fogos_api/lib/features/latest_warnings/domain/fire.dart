import 'package:fogos_api/features/latest_warnings/domain/created.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'fire.freezed.dart';
part 'fire.g.dart';

@freezed
class Fire with _$Fire {
  const factory Fire({
    // @JsonKey(name: "_id") required Id id,
    required String id,
    required bool coords,
    required Created dateTime,
    required String date,
    required String hour,
    required String location,
    required int aerial,
    required int terrain,
    // required int meiosAquaticos,
    required int man,
    required String district,
    required String concelho,
    required String freguesia,
    required String dico,
    required double lat,
    required double lng,
    required String naturezaCode, // 3101, 3103, 3105, 3107
    required String natureza,
    // required dynamic especieName,
    // required dynamic familiaName,
    required int statusCode, // 3, 4, 5, 6
    required String
        statusColor, // Hexadecimal code representing colors, related with statusCode value.
    required String status,
    required bool important,
    // required String localidade,
    required bool active,
    required String sadoId,
    required int sharepointId,
    String? extra,
    required bool disappear,
    // required Icnf? icnf,
    // required String? detailLocation,
    // required dynamic kml,
    // required dynamic kmlVost,
    // required dynamic pco,
    // required dynamic cos,
    // required int heliFight,
    // required int heliCoord,
    // required int planeFight,
    // required bool anepcDirectUpdate,
    // required String regiao,
    // required String subRegiao,
    required Created created,
    required Created updated,
    FireStatus? fireStatus,
  }) = _Fire;

  factory Fire.fromJson(Map<String, dynamic> json) => _$FireFromJson(json);

  static FireStatus fromStatusToFireStatus(String status) {
    return switch (status) {
      'Ocorrência Significativa' => FireStatus.significativeOcurrence,
      'Vigilância' => FireStatus.vigilance,
      'Despacho' => FireStatus.dispatch,
      'Despacho de 1º Alerta' => FireStatus.firstAlertDispatch,
      'Chegada ao TO' => FireStatus.arrival,
      'Em Curso' => FireStatus.ongoing,
      'Em Resolução' => FireStatus.inResolution,
      'Conclusão' => FireStatus.inConclusion,
      'Encerrada' => FireStatus.done,
      'Falso Alarme' => FireStatus.falseAlarm,
      'Falso Alerta' => FireStatus.falseAlert,
      _ => FireStatus.unknown,
    };
  }
}

enum FireStatus {
  dispatch,
  significativeOcurrence,
  vigilance,
  firstAlertDispatch,
  arrival,
  ongoing,
  inResolution,
  inConclusion,
  done,
  falseAlarm,
  falseAlert,
  unknown,
}
