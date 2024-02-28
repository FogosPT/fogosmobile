import 'package:fogosmobile/models/statistics.dart';

class LastHoursLoadedAction {
  final LastHoursStats? lastHoursStats;

  LastHoursLoadedAction(this.lastHoursStats);
}

class LastNightStatsLoadedAction {
  final LastNightStats? lastNightStats;

  LastNightStatsLoadedAction(this.lastNightStats);
}

class LoadLastHoursAction {}

class LoadLastNightStatsAction {}

class LoadNowStatsAction {}

class LoadTodayStatsAction {}

class LoadWeekStatsAction {}

class LoadYesterdayStatsAction {}

class NowStatsLoadedAction {
  final NowStats? nowStats;

  NowStatsLoadedAction(this.nowStats);
}

class TodayStatsLoadedAction {
  final TodayStats? todayStats;

  TodayStatsLoadedAction(this.todayStats);
}

class WeekStatsLoadedAction {
  final WeekStats? weekStats;

  WeekStatsLoadedAction(this.weekStats);
}

class YesterdayStatsLoadedAction {
  final YesterdayStats? yesterdayStats;

  YesterdayStatsLoadedAction(this.yesterdayStats);
}
