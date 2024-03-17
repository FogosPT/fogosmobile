import 'package:fogosmobile/actions/viirs_actions.dart';
import 'package:fogosmobile/models/viirs.dart';

viirsReducer(List<Viirs>? viirs, action) {
  if (action is LoadViirsAction) {
    return viirs;
  } else if (action is ViirsLoadedAction) {
    return action.viirs;
  }
  return viirs;
}
