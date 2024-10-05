import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:fogos_api/features/latest_warnings/data/fires_repository.dart';
import 'package:fogos_api/shared/dependency_injection.dart';
import 'package:fogospt/features/map/application/map_latest_warnings/map_latest_warning_marker_cubit.dart';
import 'package:fogospt/features/map/data/fires_latest_service.dart';
import 'package:fogospt/features/select_notifications/application/generic_selected_notifications_cubit/generic_selected_notifications_cubit.dart';
import 'package:fogospt/features/select_notifications/application/municipalities_cubit/municipalities_cubit.dart';
import 'package:fogospt/features/select_notifications/application/notifications_selected_district_cubit/notifications_selected_district_cubit.dart';
import 'package:fogospt/features/select_notifications/application/selected_notifications_cubit/selected_notifications_cubit.dart';
import 'package:fogospt/routing/app_go_router.dart';

class FogosApp extends StatelessWidget {
  const FogosApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              GenericSelectedNotificationsCubit()..fetchTopicsStatus(),
        ),
        BlocProvider(
          create: (context) => NotificationsSelectedDistrictCubit(),
        ),
        BlocProvider(
          create: (context) => MapLatestWarningMarkerCubit(
            FiresLatestService(
              getIt<FiresRepository>(),
            ),
          )..fetchLatestFires(),
        ),
        BlocProvider(
          create: (context) =>
              SelectedNotificationsCubit()..fetchNotifications(),
        ),
        BlocProvider(
          create: (context) => MunicipalitiesCubit()..loadMunicipalities(),
        ),
      ],
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        theme: FlexThemeData.light(scheme: FlexScheme.redM3),
        darkTheme: FlexThemeData.dark(scheme: FlexScheme.redWine),
        themeMode: ThemeMode.system,
        routerConfig: appRouter,
      ),
    );
  }
}
