import 'package:fogosmobile/actions/modis_actions.dart';
import 'package:fogosmobile/actions/lightning_actions.dart';
import 'package:fogosmobile/actions/statistics_actions.dart';
import 'package:fogosmobile/actions/contributors_actions.dart';
import 'package:fogosmobile/actions/viirs_actions.dart';
import 'package:fogosmobile/models/app_state.dart';
import 'package:fogosmobile/reducers/contributors_reducer.dart';
import 'package:fogosmobile/reducers/fires_reducer.dart';
import 'package:fogosmobile/reducers/modis_reducer.dart';
import 'package:fogosmobile/reducers/lightning_reducer.dart';
import 'package:fogosmobile/reducers/preferences_reducer.dart';
import 'package:fogosmobile/actions/fires_actions.dart';
import 'package:fogosmobile/actions/preferences_actions.dart';
import 'package:fogosmobile/reducers/statistics_reducer.dart';
import 'package:fogosmobile/reducers/errors_reducer.dart';
import 'package:fogosmobile/actions/warnings_actions.dart';
import 'package:fogosmobile/reducers/viirs_reducer.dart';
import 'package:fogosmobile/reducers/warnings_reducer.dart';
import 'package:fogosmobile/actions/other_fires_actions.dart';
import 'package:fogosmobile/reducers/other_fires_reducer.dart';
import 'package:fogosmobile/actions/all_incidents_actions.dart';
import 'package:fogosmobile/reducers/all_incidents_reducer.dart';
import 'package:fogosmobile/actions/search_actions.dart';
import 'package:fogosmobile/reducers/search_reducer.dart';
import 'package:fogosmobile/reducers/ipma_reducer.dart';
import 'package:fogosmobile/actions/ipma_actions.dart';

AppState appReducer(AppState state, action) {
  bool isLoading = state.isLoading;
  bool hasFirstLoad = state.hasFirstLoad;
  bool hasPreferences = state.hasPreferences;
  bool hasContributors = state.hasContributors;
  bool showViirs = state.showViirs;
  bool showModis = state.showModis;
  bool showNatureCodes = state.showNatureCodes;

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
  } else if (action is SavedFireFiltersAction) {
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
  } else if (action is LoadWarningsAction) {
    isLoading = true;
  } else if (action is WarningsLoadedAction) {
    isLoading = false;
  } else if (action is LoadWarningsMadeiraAction) {
    isLoading = true;
  } else if (action is WarningsMadeiraLoadedAction) {
    isLoading = false;
  } else if (action is LoadLightningsAction) {
    isLoading = true;
  } else if (action is LightningsLoadedAction) {
    isLoading = false;
  } else if (action is ViirsLoadedAction) {
    isLoading = false;
  } else if (action is LoadViirsAction) {
    isLoading = true;
  } else if (action is LoadModisAction) {
    isLoading = true;
  } else if (action is ModisLoadedAction) {
    isLoading = false;
  } else if (action is SearchIncidentsAction) {
    isLoading = true;
  } else if (action is SearchIncidentsLoadedAction) {
    isLoading = false;
  } else if (action is LoadAllIncidentsAction) {
    isLoading = true;
  } else if (action is AllIncidentsLoadedAction) {
    isLoading = false;
  } else if (action is LoadOtherFiresAction) {
    isLoading = true;
  } else if (action is OtherFiresLoadedAction) {
    isLoading = false;
  } else if (action is ShowViirsAction) {
    showViirs = !state.showViirs;
    isLoading = state.isLoading;
  } else if (action is ShowModisAction) {
    showModis = !state.showModis;
    isLoading = state.isLoading;
  } else if (action is ToggleNatureCodesAction) {
    showNatureCodes = !state.showNatureCodes;
    isLoading = state.isLoading;
  } else if (action is ToggleIpmaLayerAction ||
      action is IpmaLayersLoadedAction) {
    isLoading = state.isLoading;
  } else if (action is LoadIpmaReferenceTimeAction ||
      action is IpmaReferenceTimeLoadedAction) {
    isLoading = state.isLoading;
  } else {
    isLoading = false;
    hasFirstLoad = true;
    hasPreferences = false;
  }

  return AppState(
    isLoading: isLoading,
    fires: firesReducer(state.fires, action),
    selectedFire: fireReducer(state.selectedFire, action),
    fireMeansHistory: fireMeansHistoryReducer(state.fireMeansHistory, action),
    fireDetailsHistory:
        fireDetailsHistoryReducer(state.fireDetailsHistory, action),
    fireRisk: fireRiskReducer(state.fireRisk, action),
    contributors: contributorsReducer(state.contributors, action),
    hasFirstLoad: hasFirstLoad,
    hasPreferences: hasPreferences,
    hasContributors: hasContributors,
    preferences: preferencesReducer(state.preferences, action),
    activeFilters: filtersReducer(state.activeFilters, action),
    nowStats: nowStatsReducer(state.nowStats, action),
    todayStats: todayStatsReducer(state.todayStats, action),
    yesterdayStats: yesterdayStatsReducer(state.yesterdayStats, action),
    lastNightStats: lastNightStatsReducer(state.lastNightStats, action),
    weekStats: weekStatsReducer(state.weekStats, action),
    lastHoursStats: lastHoursStatsReducer(state.lastHoursStats, action),
    errors: errorsReducer(state.errors, action),
    warnings: warningsReducer(state.warnings, action),
    warningsMadeira: warningsMadeiraReducer(state.warningsMadeira, action),
    modis: modisReducer(state.modis, action),
    viirs: viirsReducer(state.viirs, action),
    showModis: showModis,
    showViirs: showViirs,
    showNatureCodes: showNatureCodes,
    otherFires: otherFiresReducer(state.otherFires, action),
    allIncidents: allIncidentsReducer(state.allIncidents, action),
    searchResults: searchResultsReducer(state.searchResults, action),
    lightnings: lightningsReducer(state.lightnings, action),
    activeIpmaLayers: ipmaLayersReducer(state.activeIpmaLayers, action),
    ipmaReferenceTime: action is IpmaReferenceTimeLoadedAction
        ? action.referenceTime
        : state.ipmaReferenceTime,
    ipmaReferenceTimeLoaded: action is IpmaReferenceTimeLoadedAction
        ? true
        : state.ipmaReferenceTimeLoaded,
  );
}
