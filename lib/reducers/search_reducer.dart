import 'package:fogosmobile/actions/search_actions.dart';
import 'package:fogosmobile/models/fire.dart';

List<Fire> searchResultsReducer(List<Fire> results, action) {
  if (action is SearchIncidentsAction) {
    return results;
  } else if (action is SearchIncidentsLoadedAction) {
    return action.results;
  } else if (action is ClearSearchAction) {
    return [];
  } else {
    return results;
  }
}
