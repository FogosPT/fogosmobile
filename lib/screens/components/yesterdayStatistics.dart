import 'package:charts_common/common.dart' as c;
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:fogosmobile/localization/fogos_localizations.dart';
import 'package:fogosmobile/models/app_state.dart';
import 'package:fogosmobile/models/statistics.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:redux/redux.dart';

class YesterdayStatistics extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, YesterdayStats>(
        converter: (Store<AppState> store) => store.state.yesterdayStats,
        builder: (BuildContext context, YesterdayStats yesterdayStats) {
          if (yesterdayStats == null) {
            return Center(child: CircularProgressIndicator());
          }
          var intervalSeries = [
            charts.Series<IntervalStats, String>(
              id: FogosLocalizations.of(context).textYesterdayInterval,
              colorFn: (_, __) => c.Color.fromHex(code: "#ff512f"),
              domainFn: (IntervalStats stats, _) => stats.label,
              measureFn: (IntervalStats stats, _) => stats.total,
              labelAccessorFn: (IntervalStats stats, _) =>
                  ' ${stats.total.toString()}',
              data: yesterdayStats.intervalStatsList,
            ),
          ];
          var intervalChart = charts.BarChart(
            intervalSeries,
            animate: true,
            vertical: false,
            barRendererDecorator: charts.BarLabelDecorator<String>(),
          );

          var districtSeries = [
            new charts.Series<District, String>(
              id: FogosLocalizations.of(context).textYesterdayDistricts,
              colorFn: (District stats, _) => c.Color(
                    r: (25 * stats.fires).clamp(0, 255),
                    g: 0,
                    b: 0,
                  ),
              domainFn: (District stats, _) => stats.district,
              measureFn: (District stats, _) => stats.fires,
              data: yesterdayStats.districtList,
            ),
          ];

          var districtChart = new charts.BarChart(
            districtSeries,
            animate: true,
            vertical: false,
            barRendererDecorator: new charts.BarLabelDecorator<String>(),
            domainAxis: new charts.OrdinalAxisSpec(
                renderSpec: new charts.NoneRenderSpec()),
          );

          return Container(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: Column(
              children: <Widget>[
                Container(
                  child: intervalChart,
                  height: 50.0 * yesterdayStats.intervalStatsList.length,
                ),
                Container(
                  child: districtChart,
                  height: 35.0 * yesterdayStats.districtList.length,
                )
              ],
            ),
          );
        });
  }
}
