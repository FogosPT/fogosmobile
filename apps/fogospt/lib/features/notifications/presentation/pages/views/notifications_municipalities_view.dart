import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fogospt/features/notifications/application/municipality_cubit/municipality_cubit.dart';
import 'package:fogospt/features/notifications/application/municipality_cubit/municipality_state.dart';
import 'package:fogospt/features/notifications/application/notifications_shared_preferences.dart';

class NotificationsMunicipalitiesView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MunicipalityCubit, MunicipalityState>(
      builder: (context, state) {
        if (state is MunicipalityStateLoaded) {
          final municipalities = state.municipalities;
          return ListView.builder(
            itemCount: municipalities.length,
            itemBuilder: (context, index) {
              final municipality = municipalities[index];
              return ListTile(
                trailing: Text(municipality.key),
                title: Text(municipality.value.name),
                subtitle: Text(municipality.value.districtName),
                leading: FutureBuilder(
                  future: MunicipalitiesSharedPreferences.getTopicNotifications(
                      municipality.key),
                  builder: (context, snapshot) {
                    return Checkbox(
                      value: snapshot.data ?? false,
                      onChanged: (bool? value) =>
                          MunicipalitiesSharedPreferences.setTopicNotifications(
                              municipality.key, value ?? false),
                    );
                  },
                ),
              );
            },
          );
        }
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
