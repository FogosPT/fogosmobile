import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:warnings_core/logger.dart';

class CurrentVersionText extends StatelessWidget {
  final TextStyle? style;

  const CurrentVersionText({
    super.key,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: PackageInfo.fromPlatform(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          log('Error loading version');
          return const SizedBox.shrink();
        }
        return Text(
          snapshot.data!.version,
          style: style,
        );
      },
    );
  }
}
