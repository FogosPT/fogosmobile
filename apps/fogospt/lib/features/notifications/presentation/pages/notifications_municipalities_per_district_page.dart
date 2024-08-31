import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fogospt/features/notifications/application/district_selected_cubit/district_selected_cubit.dart';
import 'package:fogospt/features/notifications/application/district_selected_cubit/district_selected_state.dart';
import 'package:fogospt/features/notifications/application/municipality_cubit/municipality_cubit.dart';
import 'package:fogospt/features/notifications/application/municipality_cubit/municipality_state.dart';
import 'package:fogospt/features/notifications/application/notifications/notification_cubit.dart';
import 'package:fogospt/features/notifications/application/notifications/notification_state.dart';

class NotificationsMunicipalitiesPerDistrictPage extends StatelessWidget {
  const NotificationsMunicipalitiesPerDistrictPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MunicipalityCubit, MunicipalityState>(
      builder: (context, municipalityState) {
        if (municipalityState is MunicipalityStateLoaded) {
          return BlocBuilder<NotificationCubit, NotificationState>(
            builder: (context, state) {
              if (state is NotificationSuccessful) {
                final activeMunicipalities = state.activeMunicipalities;
                return BlocBuilder<DistrictSelectedCubit,
                    DistrictSelectedState>(
                  builder: (context, selectedDistrictState) {
                    if (selectedDistrictState is DistrictSelected) {
                      /// setup
                      final currentDistrict =
                          municipalityState.municipalitiesPerDistrict[
                                  selectedDistrictState.district] ??
                              [];

                      /// build
                      return Scaffold(
                        appBar: AppBar(
                          title: Text('${selectedDistrictState.district.name}'),
                        ),
                        body: ListView.builder(
                          itemCount: currentDistrict.length,
                          itemBuilder: (context, index) {
                            final municipality = currentDistrict[index];

                            return ListTile(
                              title: Text(municipality.value.name),
                              trailing: Checkbox(
                                value: activeMunicipalities
                                    ?.contains(municipality.key),
                                onChanged: (value) {
                                  if (value == null) return;
                                  final municipalityCubit =
                                      context.read<MunicipalityCubit>();
                                  context
                                      .read<NotificationCubit>()
                                      .toggleNotification(
                                        municipality: municipality,
                                        toggleValue: value,
                                        municipalityCubit: municipalityCubit,
                                      );
                                },
                              ),
                            );
                          },
                        ),
                      );
                    }
                    return Center(
                      child: CircularProgressIndicator(),
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
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
