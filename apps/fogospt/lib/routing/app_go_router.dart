import 'package:flutter/material.dart';
import 'package:fogospt/constants/assets.dart';
import 'package:fogospt/features/fires/presentation/pages/fire_detail_page.dart';
import 'package:fogospt/features/map/presentation/pages/fires_map_page.dart';
import 'package:fogospt/features/partners/presentation/partners_page.dart';
import 'package:fogospt/features/select_notifications/presentation/select_notifications_generic_page.dart';
import 'package:fogospt/features/select_notifications/presentation/select_notifications_municipalities_page.dart';
import 'package:fogospt/features/select_notifications/presentation/select_notifications_municipalities_per_district_page.dart';
import 'package:go_router/go_router.dart';

part 'app_go_router.g.dart';

// class AppRoutes {
//   static final String root = _AppRouting.root.navigationName;
//   static final String fireDetail = _AppRouting.fireDetail.navigationName;

//   static final String about = _AppRouting.about.navigationName;

//   static final String partners = _AppRouting.partners.navigationName;

//   static final String notifications_per_municipality =
//       _AppRouting.notifications_per_municipality.navigationName;

//   static final String notifications_list_municipalities =
//       _AppRouting.notifications_list_municipalities.navigationName;

//   static final String notifications_generic =
//       _AppRouting.notifications_generic.navigationName;
// }

// @TypedGoRoute<HomeScreenRoute>(
//   path: '/',
//   routes: [
//     TypedGoRoute<SongRoute>(
//       path: 'song/:id',
//     )
//   ],
// )

//==============================================================================
// Long comment divider
//==============================================================================

@TypedGoRoute<RootRoute>(
  path: '/',
  routes: [
    TypedGoRoute<FireDetailRoute>(
      path: 'fire-detail',
    ),
    // TypedGoRoute<AboutRoute>(
    //   path: 'about',
    // ),
    TypedGoRoute<PartnersRoute>(
      path: 'partners',
    ),
    TypedGoRoute<NotificationsListMunicipalitiesRoute>(
      path: 'notifications_list_municipalities',
    ),
    TypedGoRoute<NotificationsGenericRoute>(
      path: 'notifications_generic',
    ),
    TypedGoRoute<NotificationsPerMunicipalityRoute>(
      path: 'notifications_per_municipality',
    ),
  ],
)
class RootRoute extends GoRouteData {
  const RootRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) => FiresMapPage();
}

@immutable
class FireDetailRoute extends GoRouteData {
  final String fireId;
  const FireDetailRoute({
    required this.fireId,
  });

  @override
  Widget build(BuildContext context, GoRouterState state) {
    if (state.extra == null || state.extra is! String) {
      throw Exception('Invalid fire ID');
    } else {
      String fireId = state.extra as String;
      return FireDetailPage(
        fireId: fireId,
      );
    }
  }
}

@immutable
class PartnersRoute extends GoRouteData {
  const PartnersRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) => PartnersPage(
        partners: [
          partnerMapbox,
          partnerOfficelan,
          partnerFundacaoLapalobo,
        ],
      );
}

@immutable
class NotificationsListMunicipalitiesRoute extends GoRouteData {
  const NotificationsListMunicipalitiesRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      SelectNotificationsMunicipalitiesPage();
}

@immutable
class NotificationsGenericRoute extends GoRouteData {
  const NotificationsGenericRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      SelectNotificationsGenericPage();
}

@immutable
class NotificationsPerMunicipalityRoute extends GoRouteData {
  const NotificationsPerMunicipalityRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      SelectNotificationsMunicipalitiesPerDistrictPage();
}
