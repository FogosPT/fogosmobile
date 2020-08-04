
import 'package:fogosmobile/actions/lightning_actions.dart';

lightningsReducer(List lightnings, action) {
  if (action is LoadLightningsAction) {
    return lightnings;
  } else if (action is LightningsLoadedAction) {
    return action.lightnings;
  } else {
    return lightnings;
  }
}
