// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_go_router.dart';

// **************************************************************************
// GoRouterGenerator
// **************************************************************************

List<RouteBase> get $appRoutes => [
      $rootRoute,
    ];

RouteBase get $rootRoute => GoRouteData.$route(
      path: '/',
      factory: $RootRouteExtension._fromState,
      routes: [
        GoRouteData.$route(
          path: 'fire-detail/:id',
          factory: $FireDetailRouteExtension._fromState,
        ),
        GoRouteData.$route(
          path: 'partners',
          factory: $PartnersRouteExtension._fromState,
        ),
        GoRouteData.$route(
          path: 'notifications_list_municipalities',
          factory: $NotificationsListMunicipalitiesRouteExtension._fromState,
        ),
        GoRouteData.$route(
          path: 'notifications_generic',
          factory: $NotificationsGenericRouteExtension._fromState,
        ),
        GoRouteData.$route(
          path: 'notifications_per_municipality',
          factory: $NotificationsPerMunicipalityRouteExtension._fromState,
        ),
      ],
    );

extension $RootRouteExtension on RootRoute {
  static RootRoute _fromState(GoRouterState state) => const RootRoute();

  String get location => GoRouteData.$location(
        '/',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $FireDetailRouteExtension on FireDetailRoute {
  static FireDetailRoute _fromState(GoRouterState state) => FireDetailRoute(
        id: state.pathParameters['id']!,
      );

  String get location => GoRouteData.$location(
        '/fire-detail/${Uri.encodeComponent(id)}',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $PartnersRouteExtension on PartnersRoute {
  static PartnersRoute _fromState(GoRouterState state) => const PartnersRoute();

  String get location => GoRouteData.$location(
        '/partners',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $NotificationsListMunicipalitiesRouteExtension
    on NotificationsListMunicipalitiesRoute {
  static NotificationsListMunicipalitiesRoute _fromState(GoRouterState state) =>
      const NotificationsListMunicipalitiesRoute();

  String get location => GoRouteData.$location(
        '/notifications_list_municipalities',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $NotificationsGenericRouteExtension on NotificationsGenericRoute {
  static NotificationsGenericRoute _fromState(GoRouterState state) =>
      const NotificationsGenericRoute();

  String get location => GoRouteData.$location(
        '/notifications_generic',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $NotificationsPerMunicipalityRouteExtension
    on NotificationsPerMunicipalityRoute {
  static NotificationsPerMunicipalityRoute _fromState(GoRouterState state) =>
      const NotificationsPerMunicipalityRoute();

  String get location => GoRouteData.$location(
        '/notifications_per_municipality',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}
