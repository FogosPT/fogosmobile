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
    final state = context.watch<GenericSelectedNotificationsCubit>().state;
    return Scaffold(
      appBar: AppBar(
        title: Text('Subscrições de Notificações'),
      ),
      body: BlocListener<GenericSelectedNotificationsCubit,
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
        child: ListView.builder(
          itemCount: state.notificationsStatus.length,
          itemBuilder: (context, index) {
            String topicKey = state.notificationsStatus.keys.elementAt(index);

            /// Has no topic description, so we don't show it.
            if (!appNotificationTopics.containsKey(topicKey)) {
              log('Has no topic description for $topicKey, so we show nothing.');
              return SizedBox.shrink();
            }

            String topicDescription = appNotificationTopics[topicKey]!;

            return Visibility(
              visible: state.status != StateStatus.loading, 
              child: SwitchListTile(
                title: Text(topicDescription),
                value: state.notificationsStatus[topicKey] ?? false,
                onChanged: (bool value) {
                  /// If the state is loading, we don't want to change the state.
                  if (state.status == StateStatus.loading) {
                    return;
                  }
                  context
                      .read<GenericSelectedNotificationsCubit>()
                      .handleSubscription(topicKey, value);
                },
              ),
              replacement: Center(
                child: CircularProgressIndicator(),
              ),
            );
          },
        ),
      ),
    );
  }
}
