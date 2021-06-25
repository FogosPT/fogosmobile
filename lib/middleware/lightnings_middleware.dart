import 'package:fogosmobile/actions/lightning_actions.dart';
import 'package:fogosmobile/constants/endpoints.dart';
import 'package:fogosmobile/models/app_state.dart';
import 'package:fogosmobile/models/lightning.dart';
import 'package:fogosmobile/utils/network_utils.dart';
import 'package:redux/redux.dart';
import 'dart:convert';

List<Middleware<AppState>> lightningMiddleware() {
  final loadLightnings = _createLightningStrikes();

  return [
    TypedMiddleware<AppState, LoadLightningsAction>(loadLightnings),
  ];
}

/// Get list of lightnings
Middleware<AppState> _createLightningStrikes() {
  return (Store store, action, NextDispatcher next) async {
    next(action);

    try {
      String url = Endpoints.getLightnings;
      final response = await get(url);
      if (response.data != [] && response.data != null) {
        List<Lightning> lightnings = LightningRemote.fromJson(response.data as Map<String, dynamic>).data;
        store.dispatch(LightningsLoadedAction(lightnings));
      }
    } catch (e) {
      print(e);
      print(e.stackTrace);
      store.dispatch(LightningsLoadedAction([]));
    }
  };
}
