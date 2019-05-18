import 'package:fogosmobile/actions/fires_actions.dart';
import 'package:fogosmobile/models/fire.dart';

firesReducer(List fires, action) {
  if (action is LoadFiresAction) {
    return fires;
  } else if (action is FiresLoadedAction) {
    return action.fires;
  } else {
    return fires;
  }
}

fireReducer(Fire fire, action) {
  if (action is LoadFireAction) {
    return fire;
  } else if (action is FireLoadedAction) {
    return action.fire;
  } else if (action is ClearFireAction) {
    return null;
  } else {
    return fire;
  }
}

filtersReducer(List filters, action) {
  if (action is SelectFireFiltersAction) {
    if (filters.contains(action.filter)) {
      if (filters.length > 1) filters.remove(action.filter);
    } else {
      filters.add(action.filter);
    }
    return filters;
  } else {
    return filters;
  }
}
