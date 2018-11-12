import 'package:fogosmobile/models/app_state.dart';
import 'package:fogosmobile/reducers/fires_reducer.dart';

AppState appReducer(AppState state, action) {
  return new AppState(
    isLoading: false,
    fires: firesReducer(state.fires, action),
  );
}
