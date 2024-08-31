import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fogospt/features/select_notifications/application/municipalities_cubit/municipalities_cubit.dart';
import 'package:fogospt/features/select_notifications/application/municipalities_cubit/municipalities_state.dart';
import 'package:fogospt/features/select_notifications/presentation/select_notifications_municipalities_page_view.dart';
import 'package:warnings/state_management/state.dart';
import 'package:warnings/utils/extensions/context_extensions.dart';

class SelectNotificationsMunicipalitiesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MunicipalitiesCubit, MunicipalitiesState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text(context.l10n.select_notifications_per_municipality),
          ),
          body: switch (state) {
            _ when state.isSuccess =>
              SelectNotificationsMunicipalitiesPageView(),
            _ when state.isFailure => Center(
                child: Text(
                    context.l10n.select_notifications_per_municipality_error),
              ),
            _ => Center(
                child: CircularProgressIndicator(),
              )
          },
        );
      },
    );
  }
}
