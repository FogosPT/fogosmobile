import 'package:fogosmobile/actions/fires_actions.dart';
import 'package:fogosmobile/models/fire.dart';
import 'package:fogosmobile/models/fire_details.dart';

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

fireMeansHistoryReducer(MeansHistory data, action) {
  if (action is LoadFireMeansHistoryAction) {
    return data;
  } else if (action is FireMeansHistoryLoadedAction) {
    return action.data;
  } else if (action is ClearFireMeansAction) {
    return null;
  } else {
    return data;
  }
}

fireDetailsHistoryReducer(DetailsHistory data, action) {
  if (action is LoadFireDetailsHistoryAction) {
    return data;
  } else if (action is FireDetailsHistoryLoadedAction) {
    return action.data;
  } else if (action is ClearFireDetailsAction) {
    return null;
  } else {
    return data;
  }
}

fireRiskReducer(String data, action) {
  if (action is LoadFireRiskAction) {
    return data;
  } else if (action is FireRiskLoadedAction) {
    return action.risk;
  } else if (action is ClearFireRiskAction) {
    return null;
  } else {
    return data;
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
