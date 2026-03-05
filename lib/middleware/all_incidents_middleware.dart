import 'package:fogosmobile/utils/model_utils.dart';
import 'package:fogosmobile/utils/network_utils.dart';
import 'package:redux/redux.dart';
import 'package:dio/dio.dart';
import 'dart:convert';

import 'package:fogosmobile/models/app_state.dart';
import 'package:fogosmobile/models/fire.dart';
import 'package:fogosmobile/actions/all_incidents_actions.dart';
import 'package:fogosmobile/actions/errors_actions.dart';

List<Middleware<AppState>> allIncidentsMiddleware() {
  return [
    TypedMiddleware<AppState, LoadAllIncidentsAction>(_createLoadAllIncidents()),
  ];
}

Middleware<AppState> _createLoadAllIncidents() {
  return (Store store, action, NextDispatcher next) async {
    next(action);

    try {
      String url = 'https://api.fogos.pt/v2/incidents/active?all=1';
      final response = await get(url);
      final responseData = response!.data.runtimeType == String
          ? json.decode(response!.data)['data']
          : response!.data['data'];
      List<Fire> fires =
          responseData.map<Fire>((model) => Fire.fromJson(model)).toList();
      fires = calculateFireImportance(fires);
      store.dispatch(AllIncidentsLoadedAction(fires));
    } catch (e) {
      store.dispatch(AllIncidentsLoadedAction([]));
      store.dispatch(AddErrorAction('allIncidents'));
      if (!(e is DioException)) {
        print('throwing error');
        throw e;
      }
    }
  };
}
