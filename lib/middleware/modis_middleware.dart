import 'package:fogosmobile/actions/modis_actions.dart';
import 'package:fogosmobile/constants/endpoints.dart';
import 'package:fogosmobile/models/app_state.dart';
import 'package:fogosmobile/models/modis.dart';
import 'package:fogosmobile/utils/network_utils.dart';
import 'package:redux/redux.dart';

List<Middleware<AppState>> modisMiddleware() {
  final loadModis = _loadModis();

  return [
    TypedMiddleware<AppState, LoadModisAction>(loadModis),
  ];
}

/// Get list of modis
Middleware<AppState> _loadModis() {
  return (Store store, action, NextDispatcher next) async {
    next(action);

    try {
      String url = Endpoints.getModis;
      final response = await get(url);
      List<Modis> modis = ModisResult.fromMap(response.data).toList();
      store.dispatch(new ModisLoadedAction(modis));
    } catch (e) {
      print(e);
      print(e.stackTrace);
      store.dispatch(new ModisLoadedAction([]));
    }
  };
}
