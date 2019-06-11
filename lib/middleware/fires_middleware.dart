import 'package:fogosmobile/middleware/shared_preferences_manager.dart';
import 'package:fogosmobile/models/fire_details.dart';
import 'package:fogosmobile/utils/model_utils.dart';
import 'package:redux/redux.dart';
import 'package:dio/dio.dart';
import 'dart:convert';

import 'package:fogosmobile/models/app_state.dart';
import 'package:fogosmobile/models/fire.dart';
import 'package:fogosmobile/actions/fires_actions.dart';
import 'package:fogosmobile/actions/errors_actions.dart';
import 'package:fogosmobile/constants/endpoints.dart';

List<Middleware<AppState>> firesMiddleware() {
  final loadFires = _createLoadFires();
  final loadFire = _createLoadFire();
  final loadFireMeansHistory = _createLoadFireMeansHistory();
  final loadFireDetailsHistory = _createLoadFireDetailsHistory();
  final loadFireRisk = _createLoadFireRisk();
  final selectFireFilters = _createSelectFireFilters();

  return [
    TypedMiddleware<AppState, LoadFiresAction>(loadFires),
    TypedMiddleware<AppState, LoadFireAction>(loadFire),
    TypedMiddleware<AppState, LoadFireMeansHistoryAction>(loadFireMeansHistory),
    TypedMiddleware<AppState, LoadFireDetailsHistoryAction>(loadFireDetailsHistory),
    TypedMiddleware<AppState, LoadFireRiskAction>(loadFireRisk),
    TypedMiddleware<AppState, SelectFireFiltersAction>(selectFireFilters),
  ];
}

/// Get list of fires
Middleware<AppState> _createLoadFires() {
  return (Store store, action, NextDispatcher next) async {
    next(action);

    try {
      String url = Endpoints.getFires;
      Response response = await Dio().get(url);
      final responseData = json.decode(response.data)["data"];
      List<Fire> fires = responseData.map<Fire>((model) => Fire.fromJson(model)).toList();
      fires = calculateFireImportance(fires);
      store.dispatch(new FiresLoadedAction(fires));

      final prefs = SharedPreferencesManager.preferences;
      List<FireStatus> saveFilters = Fire.listFromActiveFilters(prefs.getStringList('active_filters'));
      store.dispatch(new SavedFireFiltersAction(saveFilters));
    } catch (e) {
      store.dispatch(new FiresLoadedAction([]));
      store.dispatch(new AddErrorAction('fires'));
      if (!(e is DioError)) {
        print('throwing error');
        throw e;
      }
    }
  };
}

/// Get data for a single fire
Middleware<AppState> _createLoadFire() {
  return (Store store, action, NextDispatcher next) async {
    next(action);

    String url = '${Endpoints.getFire}${action.fireId}';

    try {
      Response response = await Dio().get(url);
      final responseData = json.decode(response.data)["data"];
      if (responseData == null) {
        throw new StateError('No fire data could be loaded: $url');
      }

      Fire fire = Fire.fromJson(responseData);
      store.dispatch(new FireLoadedAction(fire));
    } catch (e) {
      store.dispatch(new FireLoadedAction(null));
      store.dispatch(new AddErrorAction('fire'));
      if (e is DioError) {
        if (e.response != null) {
          if (e.response.statusCode >= 400) {
            throw new StateError('Server responded with ${e.response.statusCode}: $url');
          }
        }
      } else {
        print('throwing error');
        throw e;
      }
    }
  };
}

Middleware<AppState> _createLoadFireMeansHistory() {
  return (Store store, action, NextDispatcher next) async {
    next(action);
    String url = '${Endpoints.getFireMeansHistory}${action.fireId}';

    try {
      Response response = await Dio().get(url);
      final responseData = json.decode(response.data)["data"];
      if (responseData == null) {
        throw new StateError('No getFireMeansHistory could be loaded: $url');
      }
      MeansHistory data = MeansHistory.fromJson(responseData);
      store.dispatch(new RemoveErrorAction('fireMeansHistory'));
      store.dispatch(new FireMeansHistoryLoadedAction(data));
    } catch (e) {
      store.dispatch(new FireMeansHistoryLoadedAction(null));
      store.dispatch(new AddErrorAction('fireMeansHistory'));
      if (e is DioError) {
        if (e.response != null) {
          if (e.response.statusCode >= 400) {
            throw new StateError('Server responded with ${e.response.statusCode}: $url');
          }
        }
      } else {
        print('throwing error');
        throw e;
      }
    }
  };
}

Middleware<AppState> _createLoadFireDetailsHistory() {
  return (Store store, action, NextDispatcher next) async {
    next(action);
    String url = '${Endpoints.getFireDetailsHistory}${action.fireId}';

    try {
      Response response = await Dio().get(url);
      final responseData = json.decode(response.data)["data"];
      if (responseData == null) {
        throw new StateError('No getFireDetailsHistory could be loaded: $url');
      }
      DetailsHistory data = DetailsHistory.fromJson(responseData);
      store.dispatch(new RemoveErrorAction('fireDetailsHistory'));
      store.dispatch(new FireDetailsHistoryLoadedAction(data));
    } catch (e) {
      store.dispatch(new FireDetailsHistoryLoadedAction(null));
      store.dispatch(new AddErrorAction('fireDetailsHistory'));
      if (e is DioError) {
        if (e.response != null) {
          if (e.response.statusCode >= 400) {
            throw new StateError('Server responded with ${e.response.statusCode}: $url');
          }
        }
      } else {
        print('throwing error');
        throw e;
      }
    }
  };
}

Middleware<AppState> _createLoadFireRisk() {
  return (Store store, action, NextDispatcher next) async {
    next(action);
    
    String url = '${Endpoints.getFireRisk}${action.fireId}';

    try {
      Response response = await Dio().get(url);
      final responseData = json.decode(response.data)["data"][0]['hoje'];

      if (responseData == null) {
        throw new StateError('No getFireRisk could be loaded: $url');
      }

      store.dispatch(new RemoveErrorAction('fireRisk'));
      store.dispatch(new FireRiskLoadedAction(responseData));
    } catch (e) {
      store.dispatch(new FireRiskLoadedAction(null));
      store.dispatch(new AddErrorAction('fireRisk'));
      if (e is DioError) {
        if (e.response != null) {
          if (e.response.statusCode >= 400) {
            throw new StateError('Server responded with ${e.response.statusCode}: $url');
          }
        }
      } else {
        print('throwing error');
        throw e;
      }
    }
  };
}

Middleware<AppState> _createSelectFireFilters() {
  return (Store store, action, NextDispatcher next) async {
    next(action);
    try {
      final prefs = SharedPreferencesManager.preferences;
      FireStatus filter = action.filter;
      List<FireStatus> saveFilters = Fire.listFromActiveFilters(prefs.getStringList('active_filters'));

      if (saveFilters.contains(filter)) {
        saveFilters.remove(filter);
      } else {
        saveFilters.add(filter);
      }

      prefs.save('active_filters', Fire.activeFiltersToList(saveFilters));
      store.dispatch(new SavedFireFiltersAction(saveFilters));
    } catch (e) {
      print(e);
    }
  };
}