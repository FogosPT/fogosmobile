import 'package:flutter/material.dart';
import 'package:fogospt/features/warning/presentation/warning_chart_labels_item_widget.dart';

class WarningChartLabels extends StatelessWidget {
  final List<WarningChartLabelsItem> labels;
  final Axis direction;
  final MainAxisAlignment mainAxisAlignment;

  const WarningChartLabels._({
    super.key,
    required this.labels,
    this.direction = Axis.horizontal,
    this.mainAxisAlignment = MainAxisAlignment.start,
  });

  WarningChartLabels.spaceEvenly({
    required List<WarningChartLabelsItem> labels,
    Axis direction = Axis.horizontal,
  }) : this._(
          labels: labels,
          direction: direction,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        );

  WarningChartLabels.build({
    required List<WarningChartLabelsItem> labels,
    required Axis direction,
    required MainAxisAlignment mainAxisAlignment,
  }) : this._(
          labels: labels,
          direction: direction,
          mainAxisAlignment: mainAxisAlignment,
        );

  @override
  Widget build(BuildContext context) {
    return Flex(
      direction: direction,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: labels,
    );
  }
}
