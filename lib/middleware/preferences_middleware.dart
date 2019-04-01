import 'package:redux/redux.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:fogosmobile/models/app_state.dart';
import 'package:fogosmobile/actions/preferences_actions.dart';
import 'package:fogosmobile/constants/endpoints.dart';

List<Middleware<AppState>> preferencesMiddleware() {
  final loadPreferences = _createLoadPreferences();

  return [
    TypedMiddleware<AppState, LoadAllPreferencesAction>(loadPreferences),
  ];
}

Middleware<AppState> _createLoadPreferences() {
  return (Store store, action, NextDispatcher next) async {
    next(action);

    try {
      String url = endpoints['getLocations'];
      final response = await http.get(url);
      final data = json.decode(utf8.decode(response.bodyBytes))['rows'];
      store.dispatch(new AllPreferencesLoadedAction(data));
    } catch (e) {}
  };
}
