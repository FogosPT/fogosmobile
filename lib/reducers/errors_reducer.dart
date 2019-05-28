import 'package:fogosmobile/actions/errors_actions.dart';

errorsReducer(dynamic errors, action) {
  if (action is ClearErrorsAction) {
    return [];
  } else if (action is AddErrorAction) {
    if (errors == null) {
      errors = [];
    }
    errors.add(action.error);
    return errors;
  } else if (action is RemoveErrorAction) {
    if (errors == null) {
      errors = [];
      return errors;
    }

    if (errors.contains(action.error)) {
      errors.remove(action.error);
      return errors;
    }

    return errors;
  } else {
    return errors;
  }
}
