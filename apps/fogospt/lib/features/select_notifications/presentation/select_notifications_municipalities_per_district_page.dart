import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fogospt/features/select_notifications/application/municipalities_cubit/municipalities_cubit.dart';
import 'package:fogospt/features/select_notifications/application/notifications_selected_district_cubit/notifications_selected_district_cubit.dart';
import 'package:fogospt/features/select_notifications/application/selected_notifications_cubit/selected_notifications_cubit.dart';
import 'package:fogospt/features/select_notifications/presentation/select_notifications_municipalities_per_district_page_view.dart';

class NotificationsMunicipalitiesPerDistrictPage extends StatelessWidget {
  const NotificationsMunicipalitiesPerDistrictPage({super.key});

  @override
  Widget build(BuildContext context) {
    final municipalityCubit = context.watch<MunicipalitiesCubit>();
    final notificationsCubit = context.watch<SelectedNotificationsCubit>();
    final selectedCubit = context.watch<NotificationsSelectedDistrictCubit>();

    final selectedDistrit = selectedCubit.state.district;
    final activeMunicipalities =
        notificationsCubit.state.enabledMunicipalityNotifications;

    final currentDistrict =
        municipalityCubit.state.municipalitiesPerDistrict[selectedDistrit] ??
            [];
    final districtName = selectedDistrit?.name;

    if (districtName == null) {
      /// TODO(FB): What do to here?
      return Container();
    }
    return NotificationsMunicipalitiesPerDistrictPageView(
      currentDistrict: currentDistrict,
      activeMunicipalities: activeMunicipalities,
      districtName: districtName,
    );
  }
}
