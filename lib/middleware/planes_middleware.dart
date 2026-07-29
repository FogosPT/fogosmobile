import 'dart:convert';

import 'package:fogosmobile/actions/planes_actions.dart';
import 'package:fogosmobile/constants/endpoints.dart';
import 'package:fogosmobile/models/app_state.dart';
import 'package:fogosmobile/models/plane.dart';
import 'package:fogosmobile/utils/network_utils.dart';
import 'package:redux/redux.dart';

List<Middleware<AppState>> planesMiddleware() {
  return [
    TypedMiddleware<AppState, LoadPlanesAction>(_loadPlanes()),
  ];
}

Middleware<AppState> _loadPlanes() {
  return (Store store, action, NextDispatcher next) async {
    next(action);

    try {
      final response = await get(Endpoints.getRecentPlanes(hours: 6));
      if (response == null || response.data == null) {
        store.dispatch(PlanesLoadedAction(const []));
        return;
      }

      final body = response.data is String
          ? json.decode(response.data as String)
          : response.data;
      final list = (body['data'] as List?) ?? const [];

      // Parse each entry independently — a single malformed row shouldn't
      // drop the whole batch (previous behaviour hid all planes when any
      // entry was missing a required field).
      final planes = <Plane>[];
      for (final j in list) {
        try {
          final plane = Plane.fromJson(j as Map<String, dynamic>);
          if (plane.positions.isNotEmpty) planes.add(plane);
        } catch (e) {
          print('planes: skipping malformed entry: $e');
        }
      }

      store.dispatch(PlanesLoadedAction(planes));
    } catch (e) {
      print(e);
      store.dispatch(PlanesLoadedAction(const []));
    }
  };
}
