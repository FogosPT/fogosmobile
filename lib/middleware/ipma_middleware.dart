import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:fogosmobile/actions/ipma_actions.dart';
import 'package:fogosmobile/constants/endpoints.dart';
import 'package:fogosmobile/middleware/shared_preferences_manager.dart';
import 'package:fogosmobile/models/app_state.dart';
import 'package:fogosmobile/models/ipma_wind_grid.dart';
import 'package:http/http.dart' as http;
import 'package:redux/redux.dart';

const String _ipmaPrefsKey = 'ipma-active-layers';
const String _animatedWindKey = 'ipma-wind-animated';

Set<String> loadIpmaLayersFromPrefs() {
  try {
    final prefs = SharedPreferencesManager.preferences;
    final stored = prefs.getStringList(_ipmaPrefsKey);
    if (stored == null) return <String>{};
    return stored.toSet();
  } catch (_) {
    return <String>{};
  }
}

List<Middleware<AppState>> ipmaMiddleware() {
  return [
    TypedMiddleware<AppState, ToggleIpmaLayerAction>(_onToggle),
    TypedMiddleware<AppState, LoadIpmaReferenceTimeAction>(_loadReferenceTime),
    TypedMiddleware<AppState, LoadIpmaWindAction>(_loadWind),
  ];
}

void _onToggle(Store<AppState> store, ToggleIpmaLayerAction action,
    NextDispatcher next) {
  next(action);
  // Persist
  try {
    final prefs = SharedPreferencesManager.preferences;
    prefs.save(_ipmaPrefsKey, store.state.activeIpmaLayers.toList());
  } catch (_) {}
  // Auto-fetch the wind grid the first time the animated-wind toggle goes on.
  if (action.key == _animatedWindKey &&
      store.state.activeIpmaLayers.contains(_animatedWindKey) &&
      store.state.ipmaWindGrid == null &&
      !store.state.ipmaWindGridLoading) {
    store.dispatch(LoadIpmaWindAction());
  }
}

void _loadReferenceTime(
    Store<AppState> store, action, NextDispatcher next) async {
  next(action);
  try {
    final response = await http
        .get(Uri.parse(Endpoints.getIpmaReferenceTime))
        .timeout(const Duration(seconds: 10));
    if (response.statusCode == 200) {
      final body = jsonDecode(response.body) as Map<String, dynamic>;
      final refTime = body['reference_time'] as String?;
      store.dispatch(IpmaReferenceTimeLoadedAction(refTime));
      return;
    }
  } catch (_) {}
  store.dispatch(IpmaReferenceTimeLoadedAction(null));
}

void _loadWind(Store<AppState> store, action, NextDispatcher next) async {
  next(action);
  if (store.state.ipmaWindGridLoading) return;
  store.dispatch(IpmaWindGridLoadingAction(true));
  try {
    final response = await http
        .get(Uri.parse(Endpoints.getIpmaWind))
        .timeout(const Duration(seconds: 20));
    if (response.statusCode != 200) {
      store.dispatch(IpmaWindGridLoadingAction(false));
      return;
    }
    // Parse the ~370 KB JSON off the main isolate.
    final grid = await compute(parseIpmaWindGrid, response.body);
    store.dispatch(IpmaWindGridLoadedAction(grid));
  } catch (_) {
    store.dispatch(IpmaWindGridLoadingAction(false));
  }
}
