import 'package:fogosmobile/models/plane.dart';

class LoadPlanesAction {}

class PlanesLoadedAction {
  final List<Plane> planes;

  PlanesLoadedAction(this.planes);
}

class ShowPlanesAction {}
