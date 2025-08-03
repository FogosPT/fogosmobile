
import 'package:freezed_annotation/freezed_annotation.dart';

part 'icnf.freezed.dart';
part 'icnf.g.dart';

@freezed
abstract class Icnf with _$Icnf {
  factory Icnf() = _Icnf;
	
  factory Icnf.fromJson(Map<String, dynamic> json) =>
			_$IcnfFromJson(json);
}
