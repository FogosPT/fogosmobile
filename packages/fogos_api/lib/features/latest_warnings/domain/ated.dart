import 'package:freezed_annotation/freezed_annotation.dart';

part 'ated.freezed.dart';
part 'ated.g.dart';

@freezed
abstract class Ated with _$Ated {
  const factory Ated({
    required int sec,
  }) = _Ated;

  factory Ated.fromJson(Map<String, dynamic> json) => _$AtedFromJson(json);
  
}
