import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fogospt/features/select_notifications/application/generic_selected_notifications_cubit/generic_selected_notifications_cubit.dart';
import 'package:fogospt/features/select_notifications/application/generic_selected_notifications_cubit/generic_selected_notifications_state.dart';
import 'package:warnings/state_management/state_status.dart';
import 'package:warnings_core/logger.dart';

class SelectNotificationsGenericPage extends StatefulWidget {
  @override
  _SelectNotificationsGenericPageState createState() =>
      _SelectNotificationsGenericPageState();
}

class _SelectNotificationsGenericPageState
    extends State<SelectNotificationsGenericPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Subscrições de Notificações'),
      ),
      body: BlocConsumer<GenericSelectedNotificationsCubit,
          GenericSelectedNotificationsState>(
        listener: (context, state) {
          if (state.status == StateStatus.failure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Subscrição não atualizadas'),
              ),
            );
          }
        },
        builder: (context, state) {
          return ListView.builder(
            itemCount: state.notificationsStatus.length,
            itemBuilder: (context, index) {
              String topicKey = state.notificationsStatus.keys.elementAt(index);

              /// Has no topic description, so we don't show it.
              if (!appNotificationTopics.containsKey(topicKey)) {
                log('Has no topic description for $topicKey, so we show nothing.');
                return SizedBox.shrink();
              }

              String topicDescription = appNotificationTopics[topicKey]!;

              return BlocBuilder<GenericSelectedNotificationsCubit,
                  GenericSelectedNotificationsState>(
                builder: (context, state) {
                  return SwitchListTile(
                    title: Text(topicDescription),
                    value: state.notificationsStatus[topicKey] ?? false,
                    onChanged: (bool value) {
                      context
                          .read<GenericSelectedNotificationsCubit>()
                          .toggleNotification(
                            topic: topicKey,
                            toggleValue: value,
                          );
                    },
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
