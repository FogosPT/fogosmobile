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

  @override
  String toString() {
    return 'Fires loaded {fires: $fires}';
  }
}

class FireLoadedAction {
  final Fire fire;

  FireLoadedAction(this.fire);

  @override
  String toString() {
    return 'Fire loaded: $fire';
  }
}