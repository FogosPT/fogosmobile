import 'package:redux/redux.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:fogosmobile/models/app_state.dart';
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

    http.Response response = await http.get(
      Uri.encodeFull(
          'http://quotesondesign.com/wp-json/posts?filter[orderby]=rand&filter[posts_per_page]=1'),
    );
    List<dynamic> result = json.decode(response.body);

    store.dispatch(new FiresLoadedAction(result));
  };
}
