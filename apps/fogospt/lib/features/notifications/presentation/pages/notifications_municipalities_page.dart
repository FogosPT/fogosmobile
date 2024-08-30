import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fogospt/features/notifications/application/municipality_cubit/municipality_cubit.dart';
import 'package:fogospt/features/notifications/application/municipality_cubit/municipality_state.dart';
import 'package:fogospt/features/notifications/presentation/pages/notifications_municipalities_page_view.dart';

class NotificationsMunicipalitiesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MunicipalityCubit, MunicipalityState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text('Notificações por Concelho'),
          ),
          body: Center(
            child: switch (state) {
              MunicipalityStateInitial() => Center(
                  child: CircularProgressIndicator(),
                ),
              MunicipalityStateLoading() => Center(
                  child: CircularProgressIndicator(),
                ),
              MunicipalityStateLoaded() =>
                NotificationsMunicipalitiesPageView(),
              MunicipalityStateFailed() => Center(
                  child: Text('Failed to load Municipalities'),
                ),
            },
          ),
        );
      },
    );
  }
}
