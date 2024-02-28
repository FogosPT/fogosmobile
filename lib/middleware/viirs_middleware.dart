import 'package:fogosmobile/actions/viirs_actions.dart';
import 'package:fogosmobile/constants/endpoints.dart';
import 'package:fogosmobile/models/app_state.dart';
import 'package:fogosmobile/models/viirs.dart';
import 'package:fogosmobile/utils/network_utils.dart';
import 'package:redux/redux.dart';

List<Middleware<AppState>> viirsMiddleware() {
  final loadViirs = _loadViirs();

  return [
    TypedMiddleware<AppState, LoadViirsAction>(loadViirs),
  ];
}

/// Get list of viirs
Middleware<AppState> _loadViirs() {
  return (Store store, action, NextDispatcher next) async {
    next(action);

    try {
      String url = Endpoints.getViirs;
      final response = await get(url);
      List<Viirs> viirs = ViirsResult.fromMap(response.data).toList();
      store.dispatch(ViirsLoadedAction(viirs));
    } catch (e) {
      print(e);
      store.dispatch(ViirsLoadedAction([]));
    }
  };
}
