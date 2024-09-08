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

/// Resources
/// - https://pub.dev/packages/go_router
/// - https://medium.com/@antonio.tioypedro1234/flutter-go-router-the-essential-guide-349ef39ec5b3

final appRouter = GoRouter(
  debugLogDiagnostics: true,
  routes: $appRoutes,
);

@TypedGoRoute<RootRoute>(
  path: '/',
  routes: [
    TypedGoRoute<FireDetailRoute>(
      path: 'fire-detail/:id',
    ),
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
  /// The fire ID
  final String id;

  const FireDetailRoute({required this.id});

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      FireDetailPage(fireId: id);
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
