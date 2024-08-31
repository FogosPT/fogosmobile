import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:fogos_api/features/latest_warnings/data/fires_repository.dart';
import 'package:fogos_api/shared/dependency_injection.dart';
import 'package:fogospt/features/map/application/map_latest_fires/map_latest_fires_cubit.dart';
import 'package:fogospt/features/map/data/fires_latest_service.dart';
import 'package:fogospt/features/select_notifications/application/municipalities_cubit/municipalities_cubit.dart';
import 'package:fogospt/features/select_notifications/application/notifications_selected_district_cubit/notifications_selected_district_cubit.dart';
import 'package:fogospt/features/select_notifications/application/selected_notifications_cubit/selected_notifications_cubit.dart';
import 'package:fogospt/routing/fogos_router.dart';
import 'package:responsive_framework/responsive_framework.dart';

class FogosApp extends StatefulWidget {
  const FogosApp({super.key});

  @override
  State<FogosApp> createState() => _FogosAppState();
}

class _FogosAppState extends State<FogosApp> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => NotificationsSelectedDistrictCubit(),
        ),
        BlocProvider(
          create: (context) => MapLatestFiresCubit(
            FiresLatestService(
              getIt<FiresRepository>(),
            ),
          ),
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
        routerConfig: fogos_router,
        debugShowCheckedModeBanner: false,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        builder: (context, child) {
          return ResponsiveBreakpoints.builder(
            child: child!,
            breakpoints: [
              const Breakpoint(start: 0, end: 450, name: MOBILE),
              const Breakpoint(start: 451, end: 800, name: TABLET),
              const Breakpoint(start: 801, end: 1920, name: DESKTOP),
              const Breakpoint(start: 1921, end: double.infinity, name: '4K'),
            ],
          );
        },
      ),
    );
  }
}
