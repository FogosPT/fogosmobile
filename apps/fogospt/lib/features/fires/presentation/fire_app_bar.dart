import 'package:flutter/material.dart';
import 'package:fogos_api/features/latest_warnings/domain/fire.dart';

class FireAppBar extends StatelessWidget implements PreferredSizeWidget {
  const FireAppBar({
    super.key,
    this.warning,
  });

  final Fire? warning;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
      title: Text('Warning ${warning != null ? '- ${warning?.district}' : ''}'),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
