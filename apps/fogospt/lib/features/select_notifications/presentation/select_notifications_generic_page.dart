import 'package:flutter/material.dart';

class SelectNotificationsGeneralPage extends StatelessWidget {
  const SelectNotificationsGeneralPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView.builder(itemBuilder: (context, index) {
        return Center(
          child: Text('$index'),
        );
      }),
    );
  }
}
