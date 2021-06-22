

import 'package:fogosmobile/actions/viirs_actions.dart';

viirsReducer(List viirs, action) {
  if (action is LoadViirsAction) {
    return viirs;
  } else if (action is ViirsLoadedAction) {
    return action.viirs;
  } else {
    return viirs;
  }
}
