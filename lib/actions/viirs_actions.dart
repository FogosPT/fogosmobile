import 'package:fogosmobile/models/viirs.dart';

class LoadViirsAction {
  const LoadViirsAction();
}

class ViirsLoadedAction {
  final List<Viirs> viirs;

  const ViirsLoadedAction(this.viirs);
}

class ShowViirsAction {
  const ShowViirsAction();
}
