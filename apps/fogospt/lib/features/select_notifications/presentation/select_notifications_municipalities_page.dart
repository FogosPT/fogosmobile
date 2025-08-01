import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fogospt/features/select_notifications/application/municipalities_cubit/municipalities_cubit.dart';
import 'package:fogospt/features/select_notifications/application/municipalities_cubit/municipalities_state.dart';
import 'package:fogospt/features/select_notifications/presentation/select_notifications_municipalities_page_view.dart';
import 'package:fogospt/utils/extentions/build_context.dart';
import 'package:warnings/warnings.dart';

class SelectNotificationsMunicipalitiesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MunicipalitiesCubit, MunicipalitiesState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title:
                Text(context.l10n_fogos.select_notifications_per_municipality),
                
          ),
          body: StateWidget.simpleWithCustomFailure(
            state,
            child: SelectNotificationsMunicipalitiesPageView(),
            errorWidget: Center(
              child: Text(
                  context
                  .l10n_fogos.select_notifications_per_municipality_error),
            ),
          ),
        );
      },
    );
  }
}
