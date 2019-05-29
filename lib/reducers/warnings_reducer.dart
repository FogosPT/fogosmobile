import 'package:fogosmobile/actions/warnings_actions.dart';

warningsMadeiraReducer(List warnings, action) {
  if (action is LoadWarningsMadeiraAction) {
    return warnings;
  } else if (action is WarningsMadeiraLoadedAction) {
    return action.warnings;
  } else {
    return warnings;
  }
}
