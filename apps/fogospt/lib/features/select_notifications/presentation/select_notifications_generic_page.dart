import 'package:flutter/material.dart';
import 'package:fogospt/main.dart';

class SelectNotificationsGenericPage extends StatelessWidget {
  const SelectNotificationsGenericPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView.builder(itemBuilder: (context, index) {
        return Column(
          children: [
            Row(
              children: [
                Text('Todas as notificações'),
                Switch(
                  value: true,
                  onChanged: (changed) {
                    subscribeToFirebaseMessageTopics();
                  },
                ),
              ],
            ),
          ],
        );
      }),
    );
  }
}
