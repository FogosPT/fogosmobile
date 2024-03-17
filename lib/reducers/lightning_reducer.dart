import 'package:fogosmobile/actions/lightning_actions.dart';
import 'package:fogosmobile/models/lightning.dart';

lightningsReducer(List<Lightning>? lightnings, action) {
  if (action is LoadLightningsAction) {
    return lightnings;
  } else if (action is LightningsLoadedAction) {
    return action.lightnings;
  }
  return lightnings;
}
