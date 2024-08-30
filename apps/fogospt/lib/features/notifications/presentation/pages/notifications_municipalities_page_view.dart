import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fogospt/features/notifications/application/district_selected_cubit/district_selected_cubit.dart';
import 'package:fogospt/features/notifications/application/municipality_cubit/municipality_cubit.dart';
import 'package:fogospt/features/notifications/application/municipality_cubit/municipality_state.dart';
import 'package:fogospt/features/notifications/application/notifications/notification_cubit.dart';
import 'package:fogospt/features/notifications/application/notifications/notification_state.dart';
import 'package:fogospt/features/notifications/presentation/pages/notifications_municipalities_per_district_page.dart';

class NotificationsMunicipalitiesPageView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotificationCubit, NotificationState>(
      builder: (context, notificationState) {
        return switch (notificationState) {
          NotificationSuccessful() =>
            BlocBuilder<MunicipalityCubit, MunicipalityState>(
              builder: (context, municipalitiesState) {
                if (municipalitiesState is MunicipalityStateLoaded) {
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
                              .read<DistrictSelectedCubit>()
                              .selectDistrict(district);

                          ///TODO(FB) - Use GoRouter
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) {
                                return NotificationsMunicipalitiesPerDistrictPage();
                              },
                            ),
                          );
                        },
                      );
                    },
                  );
                }
                return Center(
                  child: CircularProgressIndicator(),
                );
              },
            ),
          _ => Center(
              child: CircularProgressIndicator(),
            ),
        };
      },
    );
  }
}
