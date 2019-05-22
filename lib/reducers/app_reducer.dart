import 'package:fogosmobile/actions/statistics_actions.dart';
import 'package:fogosmobile/actions/contributors_actions.dart';
import 'package:fogosmobile/models/app_state.dart';
import 'package:fogosmobile/reducers/contributors_reducer.dart';
import 'package:fogosmobile/reducers/fires_reducer.dart';
import 'package:fogosmobile/reducers/preferences_reducer.dart';
import 'package:fogosmobile/actions/fires_actions.dart';
import 'package:fogosmobile/actions/preferences_actions.dart';
import 'package:fogosmobile/reducers/statistics_reducer.dart';

AppState appReducer(AppState state, action) {
  bool isLoading;
  bool hasFirstLoad;
  bool hasPreferences;
  bool hasContributors;

  // print('action is action $action');

  if (action is LoadFiresAction) {
    isLoading = true;
  } else if (action is FiresLoadedAction) {
    isLoading = false;
    hasFirstLoad = true;
  } else if (action is LoadFireAction) {
    isLoading = true;
  } else if (action is FireLoadedAction) {
    isLoading = false;
    hasFirstLoad = true;
  } else if (action is LoadAllPreferencesAction) {
    hasPreferences = false;
    isLoading = true;
  } else if (action is AllPreferencesLoadedAction) {
    hasPreferences = true;
    isLoading = false;
  } else if (action is SetPreferenceAction) {
    hasPreferences = true;
    isLoading = false;
  } else if (action is LoadNowStatsAction) {
    isLoading = true;
  } else if (action is NowStatsLoadedAction) {
    isLoading = false;
  } else if (action is LoadTodayStatsAction) {
    isLoading = true;
  } else if (action is TodayStatsLoadedAction) {
    isLoading = false;
  } else if (action is LoadYesterdayStatsAction) {
    isLoading = true;
  } else if (action is YesterdayStatsLoadedAction) {
    isLoading = false;
  } else if (action is LoadLastNightStatsAction) {
    isLoading = true;
  } else if (action is LastNightStatsLoadedAction) {
    isLoading = false;
  } else if (action is LoadWeekStatsAction) {
    isLoading = true;
  } else if (action is WeekStatsLoadedAction) {
    isLoading = false;
  } else if (action is LoadLastHoursAction) {
    isLoading = true;
  } else if (action is LastHoursLoadedAction) {
    isLoading = false;
  } else if (action is LoadContributorsAction) {
    isLoading = true;
  } else if (action is ContributorsLoadedAction) {
    isLoading = false;
    hasContributors = true;
  } else {
    isLoading = false;
    hasFirstLoad = true;
    hasPreferences = false;
    hasContributors = false;
  }

  return new AppState(
    isLoading: isLoading,
    fires: firesReducer(state.fires, action),
    fire: fireReducer(state.fire, action),
    fireMeansHistory: fireMeansHistoryReducer(state.fireMeansHistory, action),
    contributors: contributorsReducer(state.contributors, action),
    hasFirstLoad: hasFirstLoad,
    hasPreferences: hasPreferences,
    hasContributors: hasContributors ?? false,
    preferences: preferencesReducer(state.preferences, action),
    activeFilters: filtersReducer(state.activeFilters, action),
    nowStats: nowStatsReducer(state.nowStats, action),
    todayStats: todayStatsReducer(state.todayStats, action),
    yesterdayStats: yesterdayStatsReducer(state.yesterdayStats, action),
    lastNightStats: lastNightStatsReducer(state.lastNightStats, action),
    weekStats: weekStatsReducer(state.weekStats, action),
    lastHoursStats: lastHoursStatsReducer(state.lastHoursStats, action),
  );
}
