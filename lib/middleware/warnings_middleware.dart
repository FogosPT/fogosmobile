import 'package:fogosmobile/utils/network_utils.dart';
import 'package:redux/redux.dart';
import 'dart:convert';

import 'package:fogosmobile/models/warning.dart';
import 'package:fogosmobile/models/app_state.dart';
import 'package:fogosmobile/actions/warnings_actions.dart';
import 'package:fogosmobile/actions/errors_actions.dart';
import 'package:fogosmobile/constants/endpoints.dart';

List<Middleware<AppState>> warningsMiddleware() {
  final loadWarnings = _createLoadWarnings();
  final loadWarningsMadeira = _createLoadWarningsMadeira();

  return [
    TypedMiddleware<AppState, LoadWarningsAction>(loadWarnings),
    TypedMiddleware<AppState, LoadWarningsMadeiraAction>(loadWarningsMadeira),
  ];
}

Middleware<AppState> _createLoadWarnings() {
  return (Store store, action, NextDispatcher next) async {
    next(action);

    try {
      String url = Endpoints.getWarnings;
      final response = await get(url);
      final responseData = response.data.runtimeType == String
          ? json.decode(response.data)['data']
          : response.data['data'];
      List<Warning> warnings = responseData.map<Warning>((model) => Warning.fromJson(model)).toList();
      store.dispatch(WarningsLoadedAction(warnings));
    } catch (e) {
      store.dispatch(WarningsLoadedAction(null));
      store.dispatch(AddErrorAction('warnings'));
      throw e;
    }
  };
}

Middleware<AppState> _createLoadWarningsMadeira() {
  return (Store store, action, NextDispatcher next) async {
    next(action);

    try {
      String url = Endpoints.getWarningsMadeira;
      final response = await get(url);
      final responseData = response.data.runtimeType == String
          ? json.decode(response.data)['data']
          : response.data['data'];
      List<WarningMadeira> warnings = responseData.map<WarningMadeira>((model) => WarningMadeira.fromJson(model)).toList();
      store.dispatch(WarningsMadeiraLoadedAction(warnings));
    } catch (e) {
      store.dispatch(WarningsMadeiraLoadedAction(null));
      store.dispatch(AddErrorAction('warningsMadeira'));
      throw e;
    }
  };
}
