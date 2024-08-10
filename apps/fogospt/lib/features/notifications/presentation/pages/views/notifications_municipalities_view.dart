import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fogospt/features/notifications/application/municipality_cubit/municipality_cubit.dart';
import 'package:fogospt/features/notifications/application/municipality_cubit/municipality_state.dart';

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
              return ListTile(
                trailing: Text(municipalities[index].key),
                title: Text(municipalities[index].value.name),
                subtitle: Text(municipalities[index].value.districtName),
                leading: Checkbox(
                  value: false,
                  onChanged: (bool? value) {
                    //
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
