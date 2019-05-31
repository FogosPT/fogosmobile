import 'package:fogosmobile/models/warning.dart';

class LoadWarningsAction {}

class WarningsLoadedAction {
  final List<Warning> warnings;

  WarningsLoadedAction(this.warnings);
}

class LoadWarningsMadeiraAction {}

class WarningsMadeiraLoadedAction {
  final List<WarningMadeira> warnings;

  WarningsMadeiraLoadedAction(this.warnings);
}
