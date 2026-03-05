import 'package:fogosmobile/actions/other_fires_actions.dart';
import 'package:fogosmobile/models/fire.dart';

List<Fire> otherFiresReducer(List<Fire> fires, action) {
  if (action is LoadOtherFiresAction) {
    return fires;
  } else if (action is OtherFiresLoadedAction) {
    return action.fires;
  } else {
    return fires;
  }
}
