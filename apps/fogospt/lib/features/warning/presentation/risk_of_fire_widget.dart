import 'package:flutter/material.dart';
import 'package:fogos_api/features/latest_warnings/domain/rcm.dart';
import 'package:fogospt/features/warning/domain/risk_of_fire_type.dart';
import 'package:fogospt/utils/extensions/context_extensions.dart';

class RiskOfFireWidget extends StatelessWidget {
  final RCM rcm;

  const RiskOfFireWidget({
    super.key,
    required this.rcm,
  });

  @override
  Widget build(BuildContext context) {
    final today = RiskOfFireType.fromText(rcm.hoje);
    return SizedBox(
      height: 40,
      child: Row(
        children: RiskOfFireType.values.map<Widget>(
          (type) {
            return today == type
                ? RiskOfFireLevelExpandedWidget(type: type)
                : RiskOfFireLevelWidget(type: type);
          },
        ).toList(),
      ),
    );
  }
}

class RiskOfFireLevelWidget extends StatelessWidget {
  final RiskOfFireType type;
  final Widget? child;
  const RiskOfFireLevelWidget({
    super.key,
    required this.type,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: type != RiskOfFireType.maximum
          ? EdgeInsets.only(right: 1.5)
          : EdgeInsets.zero,
      width: 10,
      child: child,
      decoration: BoxDecoration(
        color: type.color,
        borderRadius: BorderRadius.all(Radius.circular(3)),
      ),
    );
  }
}

class RiskOfFireLevelExpandedWidget extends StatelessWidget {
  final RiskOfFireType type;

  RiskOfFireLevelExpandedWidget({required this.type});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: RiskOfFireLevelWidget(
        type: type,
        child: Align(
          alignment: Alignment.center,
          child: Text(
            type.text,
            style: context.textTheme.bodyLarge?.copyWith(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
