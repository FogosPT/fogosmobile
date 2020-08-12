
import 'package:fogosmobile/actions/modis_actions.dart';

modisReducer(List modis, action) {
  if (action is LoadModisAction) {
    return modis;
  } else if (action is ModisLoadedAction) {
    return action.modis;
  } else {
    return modis;
  }
}
