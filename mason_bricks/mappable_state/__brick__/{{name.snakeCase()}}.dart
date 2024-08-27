import 'package:dart_mappable/dart_mappable.dart';

part '{{name.snakeCase()}}.mapper.dart';


@MappableClass()
sealed class {{name}}State with {{name}}StateMappable {}

@MappableClass()
class {{name}}Started extends {{name}}State with {{name}}StartedMappable {}

@MappableClass()
class {{name}}Loading extends {{name}}State with {{name}}LoadingMappable {}

@MappableClass()
class {{name}}Successful extends {{name}}State with {{name}}SuccessfulMappable {

  {{name}}Successful();
}

@MappableClass()
class {{name}}Failed extends {{name}}State with {{name}}FailedMappable {}
