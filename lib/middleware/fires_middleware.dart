import 'package:redux/redux.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:fogosmobile/models/app_state.dart';
import 'package:fogosmobile/models/fire.dart';
import 'package:fogosmobile/actions/fires_actions.dart';

List<Middleware<AppState>> createFiresMiddleware() {
  final loadFires = _createLoadFires();

  return [
    TypedMiddleware<AppState, LoadFiresAction>(loadFires),
  ];
}

Middleware<AppState> _createLoadFires() {
  return (Store store, action, NextDispatcher next) async {
    next(action);

    String url = 'https://api-lb.fogos.pt/new/fires';
    final response = await http.get(url);
    final responseData = json.decode(response.body)['data'];
    List<Fire> fires = responseData.map((model) => Fire.fromJson(model)).toList();
    store.dispatch(new FiresLoadedAction(fires));
  };
}
