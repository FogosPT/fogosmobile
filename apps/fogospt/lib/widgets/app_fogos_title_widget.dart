import 'package:flutter/material.dart';
import 'package:fogospt/constants/colors.dart';
import 'package:fogospt/utils/extensions/context_extensions.dart';

class AppFogosTitleWidget extends StatelessWidget {
  final String title;

  const AppFogosTitleWidget({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      title.toUpperCase(),
      style: context.textTheme.headlineSmall?.copyWith(
        color: appFogosOrange,
      ),
    );
  }
}
