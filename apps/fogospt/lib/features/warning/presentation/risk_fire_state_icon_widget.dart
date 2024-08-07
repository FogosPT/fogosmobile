import 'package:flutter/material.dart';
import 'package:fogos_api/features/latest_warnings/domain/history_status.dart';
import 'package:fogospt/constants/assets.dart';

class RiskFireStateIconWidget extends StatelessWidget {
  final HistoryStatus status;

  const RiskFireStateIconWidget({
    super.key,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 20,
      width: 20,
      padding: EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: Colors.amber, // TODO(FB) - Change color based on status
        shape: BoxShape.circle,
      ),
      child: icoFire,
    );
  }
}
