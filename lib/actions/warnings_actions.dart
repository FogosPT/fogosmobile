import 'package:fogosmobile/models/warning.dart';

class LoadWarningsAction {}

class LoadWarningsMadeiraAction {}

class WarningsLoadedAction {
  final List<Warning>? warnings;

  WarningsLoadedAction(this.warnings);
}

class WarningsMadeiraLoadedAction {
  final List<WarningMadeira>? warnings;

  WarningsMadeiraLoadedAction(this.warnings);
}
