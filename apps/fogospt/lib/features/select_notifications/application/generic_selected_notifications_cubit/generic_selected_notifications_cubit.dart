import 'package:bloc/bloc.dart';
import 'package:fogospt/features/select_notifications/application/generic_selected_notifications_cubit/generic_selected_notifications_state.dart';

class GenericSelectedNotificationsCubit
    extends Cubit<GenericSelectedNotificationsState> {
  GenericSelectedNotificationsCubit()
      : super(GenericSelectedNotificationsState());
}
