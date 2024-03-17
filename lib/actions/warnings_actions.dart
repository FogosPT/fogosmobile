import 'package:fogosmobile/models/warning.dart';

class LoadWarningsAction {
  const LoadWarningsAction();
}

class LoadWarningsMadeiraAction {
  const LoadWarningsMadeiraAction();
}

class WarningsLoadedAction {
  final List<Warning>? warnings;

  const WarningsLoadedAction(this.warnings);
}

class WarningsMadeiraLoadedAction {
  final List<WarningMadeira>? warnings;

  const WarningsMadeiraLoadedAction(this.warnings);
}
