
import 'package:fogosmobile/models/lightning.dart';

class LoadLightningsAction {}

class LightningsLoadedAction {
  final List<Lightning> lightnings;

  LightningsLoadedAction(this.lightnings);
}
