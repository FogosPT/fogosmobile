import 'package:fogos_api/features/latest_warnings/domain/resources.dart';

class WarningChartData {
  final List<Resources> resources;

  WarningChartData({required this.resources});

  /// Maximum value for the Y axis with a 10% margin
  double axisY() {
    return _maximumValueAxisY() * 1.1;
  }

  /// Maximum value for the Y axis
  ///
  /// Basically calculating the maximum value for each resource type.
  ///
  int _maximumValueAxisY() {
    final maxMan = resources.fold<double>(
      0.0,
      (double previousValue, resource) => resource.man > previousValue
          ? resource.man.toDouble()
          : previousValue,
    );

    final maxTerrain = resources.fold<double>(
      0.0,
      (double previousValue, resource) => resource.terrain > previousValue
          ? resource.terrain.toDouble()
          : previousValue,
    );
    final maxAerial = resources.fold<double>(
      0.0,
      (double previousValue, resource) => resource.aerial > previousValue
          ? resource.aerial.toDouble()
          : previousValue,
    );

    final maxY = [maxMan, maxTerrain, maxAerial]
        .reduce((value, element) => value > element ? value : element)
        .ceil();

    return maxY;
  }
}
