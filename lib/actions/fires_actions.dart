import 'package:fogosmobile/models/fire.dart';

class LoadFiresAction {}
class LoadFireAction {
  final String fireId;

  LoadFireAction(this.fireId);
}

class ClearFireAction {}

class FiresLoadedAction {
  final List fires;

  FiresLoadedAction(this.fires);
}

class FireLoadedAction {
  final Fire fire;

  FireLoadedAction(this.fire);
}