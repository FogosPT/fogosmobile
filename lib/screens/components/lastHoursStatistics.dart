import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:fogosmobile/models/app_state.dart';
import 'package:fogosmobile/models/statistics.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:redux/redux.dart';

class LastHoursStatistics extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, LastHoursStats>(
        converter: (Store<AppState> store) => store.state.lastHoursStats,
        builder: (BuildContext context, LastHoursStats lastHoursStats) {
          if (lastHoursStats == null) {
            return Center(child: CircularProgressIndicator());
          }

          List<charts.Series<LastHour, DateTime>> _createSampleData() {
            return [
              charts.Series<LastHour, DateTime>(
                id: 'Incêndios',
                colorFn: (_, __) => charts.MaterialPalette.red.shadeDefault,
                domainFn: (LastHour stats, _) => stats.label,
                measureFn: (LastHour stats, _) => stats.total,
                data: lastHoursStats.lastHours,
              ),
              charts.Series<LastHour, DateTime>(
                id: 'Humanos',
                colorFn: (_, __) => charts.MaterialPalette.yellow.shadeDefault,
                domainFn: (LastHour stats, _) => stats.label,
                measureFn: (LastHour stats, _) => stats.man,
                data: lastHoursStats.lastHours,
              ),
              charts.Series<LastHour, DateTime>(
                id: 'Terrestres',
                colorFn: (_, __) => charts.MaterialPalette.green.shadeDefault,
                domainFn: (LastHour stats, _) => stats.label,
                measureFn: (LastHour stats, _) => stats.cars,
                data: lastHoursStats.lastHours,
              ),
              charts.Series<LastHour, DateTime>(
                id: 'Aéreos',
                colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
                domainFn: (LastHour stats, _) => stats.label,
                measureFn: (LastHour stats, _) => stats.aerial,
                data: lastHoursStats.lastHours,
              ),
            ];
          }

          return Container(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: charts.TimeSeriesChart(
              _createSampleData(),
              animate: true,
              behaviors: [
                new charts.SeriesLegend(
                  position: charts.BehaviorPosition.bottom,
                  outsideJustification:
                      charts.OutsideJustification.startDrawArea,
                  horizontalFirst: false,
                  desiredMaxRows: 2,
                  cellPadding: new EdgeInsets.only(right: 16.0, bottom: 4.0),
                )
              ],
              defaultRenderer: new charts.LineRendererConfig(
                  includeArea: true, stacked: false),
              dateTimeFactory: const charts.LocalDateTimeFactory(),
            ),
            height: 400,
          );
        });
  }
}
