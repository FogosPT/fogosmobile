import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fogosmobile/actions/fires_actions.dart';
import 'package:fogosmobile/localization/fogos_localizations.dart';
import 'package:fogosmobile/models/app_state.dart';
import 'package:fogosmobile/models/fire_details.dart';
import 'package:community_charts_flutter/community_charts_flutter.dart' as charts;
import 'package:fogosmobile/screens/assets/images.dart';
import 'package:intl/intl.dart';
import 'package:redux/redux.dart';

class MeansStatistics extends StatefulWidget {
  @override
  State<MeansStatistics> createState() => _MeansStatisticsState();
}

class _MeansStatisticsState extends State<MeansStatistics> {
  final TextStyle _body = const TextStyle(color: Colors.black, fontSize: 25);

  Means? _selected;

  static const Color _manColor = Color(0xffFDD835);
  static const Color _terrainColor = Color(0xff43A047);
  static const Color _aerialColor = Color(0xff1E88E5);

  charts.Color get _manChartColor =>
      charts.Color(r: _manColor.red, g: _manColor.green, b: _manColor.blue);
  charts.Color get _terrainChartColor => charts.Color(
      r: _terrainColor.red, g: _terrainColor.green, b: _terrainColor.blue);
  charts.Color get _aerialChartColor => charts.Color(
      r: _aerialColor.red, g: _aerialColor.green, b: _aerialColor.blue);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppState>(
      converter: (Store<AppState> store) => store.state,
      onInit: (Store<AppState> store) {
        store.dispatch(LoadFireMeansHistoryAction(store.state.selectedFire!.id));
      },
      builder: (BuildContext context, AppState state) {
        MeansHistory? stats = state.fireMeansHistory;

        if (stats == null) {
          if (state.errors != null && state.errors.contains('fireMeansHistory')) {
            return Center(child: Text(FogosLocalizations.of(context).textProblemLoadingData));
          }
          return Center(child: CircularProgressIndicator());
        }

        final String manLabel = FogosLocalizations.of(context).textFirefighters;
        final String terrainLabel = FogosLocalizations.of(context).textVehicles;
        final String aerialLabel = FogosLocalizations.of(context).textAerial;

        List<charts.Series<Means, DateTime>> _createSampleData() {
          return [
            charts.Series<Means, DateTime>(
              id: manLabel,
              colorFn: (_, __) => _manChartColor,
              domainFn: (Means stats, _) => stats.label!,
              measureFn: (Means stats, _) => stats.man,
              data: stats.means,
            ),
            charts.Series<Means, DateTime>(
              id: terrainLabel,
              colorFn: (_, __) => _terrainChartColor,
              domainFn: (Means stats, _) => stats.label!,
              measureFn: (Means stats, _) => stats.terrain,
              data: stats.means,
            ),
            charts.Series<Means, DateTime>(
              id: aerialLabel,
              colorFn: (_, __) => _aerialChartColor,
              domainFn: (Means stats, _) => stats.label!,
              measureFn: (Means stats, _) => stats.aerial,
              data: stats.means,
            )..setAttribute(
                charts.measureAxisIdKey, 'secondaryMeasureAxisId'),
          ];
        }

        void _onSelectionChanged(charts.SelectionModel<DateTime> model) {
          final selectedDatum = model.selectedDatum;
          setState(() {
            _selected = selectedDatum.isEmpty
                ? null
                : selectedDatum.first.datum as Means;
          });
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
                      stats.means[stats.means.length - 1].man.toString(), 50.0, const Color(0xffF25C54)),
                  _buildItem(imgSvgFireTruck,
                      stats.means[stats.means.length - 1].terrain.toString(), 50.0, const Color(0xffF25C54)),
                  _buildItem(imgSvgPlane,
                      stats.means[stats.means.length - 1].aerial.toString(), 50.0, const Color(0xffF25C54)),
                ],
              ),
              SizedBox(
                height: 300,
                child: Stack(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: charts.TimeSeriesChart(
                        _createSampleData(),
                        animate: true,
                        domainAxis: charts.DateTimeAxisSpec(
                          tickFormatterSpec: charts.AutoDateTimeTickFormatterSpec(
                            minute: charts.TimeFormatterSpec(
                                format: 'HH:mm', transitionFormat: 'HH:mm'),
                            hour: charts.TimeFormatterSpec(
                                format: 'HH:mm', transitionFormat: 'HH:mm'),
                          ),
                        ),
                        behaviors: [
                          charts.SeriesLegend(
                            position: charts.BehaviorPosition.bottom,
                            outsideJustification:
                                charts.OutsideJustification.startDrawArea,
                            cellPadding:
                                EdgeInsets.only(right: 16.0, bottom: 4.0),
                          ),
                          charts.LinePointHighlighter(
                            showHorizontalFollowLine:
                                charts.LinePointHighlighterFollowLineType.none,
                            showVerticalFollowLine:
                                charts.LinePointHighlighterFollowLineType.nearest,
                          ),
                          charts.SelectNearest(
                            eventTrigger: charts.SelectionTrigger.tapAndDrag,
                          ),
                        ],
                        selectionModels: [
                          charts.SelectionModelConfig<DateTime>(
                            type: charts.SelectionModelType.info,
                            changedListener: _onSelectionChanged,
                          ),
                        ],
                        defaultRenderer: charts.LineRendererConfig(
                            includeArea: true, stacked: false),
                        secondaryMeasureAxis: const charts.NumericAxisSpec(
                          tickProviderSpec:
                              charts.BasicNumericTickProviderSpec(
                                  desiredTickCount: 5),
                        ),
                        dateTimeFactory: const charts.LocalDateTimeFactory(),
                      ),
                    ),
                    if (_selected != null)
                      Positioned(
                        top: 8,
                        right: 8,
                        child: _buildTooltip(
                            _selected!, manLabel, terrainLabel, aerialLabel),
                      ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTooltip(
      Means point, String manLabel, String terrainLabel, String aerialLabel) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.78),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          if (point.label != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Text(
                DateFormat('dd-MM HH:mm').format(point.label!),
                style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 10,
                    fontWeight: FontWeight.w500),
              ),
            ),
          _tooltipRow(_manColor, manLabel, point.man),
          _tooltipRow(_terrainColor, terrainLabel, point.terrain),
          _tooltipRow(_aerialColor, aerialLabel, point.aerial),
        ],
      ),
    );
  }

  Widget _tooltipRow(Color color, String label, int value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 1),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(width: 8, height: 8, color: color),
          const SizedBox(width: 6),
          Text(
            '$label: $value',
            style: const TextStyle(
                color: Colors.white,
                fontSize: 11,
                fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  Widget _buildItem(String imgPath, String text,
      [double height = 50.0, Color? color]) {
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
