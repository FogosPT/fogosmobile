import 'package:fogosmobile/models/app_state.dart';
import 'package:fogosmobile/reducers/fires_reducer.dart';
import 'package:fogosmobile/actions/fires_actions.dart';

AppState appReducer(AppState state, action) {
  bool isLoading;

  if (action is LoadFiresAction) {
    isLoading = true;
  } else if (action is FiresLoadedAction) {
    isLoading = false;
  } 

  return new AppState(
    isLoading: isLoading,
    fires: firesReducer(state.fires, action),
  );
}
