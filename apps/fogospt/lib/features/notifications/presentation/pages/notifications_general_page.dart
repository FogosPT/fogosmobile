import 'package:flutter/material.dart';

class NotificationsGeneralPage extends StatelessWidget {
  const NotificationsGeneralPage({super.key});

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
