import 'package:fogosmobile/actions/statistics_actions.dart';
import 'package:fogosmobile/models/statistics.dart';

lastHoursStatsReducer(LastHoursStats? stats, action) {
  if (action is LoadLastHoursAction) {
    return stats;
  } else if (action is LastHoursLoadedAction) {
    return action.lastHoursStats;
  }
  return stats;
}

lastNightStatsReducer(LastNightStats? stats, action) {
  if (action is LoadLastNightStatsAction) {
    return stats;
  } else if (action is LastNightStatsLoadedAction) {
    return action.lastNightStats;
  }
  return stats;
}

nowStatsReducer(NowStats? stats, action) {
  if (action is LoadNowStatsAction) {
    return stats;
  } else if (action is NowStatsLoadedAction) {
    return action.nowStats;
  }
  return stats;
}

todayStatsReducer(TodayStats? stats, action) {
  if (action is LoadTodayStatsAction) {
    return stats;
  } else if (action is TodayStatsLoadedAction) {
    return action.todayStats;
  }
  return stats;
}

weekStatsReducer(WeekStats? stats, action) {
  if (action is LoadWeekStatsAction) {
    return stats;
  } else if (action is WeekStatsLoadedAction) {
    return action.weekStats;
  }
  return stats;
}

yesterdayStatsReducer(YesterdayStats? stats, action) {
  if (action is LoadYesterdayStatsAction) {
    return stats;
  } else if (action is YesterdayStatsLoadedAction) {
    return action.yesterdayStats;
  }
  return stats;
}
