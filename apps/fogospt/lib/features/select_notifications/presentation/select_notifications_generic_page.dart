import 'package:flutter/material.dart';
import 'package:fogospt/features/select_notifications/application/generic_shared_preferences.dart';
import 'package:fogospt/main.dart';

class SelectNotificationsGenericPage extends StatefulWidget {
  @override
  _SelectNotificationsGenericPageState createState() =>
      _SelectNotificationsGenericPageState();
}

class _SelectNotificationsGenericPageState
    extends State<SelectNotificationsGenericPage> {
  final Map<String, String> topics = {
    // 'incident-<id-incidente>': 'Tópico por Incidente',
    'notification-warnings': 'Tópico por Avisos',
    'incident-important': 'Tópico incidentes importantes',
    'notification-all': 'Tópico para todos avisos',
  };

  Map<String, bool> subscriptionStatus = {};

  @override
  void initState() {
    super.initState();
    _loadSubscriptionStatus();
  }

  Future<void> _loadSubscriptionStatus() async {
    for (String key in topics.keys) {
      bool status =
          await NotificationPreferences.getTopicSubscription(topic: key);
      setState(() {
        subscriptionStatus[key] = status;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Subscrições de Notificações'),
      ),
      body: ListView.builder(
        itemCount: topics.length,
        itemBuilder: (context, index) {
          String topicKey = topics.keys.elementAt(index);
          String topicDescription = topics[topicKey]!;
          return SwitchListTile(
            title: Text(topicDescription),
            value: subscriptionStatus[topicKey] ?? false,
            onChanged: (bool value) {
              _handleSubscription(topicKey, value);
            },
          );
        },
      ),
    );
  }

  void _handleSubscription(String topic, bool isSubscribing) async {
    try {
      await toggleFirebaseMessageByTopic(
        topic: topic,
        toggleValue: isSubscribing,
      );

      // Save the subscription status locally
      await NotificationPreferences.saveTopicSubscription(
        topic: topic,
        isSubscribed: isSubscribing,
      );

      setState(() {
        subscriptionStatus[topic] = isSubscribing;
      });

      if (isSubscribing) {
        print('Subscribed to $topic');
      } else {
        print('Unsubscribed from $topic');
      }
    } catch (e) {
      print('Error toggling subscription for $topic: $e');
      // Show error message to user
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao alterar subscrição. Tente novamente.')),
      );
    }
  }
}
