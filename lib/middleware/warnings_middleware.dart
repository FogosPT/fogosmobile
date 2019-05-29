import 'package:redux/redux.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:fogosmobile/models/warning.dart';
import 'package:fogosmobile/models/app_state.dart';
import 'package:fogosmobile/actions/warnings_actions.dart';
import 'package:fogosmobile/actions/errors_actions.dart';
import 'package:fogosmobile/constants/endpoints.dart';

List<Middleware<AppState>> warningsMiddleware() {
  final loadWarningsMadeira = _createLoadWarningsMadeira();

  return [
    TypedMiddleware<AppState, LoadWarningsMadeiraAction>(loadWarningsMadeira),
  ];
}

Middleware<AppState> _createLoadWarningsMadeira() {
  return (Store store, action, NextDispatcher next) async {
    next(action);

    try {
      String url = Endpoints.getWarningsMadeira;
      final response = await http.get(url);
      final responseData = json.decode(response.body)['data'];
      List<WarningMadeira> warnings =
        responseData.map<WarningMadeira>((model) => WarningMadeira.fromJson(model)).toList();
      store.dispatch(new WarningsMadeiraLoadedAction(warnings));
    } catch (e) {
      store.dispatch(new WarningsMadeiraLoadedAction(null));
      store.dispatch(new AddErrorAction('warningsMadeira'));
      throw e;
    }
  };
}
