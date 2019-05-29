import 'package:fogosmobile/models/warning.dart';

class LoadWarningsMadeiraAction {}

class WarningsMadeiraLoadedAction {
  final List<WarningMadeira> warnings;

  WarningsMadeiraLoadedAction(this.warnings);
}
