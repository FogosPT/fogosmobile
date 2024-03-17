import 'package:fogosmobile/actions/fires_actions.dart';
import 'package:fogosmobile/models/fire.dart';
import 'package:fogosmobile/models/fire_details.dart';

filtersReducer(List? filters, action) {
  if (action is SavedFireFiltersAction) {
    return action.filters;
  }
  return filters;
}

fireDetailsHistoryReducer(DetailsHistory? data, action) {
  if (action is LoadFireDetailsHistoryAction) {
    return data;
  } else if (action is FireDetailsHistoryLoadedAction) {
    return action.data;
  } else if (action is ClearFireDetailsAction) {
    return null;
  }
  return data;
}

fireMeansHistoryReducer(MeansHistory? data, action) {
  if (action is LoadFireMeansHistoryAction) {
    return data;
  } else if (action is FireMeansHistoryLoadedAction) {
    return action.data;
  } else if (action is ClearFireMeansAction) {
    return null;
  }
  return data;
}

fireReducer(Fire? fire, action) {
  if (action is LoadFireAction) {
    return fire;
  } else if (action is FireLoadedAction) {
    return action.fire;
  } else if (action is ClearFireAction) {
    return null;
  }
  return fire;
}

fireRiskReducer(String? data, action) {
  if (action is LoadFireRiskAction) {
    return data;
  } else if (action is FireRiskLoadedAction) {
    return action.risk;
  } else if (action is ClearFireRiskAction) {
    return null;
  }
  return data;
}

firesReducer(List<Fire>? fires, action) {
  if (action is LoadFiresAction) {
    return fires;
  } else if (action is FiresLoadedAction) {
    return action.fires;
  }
  return fires;
}
