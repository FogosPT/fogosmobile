

// class LastHoursStatistics extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return StoreConnector<AppState, LastHoursStats>(
//         converter: (Store<AppState> store) => store.state.lastHoursStats,
//         builder: (BuildContext context, LastHoursStats lastHoursStats) {
//           List<charts.Series<LastHour, DateTime>> _createSampleData() {
//             return [
//               charts.Series<LastHour, DateTime>(
//                 id: FogosLocalizations.of(context).textFires,
//                 colorFn: (_, __) => charts.MaterialPalette.red.shadeDefault,
//                 domainFn: (LastHour stats, _) => stats.label,
//                 measureFn: (LastHour stats, _) => stats.total,
//                 data: lastHoursStats.lastHours,
//               ),
//               charts.Series<LastHour, DateTime>(
//                 id: FogosLocalizations.of(context).textFirefighters,
//                 colorFn: (_, __) => charts.MaterialPalette.yellow.shadeDefault,
//                 domainFn: (LastHour stats, _) => stats.label,
//                 measureFn: (LastHour stats, _) => stats.man,
//                 data: lastHoursStats.lastHours,
//               ),
//               charts.Series<LastHour, DateTime>(
//                 id: FogosLocalizations.of(context).textVehicles,
//                 colorFn: (_, __) => charts.MaterialPalette.green.shadeDefault,
//                 domainFn: (LastHour stats, _) => stats.label,
//                 measureFn: (LastHour stats, _) => stats.cars,
//                 data: lastHoursStats.lastHours,
//               ),
//               charts.Series<LastHour, DateTime>(
//                 id: FogosLocalizations.of(context).textAerial,
//                 colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
//                 domainFn: (LastHour stats, _) => stats.label,
//                 measureFn: (LastHour stats, _) => stats.aerial,
//                 data: lastHoursStats.lastHours,
//               ),
//             ];
//           }

//           return Container(
//             padding: EdgeInsets.symmetric(horizontal: 8),
//             child: charts.TimeSeriesChart(
//               _createSampleData(),
//               animate: true,
//               behaviors: [
//                 charts.SeriesLegend(
//                   position: charts.BehaviorPosition.bottom,
//                   outsideJustification:
//                       charts.OutsideJustification.startDrawArea,
//                   horizontalFirst: false,
//                   desiredMaxRows: 2,
//                   cellPadding: EdgeInsets.only(right: 16.0, bottom: 4.0),
//                 )
//               ],
//               defaultRenderer:
//                   charts.LineRendererConfig(includeArea: true, stacked: false),
//               dateTimeFactory: const charts.LocalDateTimeFactory(),
//             ),
//             height: 400,
//           );
//         });
//   }
// }
