import 'package:redux/redux.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:fogosmobile/models/app_state.dart';
import 'package:fogosmobile/models/fire.dart';
import 'package:fogosmobile/actions/fires_actions.dart';
import 'package:fogosmobile/constants/endpoints.dart';

List<Middleware<AppState>> firesMiddleware() {
  final loadFires = _createLoadFires();
  final loadFire = _createLoadFire();

  return [
    TypedMiddleware<AppState, LoadFiresAction>(loadFires),
    TypedMiddleware<AppState, LoadFireAction>(loadFire),
  ];
}

/// Get list of fires
Middleware<AppState> _createLoadFires() {
  return (Store store, action, NextDispatcher next) async {
    next(action);

    try {
      String url = endpoints['getFires'];
      final response = await http.get(url);
      final responseData = json.decode(response.body)['data'];
      List<Fire> fires = responseData.map<Fire>((model) => Fire.fromJson(model))
          .toList();
      print("load fires");
      fires = _calculateFireImportance(fires);
      store.dispatch(new FiresLoadedAction(fires));
    } catch (e) {
      print(e);
      print(e.stackTrace);
      store.dispatch(new FiresLoadedAction([]));
    }
  };
}

/// Calculates the importance of each fire

const numberOfFires = "numberOfFires";
const topImportance = "topImportance";
const average = "average";

List<Fire> _calculateFireImportance(List<Fire> fires) {
  var firesStatus = {
    numberOfFires: 0,
    topImportance: 0.0,
    average: 0.0
  };
  for (var fire in fires) {
    fire.importance = _calculateImportanceValue(fire, firesStatus);
  }
  for (var fire in fires) {
    fire.scale = _getPonderatedImportanceFactor(fire.importance, fire.statusCode, firesStatus) / 1.5;
  }

  return fires;
}


double _calculateImportanceValue(Fire data, Map<String, dynamic> status) {
  var manFactor = 1.0;
  var terrainFactor = 3.0;
  var aerialFactor = 7.0;

  var importance = data.human * manFactor + data.terrain * terrainFactor +
      data.aerial * aerialFactor;

  status[numberOfFires] += 1;
  if (status[topImportance] < importance) {
    status[topImportance] = importance;
  }

  status[average] =
      (status[average] * (status[numberOfFires] - 1) + importance) /
          (status[numberOfFires]);

  return importance;
}

double _getPonderatedImportanceFactor(double importance, statusCode, Map<String, dynamic> status) {
  var importanceScale = 0.0;

  // check for fake alarm's or calls
  if (statusCode == 11 || statusCode == 12) {
    return 0.8;
  }
  if (importance > status[average]) {
    var topPercentage = importance / status[topImportance];
    topPercentage *= 2.3;
    topPercentage += 0.5;

    var avgPercentage = status[average] / importance;

    importanceScale = topPercentage - avgPercentage;

    if (importanceScale > 1.75) {
      importanceScale = 1.75;
    }

    if (importanceScale < 1) {
      importanceScale = 1;
    }
  }

  if (importance < status[average]) {
    var avgPercentage = importance / status[average] * 0.8;
    if (avgPercentage < 0.9) {
      importanceScale = 0.9;
    } else {
      importanceScale = avgPercentage;
    }
  }
  return importanceScale;
}


/// Get data for a single fire
Middleware<AppState> _createLoadFire() {
  return (Store store, action, NextDispatcher next) async {
    next(action);

    try {
      String url = '${endpoints['getFire']}${action.fireId}';
      final response = await http.get(url);
      final responseData = json.decode(response.body)['data'];
      Fire fire = Fire.fromJson(responseData);
      store.dispatch(new FireLoadedAction(fire));
    } catch (e) {
      store.dispatch(new FireLoadedAction(null));
    }
  };
}
