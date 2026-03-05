import 'package:fogosmobile/actions/statistics_actions.dart';
import 'package:fogosmobile/models/statistics.dart';

NowStats? nowStatsReducer(NowStats? stats, action) {
  if (action is LoadNowStatsAction) {
    return stats;
  } else if (action is NowStatsLoadedAction) {
    return action.nowStats;
  } else {
    return stats;
  }
}

TodayStats? todayStatsReducer(TodayStats? stats, action) {
  if (action is LoadTodayStatsAction) {
    return stats;
  } else if (action is TodayStatsLoadedAction) {
    return action.todayStats;
  } else {
    return stats;
  }
}

YesterdayStats? yesterdayStatsReducer(YesterdayStats? stats, action) {
  if (action is LoadYesterdayStatsAction) {
    return stats;
  } else if (action is YesterdayStatsLoadedAction) {
    return action.yesterdayStats;
  } else {
    return stats;
  }
}

LastNightStats? lastNightStatsReducer(LastNightStats? stats, action) {
  if (action is LoadLastNightStatsAction) {
    return stats;
  } else if (action is LastNightStatsLoadedAction) {
    return action.lastNightStats;
  } else {
    return stats;
  }
}

WeekStats? weekStatsReducer(WeekStats? stats, action) {
  if (action is LoadWeekStatsAction) {
    return stats;
  } else if (action is WeekStatsLoadedAction) {
    return action.weekStats;
  } else {
    return stats;
  }
}

LastHoursStats? lastHoursStatsReducer(LastHoursStats? stats, action) {
  if (action is LoadLastHoursAction) {
    return stats;
  } else if (action is LastHoursLoadedAction) {
    return action.lastHoursStats;
  } else {
    return stats;
  }
}
