import 'package:fogosmobile/models/modis.dart';

class LoadModisAction {
  const LoadModisAction();
}

class ModisLoadedAction {
  final List<Modis> modis;

  const ModisLoadedAction(this.modis);
}

class ShowModisAction {
  const ShowModisAction();
}
