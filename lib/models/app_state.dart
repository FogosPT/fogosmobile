import 'package:fogosmobile/models/fire.dart';
import 'package:fogosmobile/models/statistics.dart';

class AppState {
  List fires = [];
  Fire fire;
  List<FireStatus> activeFilters;
  List fireMeansHistory;
  List contributors = [];
  bool isLoading = false;
  bool hasFirstLoad = false;
  bool hasPreferences = false;
  bool hasContributors = false;
  Map preferences = {};
  NowStats nowStats;
  TodayStats todayStats;
  YesterdayStats yesterdayStats;
  LastNightStats lastNightStats;
  WeekStats weekStats;
  LastHoursStats lastHoursStats;

  AppState({
    this.fires,
    this.fire,
    this.contributors,
    this.isLoading,
    this.hasFirstLoad,
    this.hasPreferences,
    this.fireMeansHistory,
    this.hasContributors,
    this.preferences,
    this.activeFilters,
    this.nowStats,
    this.todayStats,
    this.yesterdayStats,
    this.lastNightStats,
    this.weekStats,
    this.lastHoursStats,
  });

  AppState copyWith({
    List fires,
    Fire fire,
    List contributors,
    bool isLoading,
    bool hasFirstLoad,
    bool hasPreferences,
    bool hasContributors,
    Map preferences,
    List<FireStatus> activeFilters,
    List fireMeansHistory,
    NowStats nowStats,
    TodayStats todayStats,
    YesterdayStats yesterdayStats,
    WeekStats weekStats,
    LastHoursStats lastHoursStats,
  }) {
    return new AppState(
      fires: fires ?? this.fires,
      fire: fire ?? this.fires,
      contributors: contributors ?? this.contributors,
      isLoading: isLoading ?? this.isLoading,
      hasFirstLoad: hasFirstLoad ?? this.hasFirstLoad,
      hasPreferences: hasPreferences ?? this.hasPreferences,
      hasContributors: hasContributors ?? this.hasContributors,
      preferences: preferences ?? this.preferences,
      activeFilters: activeFilters ?? this.activeFilters,
      fireMeansHistory: fireMeansHistory ?? this.fireMeansHistory,
      nowStats: nowStats ?? this.nowStats,
      todayStats: todayStats ?? this.todayStats,
      yesterdayStats: yesterdayStats ?? this.yesterdayStats,
      lastNightStats: lastNightStats ?? this.lastNightStats,
      weekStats: weekStats ?? this.weekStats,
      lastHoursStats: lastHoursStats ?? this.lastHoursStats,
    );
  }

  @override
  String toString() {
    return 'AppState\n{isLoading: $isLoading, \nfires count: ${fires?.length}, \ncontributors count: ${contributors?.length}, \nselected fire: $fire, \nhasFirstLoad: $hasFirstLoad, \nhasContributors: $hasContributors, \nhasPreferences: $hasPreferences, \nprefs: $preferences}';
  }
}
