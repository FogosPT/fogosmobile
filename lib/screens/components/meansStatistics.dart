import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fogosmobile/actions/fires_actions.dart';
import 'package:fogosmobile/localization/fogos_localizations.dart';
import 'package:fogosmobile/models/app_state.dart';
import 'package:fogosmobile/models/fire_details.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:fogosmobile/screens/assets/images.dart';
import 'package:redux/redux.dart';

class MeansStatistics extends StatelessWidget {
  final TextStyle _body = TextStyle(color: Colors.black, fontSize: 25);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppState>(
      converter: (Store<AppState> store) => store.state,
      onInit: (Store<AppState> store) {
        store.dispatch(LoadFireMeansHistoryAction(store.state.fire.id));
      },
      builder: (BuildContext context, AppState state) {
        MeansHistory stats = state.fireMeansHistory;

        if (stats == null) {
          if (state.errors != null && state.errors.contains('fireMeansHistory')) {
            return Center(child: Text('There was an error loading this chart.'));
          }
          return Center(child: CircularProgressIndicator());
        }

        List<charts.Series<Means, DateTime>> _createSampleData() {
          return [
            charts.Series<Means, DateTime>(
              id: FogosLocalizations.of(context).textFireman,
              colorFn: (_, __) => charts.MaterialPalette.yellow.shadeDefault,
              domainFn: (Means stats, _) => stats.label,
              measureFn: (Means stats, _) => stats.man,
              data: stats.means,
            ),
            charts.Series<Means, DateTime>(
              id: FogosLocalizations.of(context).textVehicles,
              colorFn: (_, __) => charts.MaterialPalette.green.shadeDefault,
              domainFn: (Means stats, _) => stats.label,
              measureFn: (Means stats, _) => stats.terrain,
              data: stats.means,
            ),
            charts.Series<Means, DateTime>(
              id: FogosLocalizations.of(context).textAerial,
              colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
              domainFn: (Means stats, _) => stats.label,
              measureFn: (Means stats, _) => stats.aerial,
              data: stats.means,
            ),
          ];
        }

        return Container(
          padding: EdgeInsets.symmetric(horizontal: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  _buildItem(imgSvgFireman,
                      stats.means[stats.means.length - 1].man.toString()),
                  _buildItem(imgSvgFireTruck,
                      stats.means[stats.means.length - 1].terrain.toString()),
                  _buildItem(imgSvgPlane,
                      stats.means[stats.means.length - 1].aerial.toString()),
                ],
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: charts.TimeSeriesChart(
                  _createSampleData(),
                  animate: true,
                  behaviors: [
                    new charts.SeriesLegend(
                      position: charts.BehaviorPosition.bottom,
                      outsideJustification:
                          charts.OutsideJustification.startDrawArea,
                      cellPadding:
                          new EdgeInsets.only(right: 16.0, bottom: 4.0),
                    )
                  ],
                  defaultRenderer: new charts.LineRendererConfig(
                      includeArea: true, stacked: false),
                  dateTimeFactory: const charts.LocalDateTimeFactory(),
                ),
                height: 300,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildItem(String imgPath, String text,
      [double height = 50.0, Color color]) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        SvgPicture.asset(
          imgPath,
          height: height,
          color: color,
        ),
        SizedBox(
          width: 5,
        ),
        Text(text, style: _body),
      ],
    );
  }
}
