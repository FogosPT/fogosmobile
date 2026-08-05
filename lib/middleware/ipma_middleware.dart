import 'dart:convert';

import 'package:fogosmobile/actions/ipma_actions.dart';
import 'package:fogosmobile/constants/endpoints.dart';
import 'package:fogosmobile/middleware/shared_preferences_manager.dart';
import 'package:fogosmobile/models/app_state.dart';
import 'package:http/http.dart' as http;
import 'package:redux/redux.dart';

const String _ipmaPrefsKey = 'ipma-active-layers';

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
  ];
}

void _onToggle(Store<AppState> store, ToggleIpmaLayerAction action,
    NextDispatcher next) {
  next(action);
  try {
    final prefs = SharedPreferencesManager.preferences;
    prefs.save(_ipmaPrefsKey, store.state.activeIpmaLayers.toList());
  } catch (_) {}
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
