import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fogospt/features/notifications/application/municipality_cubit/municipality_cubit.dart';
import 'package:fogospt/features/notifications/application/municipality_cubit/municipality_state.dart';
import 'package:fogospt/features/notifications/application/notifications/notification_cubit.dart';
import 'package:fogospt/features/notifications/application/notifications/notification_state.dart';

class NotificationsMunicipalitiesView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotificationCubit, NotificationState>(
      builder: (context, notificationState) {
        return switch (notificationState) {
          NotificationSuccessful() =>
            BlocBuilder<MunicipalityCubit, MunicipalityState>(
              builder: (context, state) {
                if (state is MunicipalityStateLoaded) {
                  final municipalities = state.municipalitiesPerDistrict;

                  /// TODO(FB): Map Municipalities to a PageView List or something
                  // return ListView.builder(
                  //   itemCount: municipalities.length,
                  //   itemBuilder: (context, index) {
                  //     final municipality = municipalities[index];
                  //     return ListTile(
                  //       trailing: Text(municipality),
                  //       title: Text(municipality.value.name),
                  //       subtitle: Text(municipality.value.districtName),
                  //       leading: FutureBuilder(
                  //         future: MunicipalitiesSharedPreferences.getTopicNotifications(
                  //             municipality.key),
                  //         builder: (context, snapshot) {
                  //           return Checkbox(
                  //             value: snapshot.data ?? false,
                  //             onChanged: (bool? value) =>
                  //                 MunicipalitiesSharedPreferences.setTopicNotifications(
                  //                     municipality.key, value ?? false),
                  //           );
                  //         },
                  //       ),
                  //     );
                  //   },
                  // );

                  return Container();
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
