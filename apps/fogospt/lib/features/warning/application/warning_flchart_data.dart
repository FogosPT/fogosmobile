import 'package:fl_chart/fl_chart.dart';
import 'package:fogospt/features/warning/application/warning_chart_data.dart';

/// Depends on fl_chart
class WarningFlChartData extends WarningChartData {
  final List<FlSpot> man = [];
  final List<FlSpot> terrain = [];
  final List<FlSpot> aerial = [];

  WarningFlChartData({required super.resources});

  List<FlSpot> manToFlSpots() {
    return resources
        .map(
          (resource) => FlSpot(
            resource.created.toDouble(),
            resource.man.toDouble(),
          ),
        )
        .toList();
  }

  List<FlSpot> terrainToFlSpots() {
    return resources
        .map(
          (resource) => FlSpot(
            resource.created.toDouble(),
            resource.terrain.toDouble(),
          ),
        )
        .toList();
  }

  List<FlSpot> aerialToFlSpots() {
    return resources
        .map(
          (resource) => FlSpot(
            resource.created.toDouble(),
            resource.aerial.toDouble(),
          ),
        )
        .toList();
  }
}
