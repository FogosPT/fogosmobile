import 'package:fogosmobile/actions/contributors_actions.dart';
import 'package:fogosmobile/models/contributor.dart';
import 'package:fogosmobile/utils/network_utils.dart';
import 'package:redux/redux.dart';
import 'dart:convert';
import 'package:fogosmobile/models/app_state.dart';
import 'package:fogosmobile/constants/endpoints.dart';

List<Middleware<AppState>> contributorsMiddleware() {
  final loadContributors = _createLoadContributors();

  return [
    TypedMiddleware<AppState, LoadContributorsAction>(loadContributors),
  ];
}

/// Get list of contributors
Middleware<AppState> _createLoadContributors() {
  return (Store store, action, NextDispatcher next) async {
    next(action);

    try {
      String url = Endpoints.getMobileContributors;
      final response = await get(url);
      List<Contributor> contributors = Contributor.fromList(response.data);
      print("load contributors");
      store.dispatch(new ContributorsLoadedAction(contributors));
    } catch (e) {
      print(e);
      print(e.stackTrace);
      store.dispatch(new ContributorsLoadedAction([]));
    }
  };
}
