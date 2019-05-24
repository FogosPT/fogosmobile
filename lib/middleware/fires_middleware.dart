import 'package:fogosmobile/models/fire_details.dart';
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
  final loadFireMeansHistory = _createLoadFireMeansHistory();
  final loadFireDetailsHistory = _createLoadFireDetailsHistory();
  final loadFireRisk = _createLoadFireRisk();

  return [
    TypedMiddleware<AppState, LoadFiresAction>(loadFires),
    TypedMiddleware<AppState, LoadFireAction>(loadFire),
    TypedMiddleware<AppState, LoadFireMeansHistoryAction>(loadFireMeansHistory),
    TypedMiddleware<AppState, LoadFireDetailsHistoryAction>(
        loadFireDetailsHistory),
    TypedMiddleware<AppState, LoadFireRiskAction>(loadFireRisk),
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
      List<Fire> fires =
          responseData.map<Fire>((model) => Fire.fromJson(model)).toList();
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

Middleware<AppState> _createLoadFireMeansHistory() {
  return (Store store, action, NextDispatcher next) async {
    next(action);
    print('create means history');
    try {
      String url = '${Endpoints.getFireMeansHistory}${action.fireId}';
      final response = await http.get(url);
      final responseData = json.decode(response.body)['data'];
      MeansHistory data = MeansHistory.fromJson(responseData);
      store.dispatch(new FireMeansHistoryLoadedAction(data));
    } catch (e) {
      store.dispatch(new FireMeansHistoryLoadedAction(null));
    }
  };
}

Middleware<AppState> _createLoadFireDetailsHistory() {
  return (Store store, action, NextDispatcher next) async {
    next(action);
    print('create details history');
    try {
      String url = '${Endpoints.getFireDetailsHistory}${action.fireId}';
      final response = await http.get(url);
      final responseData = json.decode(response.body)['data'];
      DetailsHistory data = DetailsHistory.fromJson(responseData);
      store.dispatch(new FireDetailsHistoryLoadedAction(data));
    } catch (e) {
      store.dispatch(new FireDetailsHistoryLoadedAction(null));
    }
  };
}

Middleware<AppState> _createLoadFireRisk() {
  return (Store store, action, NextDispatcher next) async {
    next(action);
    print('create risk');
    try {
      String url = '${Endpoints.getFireRisk}${action.fireId}';
      final response = await http.get(url);
      String responseData = json.decode(response.body)['data'][0]['hoje'];
      print(responseData);
      store.dispatch(new FireRiskLoadedAction(responseData));
    } catch (e) {
      store.dispatch(new FireRiskLoadedAction(null));
    }
  };
}
