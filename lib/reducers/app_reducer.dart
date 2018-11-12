import 'package:fogosmobile/models/app_state.dart';

AppState appReducer(AppState state, action) {
  return new AppState(
      isLoading: false,
      fires: firesReducer(state.fires, action),
  );
}