import 'package:charts_common/common.dart' as c;
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:fogosmobile/localization/fogos_localizations.dart';
import 'package:fogosmobile/models/app_state.dart';
import 'package:fogosmobile/models/statistics.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:redux/redux.dart';

class WeekStatistics extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, WeekStats>(
        converter: (Store<AppState> store) => store.state.weekStats,
        builder: (BuildContext context, WeekStats weekStats) {
          if (weekStats == null) {
            return Center(child: CircularProgressIndicator());
          }

          List<charts.Series<Day, String>> _createSampleData() {
            return [
              charts.Series<Day, String>(
                id: FogosLocalizations.of(context).textTotal,
                colorFn: (_, __) => c.Color.fromHex(code: "#ff512f"),
                domainFn: (Day stats, _) => stats.label,
                measureFn: (Day stats, _) => stats.total,
                labelAccessorFn: (Day stats, _) => ' ${stats.total.toString()}',
                data: weekStats.days,
              ),
              charts.Series<Day, String>(
                id: FogosLocalizations.of(context).textFalseAlarm,
                colorFn: (_, __) => c.Color.black,
                domainFn: (Day stats, _) => stats.label,
                measureFn: (Day stats, _) => stats.fake,
                labelAccessorFn: (Day stats, _) => ' ${stats.fake.toString()}',
                data: weekStats.days,
              ),
            ];
          }

          return Container(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: charts.BarChart(
              _createSampleData(),
              animate: true,
              vertical: false,
              barRendererDecorator: charts.BarLabelDecorator<String>(),
              barGroupingType: charts.BarGroupingType.stacked,
              defaultInteractions: true,
              behaviors: [new charts.SeriesLegend()],
            ),
            height: 300,
          );
        });
  }
}
