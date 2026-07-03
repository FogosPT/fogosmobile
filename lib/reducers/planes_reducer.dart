import 'package:fogosmobile/actions/planes_actions.dart';
import 'package:fogosmobile/models/plane.dart';

List<Plane> planesReducer(List<Plane> planes, action) {
  if (action is PlanesLoadedAction) {
    return action.planes;
  }
  return planes;
}
