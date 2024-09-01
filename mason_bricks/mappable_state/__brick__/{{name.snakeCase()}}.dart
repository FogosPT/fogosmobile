import 'package:dart_mappable/dart_mappable.dart';

part '{{name.snakeCase()}}.mapper.dart';

@MappableClass()
final class {{name}}State extends BaseState with {{name}}StateMappable {
  final List<String> labels;

  {{name}}State({
    super.status = StateStatus.initial,
    String? labels,
  }) : labels = labels ?? [];
}

extension {{name}}StateExtension on {{name}}State {
  {{name}}State failure() => copyWith(status: StateStatus.failure);
  {{name}}State loading() => copyWith(status: StateStatus.loading);
  {{name}}State success({
    List<String>? labels,
  }) =>
      copyWith(
        status: StateStatus.success,
        lables: labels,
      );
}
