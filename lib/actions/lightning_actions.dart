import 'package:fogosmobile/models/lightning.dart';

class LoadLightningsAction {
  const LoadLightningsAction();
}

class LightningsLoadedAction {
  final List<Lightning> lightnings;

  const LightningsLoadedAction(this.lightnings);
}
