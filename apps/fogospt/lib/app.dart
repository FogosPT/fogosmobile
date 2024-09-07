import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:fogos_api/features/latest_warnings/data/fires_repository.dart';
import 'package:fogos_api/shared/dependency_injection.dart';
import 'package:fogospt/features/map/application/map_latest_fires/map_latest_fires_cubit.dart';
import 'package:fogospt/features/map/data/fires_latest_service.dart';
import 'package:fogospt/features/select_notifications/application/municipalities_cubit/municipalities_cubit.dart';
import 'package:fogospt/features/select_notifications/application/notifications_selected_district_cubit/notifications_selected_district_cubit.dart';
import 'package:fogospt/features/select_notifications/application/selected_notifications_cubit/selected_notifications_cubit.dart';

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
        debugShowCheckedModeBanner: false,
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: [
          Locale('en'), // English
          Locale('es'), // Spanish
        ],
        theme: FlexThemeData.light(scheme: FlexScheme.redM3),
        darkTheme: FlexThemeData.dark(scheme: FlexScheme.redM3),
        themeMode: ThemeMode.system,
      ),
    );
  }
}
