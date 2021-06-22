import 'package:fogosmobile/actions/statistics_actions.dart';
import 'package:fogosmobile/models/statistics.dart';
import 'package:fogosmobile/utils/network_utils.dart';
import 'package:redux/redux.dart';
import 'dart:convert';
import 'package:fogosmobile/models/app_state.dart';
import 'package:fogosmobile/constants/endpoints.dart';

List<Middleware<AppState>> statisticsMiddleware() {
  final loadNowStats = _createLoadNowStats();
  final loadTodayStats = _createTodayStats();
  final loadYesterdayStats = _createYesterdayStats();
  final loadLastNightStats = _createLastNightStats();
  final loadWeekStats = _createWeekStats();
  final loadLastHoursStats = _createLastHoursStats();

  return [
    TypedMiddleware<AppState, LoadNowStatsAction>(loadNowStats),
    TypedMiddleware<AppState, LoadTodayStatsAction>(loadTodayStats),
    TypedMiddleware<AppState, LoadYesterdayStatsAction>(loadYesterdayStats),
    TypedMiddleware<AppState, LoadLastNightStatsAction>(loadLastNightStats),
    TypedMiddleware<AppState, LoadWeekStatsAction>(loadWeekStats),
    TypedMiddleware<AppState, LoadLastHoursAction>(loadLastHoursStats),
  ];
}

/// Get now stats
Middleware<AppState> _createLoadNowStats() {
  return (Store store, action, NextDispatcher next) async {
    next(action);
    try {
      String url = Endpoints.getNowStats;
      final response = await get(url);
      final responseData = json.decode(response.data)['data'];
      NowStats nowStats = NowStats.fromJson(responseData);
      store.dispatch(new NowStatsLoadedAction(nowStats));
    } catch (e) {
      print(e);
      print(e.stackTrace);
      store.dispatch(new NowStatsLoadedAction(null));
    }
  };
}

// Get today stats
Middleware<AppState> _createTodayStats() {
  return (Store store, action, NextDispatcher next) async {
    next(action);
    try {
      String url = Endpoints.getTodayStats;
      final response = await get(url);
      final responseData = json.decode(response.data)['data'];
      TodayStats todayStats = TodayStats.fromJson(responseData);
      store.dispatch(new TodayStatsLoadedAction(todayStats));
    } catch (e) {
      print(e);
      print(e.stackTrace);
      store.dispatch(new TodayStatsLoadedAction(null));
    }
  };
}

// Get yesterday stats
Middleware<AppState> _createYesterdayStats() {
  return (Store store, action, NextDispatcher next) async {
    next(action);
    try {
      String url = Endpoints.getYesterdayStats;
      final response = await get(url);
      final responseData = json.decode(response.data)['data'];
      YesterdayStats yesterdayStats = YesterdayStats.fromJson(responseData);
      store.dispatch(new YesterdayStatsLoadedAction(yesterdayStats));
    } catch (e) {
      print(e);
      print(e.stackTrace);
      store.dispatch(new YesterdayStatsLoadedAction(null));
    }
  };
}

// Get last night stats
Middleware<AppState> _createLastNightStats() {
  return (Store store, action, NextDispatcher next) async {
    next(action);
    try {
      String url = Endpoints.getLastNightStats;
      final response = await get(url);
      final responseData = json.decode(response.data)['data'];
      LastNightStats lastNightStats = LastNightStats.fromJson(responseData);
      store.dispatch(new LastNightStatsLoadedAction(lastNightStats));
    } catch (e) {
      print(e);
      print(e.stackTrace);
      store.dispatch(new LastNightStatsLoadedAction(null));
    }
  };
}

// Get week stats
Middleware<AppState> _createWeekStats() {
  return (Store store, action, NextDispatcher next) async {
    next(action);
    try {
      String url = Endpoints.getWeekStats;
      final response = await get(url);
      final responseData = json.decode(response.data)['data'];
      WeekStats weekStats = WeekStats.fromJson(responseData);
      store.dispatch(new WeekStatsLoadedAction(weekStats));
    } catch (e) {
      print(e);
      print(e.stackTrace);
      store.dispatch(new WeekStatsLoadedAction(null));
    }
  };
}

// Get last hours stats
Middleware<AppState> _createLastHoursStats() {
  return (Store store, action, NextDispatcher next) async {
    next(action);
    try {
      String url = Endpoints.getLastHoursStats;
      final response = await get(url);
      final responseData = json.decode(response.data)['data'];
      LastHoursStats lastHoursStats = LastHoursStats.fromJson(responseData);
      store.dispatch(new LastHoursLoadedAction(lastHoursStats));
    } catch (e) {
      print(e);
      print(e.stackTrace);
      store.dispatch(new LastHoursLoadedAction(null));
    }
  };
}
