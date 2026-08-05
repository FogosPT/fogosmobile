import 'package:fogosmobile/models/statistics.dart';

class LoadNowStatsAction {}

class NowStatsLoadedAction {
  final NowStats? nowStats;

  NowStatsLoadedAction(this.nowStats);
}

class LoadTodayStatsAction {}

class TodayStatsLoadedAction {
  final TodayStats? todayStats;

  TodayStatsLoadedAction(this.todayStats);
}

class LoadYesterdayStatsAction {}

class YesterdayStatsLoadedAction {
  final YesterdayStats? yesterdayStats;

  YesterdayStatsLoadedAction(this.yesterdayStats);
}

class LoadLastNightStatsAction {}

class LastNightStatsLoadedAction {
  final LastNightStats? lastNightStats;

  LastNightStatsLoadedAction(this.lastNightStats);
}

class LoadWeekStatsAction {}

class WeekStatsLoadedAction {
  final WeekStats? weekStats;

  WeekStatsLoadedAction(this.weekStats);
}

class LoadLastHoursAction {}

class LastHoursLoadedAction {
  final LastHoursStats? lastHoursStats;

  LastHoursLoadedAction(this.lastHoursStats);
}
