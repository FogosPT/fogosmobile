import 'package:bloc/bloc.dart';
import 'package:dart_mappable/dart_mappable.dart';
import 'package:meta/meta.dart';

part 'municipalitis_notifications_state.dart';

class MunicipalitisNotificationsCubit extends Cubit<MunicipalitisNotificationsState> {
  MunicipalitisNotificationsCubit() : super(MunicipalitisNotificationsInitial());
}
