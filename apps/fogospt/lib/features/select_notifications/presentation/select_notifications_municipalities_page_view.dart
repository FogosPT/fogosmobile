import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fogospt/features/select_notifications/application/municipalities_cubit/municipalities_cubit.dart';
import 'package:fogospt/features/select_notifications/application/municipalities_cubit/municipalities_state.dart';
import 'package:fogospt/features/select_notifications/application/notifications_selected_district_cubit/notifications_selected_district_cubit.dart';
import 'package:fogospt/features/select_notifications/application/selected_notifications_cubit/selected_notifications_cubit.dart';
import 'package:fogospt/features/select_notifications/application/selected_notifications_cubit/selected_notifications_state.dart';
import 'package:fogospt/routing/app_go_router.dart';

class SelectNotificationsMunicipalitiesPageView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SelectedNotificationsCubit, SelectedNotificationsState>(
      builder: (context, notificationState) {
        return switch (notificationState) {
          SelectedNotificationsState() =>
            BlocBuilder<MunicipalitiesCubit, MunicipalitiesState>(
              builder: (context, municipalitiesState) {
                final municipalities =
                    municipalitiesState.municipalitiesPerDistrict;

                return ListView.builder(
                  itemCount: municipalities.keys.length,
                  itemBuilder: (context, index) {
                    final district = municipalities.keys.elementAt(index);
                    return ListTile(
                      title: Text(district.name),
                      trailing: Icon(Icons.arrow_right),
                      onTap: () {
                        context
                            .read<NotificationsSelectedDistrictCubit>()
                            .selectDistrict(district);

                        NotificationsPerMunicipalityRoute().go(context);
                      },
                    );
                  },
                );
              },
            ),
        };
      },
    );
  }
}
