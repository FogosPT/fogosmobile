import 'package:fogosmobile/models/statistics.dart';

class LastHoursLoadedAction {
  final LastHoursStats? lastHoursStats;

  const LastHoursLoadedAction(this.lastHoursStats);
}

class LastNightStatsLoadedAction {
  final LastNightStats? lastNightStats;

  const LastNightStatsLoadedAction(this.lastNightStats);
}

class LoadLastHoursAction {
  const LoadLastHoursAction();
}

class LoadLastNightStatsAction {
  const LoadLastNightStatsAction();
}

class LoadNowStatsAction {
  const LoadNowStatsAction();
}

class LoadTodayStatsAction {
  const LoadTodayStatsAction();
}

class LoadWeekStatsAction {
  const LoadWeekStatsAction();
}

class LoadYesterdayStatsAction {
  const LoadYesterdayStatsAction();
}

class NowStatsLoadedAction {
  final NowStats? nowStats;

  const NowStatsLoadedAction(this.nowStats);
}

class TodayStatsLoadedAction {
  final TodayStats? todayStats;

  const TodayStatsLoadedAction(this.todayStats);
}

class WeekStatsLoadedAction {
  final WeekStats? weekStats;

  const WeekStatsLoadedAction(this.weekStats);
}

class YesterdayStatsLoadedAction {
  final YesterdayStats? yesterdayStats;

  const YesterdayStatsLoadedAction(this.yesterdayStats);
}
