import 'package:fogosmobile/models/contributor.dart';
import 'package:fogosmobile/models/fire.dart';
import 'package:fogosmobile/models/lightning.dart';
import 'package:fogosmobile/models/modis.dart';
import 'package:fogosmobile/models/statistics.dart';
import 'package:fogosmobile/models/fire_details.dart';
import 'package:fogosmobile/models/viirs.dart';

class AppState {
  List<Fire> fires;
  Fire? selectedFire;
  List<FireStatus> activeFilters;
  MeansHistory? fireMeansHistory;
  DetailsHistory? fireDetailsHistory;
  String? fireRisk;
  List<Contributor> contributors;
  List<Lightning> lightnings;
  bool isLoading;
  bool hasFirstLoad;
  bool hasPreferences;
  bool hasContributors;
  Map preferences;
  NowStats? nowStats;
  TodayStats? todayStats;
  YesterdayStats? yesterdayStats;
  LastNightStats? lastNightStats;
  WeekStats? weekStats;
  LastHoursStats? lastHoursStats;
  List errors;
  List warnings;
  List warningsMadeira;
  List<Viirs> viirs;
  List<Modis> modis;
  bool showModis;
  bool showViirs;
  List<Fire> otherFires;
  List<Fire> allIncidents;
  List<Fire> searchResults;

  AppState({
    this.fires = const [],
    this.selectedFire,
    this.contributors = const [],
    this.isLoading = false,
    this.hasFirstLoad = false,
    this.hasPreferences = false,
    this.fireMeansHistory,
    this.fireDetailsHistory,
    this.fireRisk,
    this.hasContributors = false,
    this.preferences = const {},
    this.activeFilters = const [],
    this.nowStats,
    this.todayStats,
    this.yesterdayStats,
    this.lastNightStats,
    this.weekStats,
    this.lastHoursStats,
    this.errors = const [],
    this.warnings = const [],
    this.warningsMadeira = const [],
    this.viirs = const [],
    this.modis = const [],
    this.showModis = false,
    this.showViirs = false,
    this.otherFires = const [],
    this.allIncidents = const [],
    this.searchResults = const [],
    this.lightnings = const [],
  });

  AppState copyWith({
    List<Fire>? fires,
    Fire? fire,
    List<Contributor>? contributors,
    bool? isLoading,
    bool? hasFirstLoad,
    bool? hasPreferences,
    bool? hasContributors,
    Map? preferences,
    List<FireStatus>? activeFilters,
    MeansHistory? fireMeansHistory,
    DetailsHistory? fireDetailsHistory,
    String? fireRisk,
    NowStats? nowStats,
    TodayStats? todayStats,
    YesterdayStats? yesterdayStats,
    WeekStats? weekStats,
    LastHoursStats? lastHoursStats,
    List? errors,
    List? warnings,
    List? warningsMadeira,
    List<Viirs>? viirs,
    List<Modis>? modis,
    bool? showModis,
    bool? showViirs,
    List<Fire>? otherFires,
    List<Fire>? allIncidents,
    List<Fire>? searchResults,
    List<Lightning>? lightnings,
  }) {
    return AppState(
      fires: fires ?? this.fires,
      selectedFire: fire ?? this.selectedFire,
      contributors: contributors ?? this.contributors,
      isLoading: isLoading ?? this.isLoading,
      hasFirstLoad: hasFirstLoad ?? this.hasFirstLoad,
      hasPreferences: hasPreferences ?? this.hasPreferences,
      hasContributors: hasContributors ?? this.hasContributors,
      preferences: preferences ?? this.preferences,
      activeFilters: activeFilters ?? this.activeFilters,
      fireMeansHistory: fireMeansHistory ?? this.fireMeansHistory,
      fireDetailsHistory: fireDetailsHistory ?? this.fireDetailsHistory,
      fireRisk: fireRisk ?? this.fireRisk,
      nowStats: nowStats ?? this.nowStats,
      todayStats: todayStats ?? this.todayStats,
      yesterdayStats: yesterdayStats ?? this.yesterdayStats,
      lastNightStats: lastNightStats ?? this.lastNightStats,
      weekStats: weekStats ?? this.weekStats,
      lastHoursStats: lastHoursStats ?? this.lastHoursStats,
      errors: errors ?? this.errors,
      warnings: warnings ?? this.warnings,
      warningsMadeira: warningsMadeira ?? this.warningsMadeira,
      viirs: viirs ?? this.viirs,
      modis: modis ?? this.modis,
      showModis: showModis ?? this.showModis,
      showViirs: showViirs ?? this.showViirs,
      otherFires: otherFires ?? this.otherFires,
      allIncidents: allIncidents ?? this.allIncidents,
      searchResults: searchResults ?? this.searchResults,
      lightnings: lightnings ?? this.lightnings,
    );
  }

  @override
  String toString() {
    return 'AppState\n{isLoading: $isLoading, \nfires count: ${fires.length}, \ncontributors count: ${contributors.length}, \nwarnings count: ${warnings.length}, \nwarnings Madeira count: ${warningsMadeira.length}, \nselected fire: $selectedFire, \nhasFirstLoad: $hasFirstLoad, \nhasContributors: $hasContributors, \nhasPreferences: $hasPreferences, \nprefs: $preferences}';
  }

  String getErrors() {
    return this.errors.toString();
  }
}
