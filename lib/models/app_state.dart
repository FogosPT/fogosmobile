import 'package:fogosmobile/models/fire.dart';
import 'package:fogosmobile/models/statistics.dart';

class AppState {
  List fires = [];
  Fire fire;
  List<FireStatus> activeFilters;
  bool isLoading = false;
  bool hasFirstLoad = false;
  bool hasPreferences = false;
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
    this.isLoading,
    this.hasFirstLoad,
    this.hasPreferences,
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
    bool isLoading,
    bool hasFirstLoad,
    bool hasPreferences,
    Map preferences,
    List<FireStatus> activeFilters,
    NowStats nowStats,
    TodayStats todayStats,
    YesterdayStats yesterdayStats,
    WeekStats weekStats,
    LastHoursStats lastHoursStats,
  }) {
    return new AppState(
      fires: fires ?? this.fires,
      fire: fire ?? this.fires,
      isLoading: isLoading ?? this.isLoading,
      hasFirstLoad: hasFirstLoad ?? this.hasFirstLoad,
      hasPreferences: hasPreferences ?? this.hasPreferences,
      preferences: preferences ?? this.preferences,
      activeFilters: activeFilters ?? this.activeFilters,
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
    return 'AppState\n{isLoading: $isLoading, \nfires count: ${fires?.length}, \nselected fire: $fire, \nhasFirstLoad: $hasFirstLoad, \nhasPreferences: $hasPreferences, \nprefs: $preferences, \nactivefilters: $activeFilters, \nNow Statistics: $nowStats, \nToday Statistics: $todayStats}, \nYesterday Statistics: $yesterdayStats, \nLast Night Statistics: $lastNightStats, \nWeek Statistics: $weekStats, \nLast Hours Statistics: $lastHoursStats}';
  }
}
