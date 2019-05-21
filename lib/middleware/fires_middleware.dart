import 'package:fogosmobile/utils/model_utils.dart';
import 'package:redux/redux.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:fogosmobile/models/app_state.dart';
import 'package:fogosmobile/models/fire.dart';
import 'package:fogosmobile/actions/fires_actions.dart';
import 'package:fogosmobile/constants/endpoints.dart';

List<Middleware<AppState>> firesMiddleware() {
  final loadFires = _createLoadFires();
  final loadFire = _createLoadFire();

  return [
    TypedMiddleware<AppState, LoadFiresAction>(loadFires),
    TypedMiddleware<AppState, LoadFireAction>(loadFire),
  ];
}

/// Get list of fires
Middleware<AppState> _createLoadFires() {
  return (Store store, action, NextDispatcher next) async {
    next(action);

    try {
      String url = Endpoints.getFires;
      final response = await http.get(url);
      final responseData = json.decode(response.body)['data'];
      List<Fire> fires = responseData.map<Fire>((model) => Fire.fromJson(model))
          .toList();
      print("load fires");
      fires = calculateFireImportance(fires);
      store.dispatch(new FiresLoadedAction(fires));
    } catch (e) {
      print(e);
      print(e.stackTrace);
      store.dispatch(new FiresLoadedAction([]));
    }
  };
}

/// Get data for a single fire
Middleware<AppState> _createLoadFire() {
  return (Store store, action, NextDispatcher next) async {
    next(action);

    try {
      String url = '${Endpoints.getFire}${action.fireId}';
      final response = await http.get(url);
      final responseData = json.decode(response.body)['data'];
      Fire fire = Fire.fromJson(responseData);
      store.dispatch(new FireLoadedAction(fire));
    } catch (e) {
      store.dispatch(new FireLoadedAction(null));
    }
  };
}
