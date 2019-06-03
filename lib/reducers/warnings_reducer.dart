import 'package:fogosmobile/actions/warnings_actions.dart';

warningsReducer(List warnings, action) {
  if (action is LoadWarningsAction) {
    return warnings;
  } else if (action is WarningsLoadedAction) {
    return action.warnings;
  } else {
    return warnings;
  }
}

warningsMadeiraReducer(List warnings, action) {
  if (action is LoadWarningsMadeiraAction) {
    return warnings;
  } else if (action is WarningsMadeiraLoadedAction) {
    return action.warnings;
  } else {
    return warnings;
  }
}
