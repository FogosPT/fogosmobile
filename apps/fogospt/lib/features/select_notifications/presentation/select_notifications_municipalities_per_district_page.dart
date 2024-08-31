import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fogospt/features/select_notifications/application/municipalities_cubit/municipalities_cubit.dart';
import 'package:fogospt/features/select_notifications/application/municipalities_cubit/municipalities_state.dart';
import 'package:fogospt/features/select_notifications/application/notifications_selected_district_cubit/notifications_selected_district_cubit.dart';
import 'package:fogospt/features/select_notifications/application/notifications_selected_district_cubit/notifications_selected_district_state.dart';
import 'package:fogospt/features/select_notifications/application/selected_notifications_cubit/selected_notifications_cubit.dart';
import 'package:fogospt/features/select_notifications/application/selected_notifications_cubit/selected_notifications_state.dart';
import 'package:fogospt/features/select_notifications/presentation/select_notifications_municipalities_per_district_page_view.dart';

class NotificationsMunicipalitiesPerDistrictPage extends StatelessWidget {
  const NotificationsMunicipalitiesPerDistrictPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MunicipalitiesCubit, MunicipalitiesState>(
      builder: (context, municipalityState) {
        return BlocBuilder<SelectedNotificationsCubit,
            SelectedNotificationsState>(
          builder: (context, state) {
            final activeMunicipalities = state.enabledMunicipalityNotifications;
            return BlocBuilder<SelectedDistrictCubit, DistrictSelectedState>(
              builder: (context, selectedDistrictState) {
                final currentDistrict =
                    municipalityState.municipalitiesPerDistrict[
                            selectedDistrictState.district] ??
                        [];

                final districtName = selectedDistrictState.district?.name;

                if (districtName == null) {
                  /// TODO(FB): What do to here?
                  return Container();
                }

                /// build
                return NotificationsMunicipalitiesPerDistrictPageView(
                  currentDistrict: currentDistrict,
                  activeMunicipalities: activeMunicipalities,
                  districtName: districtName,
                );
              },
            );
          },
        );
      },
    );
  }
}
