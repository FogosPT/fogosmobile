

// class TodayStatistics extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return StoreConnector<AppState, TodayStats>(
//         converter: (Store<AppState> store) => store.state.todayStats,
//         builder: (BuildContext context, TodayStats todayStats) {
//           var intervalSeries = [
//             charts.Series<IntervalStats, String>(
//               id: FogosLocalizations.of(context).textTodayInterval,
//               colorFn: (_, __) => c.Color.fromHex(code: "#ff512f"),
//               domainFn: (IntervalStats stats, _) => stats.label,
//               measureFn: (IntervalStats stats, _) => stats.total,
//               labelAccessorFn: (IntervalStats stats, _) =>
//                   ' ${stats.total.toString()}',
//               data: todayStats.intervalStatsList,
//             ),
//           ];
//           var intervalChart = charts.BarChart(
//             intervalSeries,
//             animate: true,
//             vertical: false,
//             barRendererDecorator: charts.BarLabelDecorator<String>(),
//           );

//           var districtSeries = [
//             charts.Series<District, String>(
//               id: FogosLocalizations.of(context).textTodayDistricts,
//               colorFn: (District stats, _) => c.Color(
//                     r: (25 * stats.fires).clamp(0, 255),
//                     g: 0,
//                     b: 0,
//                   ),
//               domainFn: (District stats, _) => stats.district,
//               measureFn: (District stats, _) => stats.fires,
//               labelAccessorFn: (District stats, _) => '${stats.district}',
//               data: todayStats.districtList,
//             ),
//           ];

//           var districtChart = charts.BarChart(
//             districtSeries,
//             animate: true,
//             vertical: false,
//             barRendererDecorator: charts.BarLabelDecorator<String>(),
//             domainAxis: charts.OrdinalAxisSpec(
//                 renderSpec: charts.NoneRenderSpec()),
//           );

//           return Container(
//             padding: EdgeInsets.symmetric(horizontal: 8),
//             child: Column(
//               children: <Widget>[
//                 Container(
//                   child: intervalChart,
//                   height: 50.0 * todayStats.intervalStatsList.length,
//                 ),
//                 Container(
//                   child: districtChart,
//                   height: 35.0 * todayStats.districtList.length,
//                 )
//               ],
//             ),
//           );
//         });
//   }
// }
