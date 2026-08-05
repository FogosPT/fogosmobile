import 'package:fogosmobile/actions/all_incidents_actions.dart';
import 'package:fogosmobile/models/fire.dart';

List<Fire> allIncidentsReducer(List<Fire> fires, action) {
  if (action is LoadAllIncidentsAction) {
    return fires;
  } else if (action is AllIncidentsLoadedAction) {
    return action.fires;
  } else {
    return fires;
  }
}
