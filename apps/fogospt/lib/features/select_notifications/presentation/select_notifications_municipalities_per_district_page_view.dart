import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fogospt/features/select_notifications/application/municipalities_cubit/municipalities_cubit.dart';
import 'package:fogospt/features/select_notifications/application/selected_notifications_cubit/selected_notifications_cubit.dart';
import 'package:fogospt/features/select_notifications/domain/municipality_data.dart';

class NotificationsMunicipalitiesPerDistrictPageView extends StatelessWidget {
  const NotificationsMunicipalitiesPerDistrictPageView({
    required this.currentDistrict,
    required this.activeMunicipalities,
    required this.districtName,
  });

  final List<MunicipalityValue> currentDistrict;
  final Set<String> activeMunicipalities;
  final String districtName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(districtName),
      ),
      body: ListView.builder(
        itemCount: currentDistrict.length,
        itemBuilder: (context, index) {
          final municipality = currentDistrict[index];

          return SwitchListTile(
            title: Text(municipality.value.name),
            value: activeMunicipalities.contains(municipality.key),
            onChanged: (value) {
              final municipalityCubit = context.read<MunicipalitiesCubit>();
              final notificationCubit =
                  context.read<SelectedNotificationsCubit>();
              notificationCubit.toggleNotification(
                municipality: municipality,
                toggleValue: value,
                municipalityCubit: municipalityCubit,
              );
            },
          );
        },
      ),
    );
  }
}
