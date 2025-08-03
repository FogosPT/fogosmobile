import 'package:freezed_annotation/freezed_annotation.dart';

part 'created.freezed.dart';
part 'created.g.dart';

@freezed
abstract class Created with _$Created {
  factory Created({
    required int sec,
  }) = _Created;

  factory Created.fromJson(Map<String, dynamic> json) =>
      _$CreatedFromJson(json);
}
