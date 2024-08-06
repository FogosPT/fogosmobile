import 'package:flutter/widgets.dart';

class WarningChartLabelsItem extends StatelessWidget {
  final Color color;
  final String label;

  const WarningChartLabelsItem({
    super.key,
    required this.color,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ColoredBox(
          color: color,
          child: SizedBox.square(
            dimension: 20,
          ),
        ),
        SizedBox(
          width: 10,
        ),
        Text(label),
      ],
    );
  }
}
