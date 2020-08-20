import 'package:fogosmobile/models/viirs.dart';

class LoadViirsAction {}

class ViirsLoadedAction {
  final List<Viirs> viirs;

  ViirsLoadedAction(this.viirs);
}

class ShowViirsAction {}
