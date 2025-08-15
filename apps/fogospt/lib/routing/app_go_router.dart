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
    TypedGoRoute<FireDetailRoute>(path: 'fire-detail/:id'),
    TypedGoRoute<PartnersRoute>(path: 'partners'),
    TypedGoRoute<NotificationsListMunicipalitiesRoute>(
      path: 'notifications_list_municipalities',
    ),
    TypedGoRoute<NotificationsGenericRoute>(path: 'notifications_generic'),
    TypedGoRoute<NotificationsPerMunicipalityRoute>(
      path: 'notifications_per_municipality',
    ),
    TypedGoRoute<FiresMapPageFireListRoute>(path: 'fire-list'),
    TypedGoRoute<FiresMapPageWarningsRoute>(path: 'warnings'),
    TypedGoRoute<FiresMapPageWarningsMadeiraRoute>(path: 'warnings-madeira'),
    TypedGoRoute<FiresMapPageInformationsRoute>(path: 'informations'),
    TypedGoRoute<FiresMapPageStatisticsRoute>(path: 'statistics'),
    TypedGoRoute<FiresMapPageErrorRoute>(path: 'error'),
    TypedGoRoute<FiresMapPageAboutRoute>(path: 'about'),
    TypedGoRoute<FiresMapPagePartnersRoute>(path: 'partners-list'),
  ],
)
class RootRoute extends GoRouteData with _$RootRoute {
  const RootRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) => FiresMapPage();
}

@immutable
class FireDetailRoute extends GoRouteData with _$FireDetailRoute {
  /// The fire ID
  final String id;

  const FireDetailRoute({required this.id});

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      FireDetailPage(fireId: id);
}

@immutable
class PartnersRoute extends GoRouteData with _$PartnersRoute {
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
class NotificationsListMunicipalitiesRoute extends GoRouteData
    with _$NotificationsListMunicipalitiesRoute {
  const NotificationsListMunicipalitiesRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      SelectNotificationsMunicipalitiesPage();
}

@immutable
class NotificationsGenericRoute extends GoRouteData
    with _$NotificationsGenericRoute {
  const NotificationsGenericRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      SelectNotificationsGenericPage();
}

@immutable
class NotificationsPerMunicipalityRoute extends GoRouteData
    with _$NotificationsPerMunicipalityRoute {
  const NotificationsPerMunicipalityRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      SelectNotificationsMunicipalitiesPerDistrictPage();
}


@immutable
class FiresMapPageFireListRoute extends GoRouteData
    with _$FiresMapPageFireListRoute {
  const FiresMapPageFireListRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    // TODO: Implement the corresponding page
    return Scaffold(
      appBar: AppBar(title: Text("Lista de Incêndios")),
      body: Center(child: Text("Lista de Incêndios")),
    );
  }
}

@immutable
class FiresMapPageWarningsRoute extends GoRouteData
    with _$FiresMapPageWarningsRoute {
  const FiresMapPageWarningsRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    // TODO: Implement the corresponding page
    return Scaffold(
      appBar: AppBar(title: Text("Avisos")),
      body: Center(child: Text("Avisos")),
    );
  }
}

@immutable
class FiresMapPageWarningsMadeiraRoute extends GoRouteData
    with _$FiresMapPageWarningsMadeiraRoute {
  const FiresMapPageWarningsMadeiraRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    // TODO: Implement the corresponding page
    return Scaffold(
      appBar: AppBar(title: Text("Avisos Madeira")),
      body: Center(child: Text("Avisos Madeira")),
    );
  }
}

@immutable
class FiresMapPageInformationsRoute extends GoRouteData
    with _$FiresMapPageInformationsRoute {
  const FiresMapPageInformationsRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    // TODO: Implement the corresponding page
    return Scaffold(
      appBar: AppBar(title: Text("Informações")),
      body: Center(child: Text("Informações")),
    );
  }
}

@immutable
class FiresMapPageStatisticsRoute extends GoRouteData
    with _$FiresMapPageStatisticsRoute {
  const FiresMapPageStatisticsRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    // TODO: Implement the corresponding page
    return Scaffold(
      appBar: AppBar(title: Text("Estatísticas")),
      body: Center(child: Text("Estatísticas")),
    );
  }
}

@immutable
class FiresMapPageErrorRoute extends GoRouteData with _$FiresMapPageErrorRoute {
  const FiresMapPageErrorRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    // TODO: Implement the corresponding page
    return Scaffold(
      appBar: AppBar(title: Text("Erro ao carregar mapa")),
      body: Center(child: Text("Erro ao carregar mapa")),
    );
  }
}

@immutable
class FiresMapPageAboutRoute extends GoRouteData with _$FiresMapPageAboutRoute {
  const FiresMapPageAboutRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    // TODO: Implement the corresponding page
    return Scaffold(
      appBar: AppBar(title: Text("Sobre")),
      body: Center(child: Text("Sobre a aplicação")),
    );
  }
}

@immutable
class FiresMapPagePartnersRoute extends GoRouteData
    with _$FiresMapPagePartnersRoute {
  const FiresMapPagePartnersRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    // TODO: Implement the corresponding page
    return Scaffold(
      appBar: AppBar(title: Text("Parceiros")),
      body: Center(child: Text("Lista de Parceiros")),
    );
  }
}
