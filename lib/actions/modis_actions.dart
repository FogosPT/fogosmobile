import 'package:fogosmobile/models/modis.dart';

class LoadModisAction {}

class ModisLoadedAction {
  final List<Modis> modis;

  ModisLoadedAction(this.modis);
}

class ShowModisAction {}
