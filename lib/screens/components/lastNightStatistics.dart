
// class LastNightStatistics extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return StoreConnector<AppState, LastNightStats>(
//         converter: (Store<AppState> store) => store.state.lastNightStats,
//         builder: (BuildContext context, LastNightStats lastNightStats) {
//           var districtSeries = [
//             charts.Series<District, String>(
//               id: FogosLocalizations.of(context).textLastNightStatistics,
//               colorFn: (District stats, _) => c.Color(
//                 r: (25 * stats.fires).clamp(0, 255),
//                 g: 0,
//                 b: 0,
//               ),
//               domainFn: (District stats, _) => stats.district,
//               measureFn: (District stats, _) => stats.fires,
//               labelAccessorFn: (District stats, _) => '${stats.district}',
//               data: lastNightStats.districtList,
//             ),
//           ];

//           var districtChart = charts.BarChart(
//             districtSeries,
//             animate: true,
//             vertical: false,
//             barRendererDecorator: charts.BarLabelDecorator<String>(),
//             domainAxis:
//                 charts.OrdinalAxisSpec(renderSpec: charts.NoneRenderSpec()),
//           );

//           return Container(
//             padding: EdgeInsets.symmetric(horizontal: 8),
//             child: districtChart,
//             height: 35.0 * lastNightStats.districtList.length,
//           );
//         });
//   }
// }
