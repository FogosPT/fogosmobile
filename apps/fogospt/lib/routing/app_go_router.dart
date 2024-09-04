import 'package:flutter/material.dart';
import 'package:fogospt/constants/assets.dart';
import 'package:fogospt/features/fires/presentation/pages/fire_detail_page.dart';
import 'package:fogospt/features/map/presentation/pages/fires_map_page.dart';
import 'package:fogospt/features/partners/presentation/partners_page.dart';
import 'package:fogospt/features/select_notifications/presentation/select_notifications_generic_page.dart';
import 'package:fogospt/features/select_notifications/presentation/select_notifications_municipalities_page.dart';
import 'package:fogospt/features/select_notifications/presentation/select_notifications_municipalities_per_district_page.dart';
import 'package:go_router/go_router.dart';
import 'package:warnings_core/warnings_core.dart';

class AppRoutes {
  static final String root = _AppRouting.root.navigationName;
  static final String fireDetail = _AppRouting.fireDetail.navigationName;

  static final String about = _AppRouting.about.navigationName;

  static final String partners = _AppRouting.partners.navigationName;

  static final String notifications_per_municipality =
      _AppRouting.notifications_per_municipality.navigationName;

  static final String notifications_list_municipalities =
      _AppRouting.notifications_list_municipalities.navigationName;

  static final String notifications_generic =
      _AppRouting.notifications_generic.navigationName;
}

class _AppRouting {
  static final WarningCoreRoute root = WarningCoreRoute(
    navigationName: "root",
    path: "/",
  );

  static final WarningCoreRoute fireDetail = WarningCoreRoute(
    navigationName: '/fire-detail',
    path: 'fire-detail',
  );

  static final WarningCoreRoute about = WarningCoreRoute(
    navigationName: '/about',
    path: 'about',
  );

  static final WarningCoreRoute partners = WarningCoreRoute(
    navigationName: '/partners',
    path: 'partners',
  );

  static final WarningCoreRoute notifications_list_municipalities =
      WarningCoreRoute(
    navigationName: '/notifications_list_municipalities',
    path: 'notifications_list_municipalities',
  );

  static final WarningCoreRoute notifications_generic = WarningCoreRoute(
    navigationName: '/notifications_generic',
    path: 'notifications_generic',
  );

  static final WarningCoreRoute notifications_per_municipality =
      WarningCoreRoute(
    navigationName: '/notifications_per_municipality',
    path: 'notifications_per_municipality',
  );
}

final app_go_router = GoRouter(
  routes: [
    GoRoute(
      // path: _AppRouting.root.route,
      path: '/',
      builder: (context, state) => FiresMapPage(),
      routes: [
        GoRoute(
          path: _AppRouting.fireDetail.path,
          builder: (context, state) {
            if (state.extra is! String) {
              throw Exception('Invalid fire id');
            }

            final fireId = state.extra as String;
            return FireDetailPage(fireId: fireId);
          },
        ),
        GoRoute(
          path: _AppRouting.about.path,
          builder: (context, state) {
            return Scaffold(
              appBar: AppBar(
                title: const Text('About'),
              ),
              body: const Center(
                child: Text('About'),
              ),
            );
          },
        ),
        GoRoute(
          path: _AppRouting.partners.path,
          builder: (context, state) {
            return PartnersPage(
              partners: [
                partnerMapbox,
                partnerOfficelan,
                partnerFundacaoLapalobo,
              ],
            );
          },
        ),
        GoRoute(
          path: _AppRouting.notifications_list_municipalities.path,
          builder: (context, state) => SelectNotificationsMunicipalitiesPage(),
          routes: [
            GoRoute(
              path: _AppRouting.notifications_per_municipality.path,
              builder: (context, state) =>
                  NotificationsMunicipalitiesPerDistrictPage(),
            )
          ],
        ),
        GoRoute(
          path: _AppRouting.notifications_generic.path,
          builder: (context, state) {
            return SelectNotificationsGeneralPage();
          },
        )
      ],
    ),
  ],
);
