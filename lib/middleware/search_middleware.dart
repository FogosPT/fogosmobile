import 'package:fogosmobile/utils/network_utils.dart';
import 'package:redux/redux.dart';
import 'package:dio/dio.dart';
import 'dart:convert';

import 'package:fogosmobile/models/app_state.dart';
import 'package:fogosmobile/models/fire.dart';
import 'package:fogosmobile/actions/search_actions.dart';
import 'package:fogosmobile/actions/errors_actions.dart';

List<Middleware<AppState>> searchMiddleware() {
  return [
    TypedMiddleware<AppState, SearchIncidentsAction>(_createSearchIncidents()),
  ];
}

Middleware<AppState> _createSearchIncidents() {
  return (Store store, action, NextDispatcher next) async {
    next(action);

    try {
      final SearchIncidentsAction searchAction = action;
      final params = <String, String>{
        'concelho': searchAction.concelho,
      };
      if (searchAction.all) params['all'] = '1';
      if (searchAction.after != null) params['after'] = searchAction.after!;
      if (searchAction.before != null) params['before'] = searchAction.before!;

      final queryString = params.entries.map((e) => '${e.key}=${Uri.encodeComponent(e.value)}').join('&');
      final url = 'https://api.fogos.pt/v2/incidents/search?$queryString';

      final response = await get(url);
      final responseData = response!.data.runtimeType == String
          ? json.decode(response!.data)['data']
          : response!.data['data'];

      List<Fire> results = responseData != null
          ? responseData.map<Fire>((model) => Fire.fromJson(model)).toList()
          : <Fire>[];

      store.dispatch(SearchIncidentsLoadedAction(results));
    } catch (e) {
      store.dispatch(SearchIncidentsLoadedAction([]));
      store.dispatch(AddErrorAction('search'));
      if (!(e is DioException)) {
        print('Search error: $e');
      }
    }
  };
}
