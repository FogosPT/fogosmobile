import 'package:charts_common/common.dart' as c;
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:fogosmobile/models/app_state.dart';
import 'package:fogosmobile/models/statistics.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:redux/redux.dart';

class LastNightStatistics extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, LastNightStats>(
        converter: (Store<AppState> store) => store.state.lastNightStats,
        builder: (BuildContext context, LastNightStats lastNightStats) {
          if (lastNightStats == null) {
            return Center(child: CircularProgressIndicator());
          }

          var districtSeries = [
            new charts.Series<District, String>(
              id: "Last Night Districts",
              colorFn: (District stats, _) => c.Color(
                    r: (25 * stats.fires).clamp(0, 255),
                    g: 0,
                    b: 0,
                  ),
              domainFn: (District stats, _) => stats.district,
              measureFn: (District stats, _) => stats.fires,
              labelAccessorFn: (District stats, _) => '${stats.district}',
              data: lastNightStats.districtList,
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
            child: districtChart,
            height: 35.0 * lastNightStats.districtList.length,
          );
        });
  }
}
