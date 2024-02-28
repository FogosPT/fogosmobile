import 'package:fogosmobile/actions/modis_actions.dart';
import 'package:fogosmobile/models/modis.dart';

modisReducer(List<Modis>? modis, action) {
  if (action is LoadModisAction) {
    return modis;
  } else if (action is ModisLoadedAction) {
    return action.modis;
  } else {
    return modis;
  }
}
