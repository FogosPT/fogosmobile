// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_go_router.dart';

// **************************************************************************
// GoRouterGenerator
// **************************************************************************

List<RouteBase> get $appRoutes => [$rootRoute];

RouteBase get $rootRoute => GoRouteData.$route(
  path: '/',

  factory: _$RootRoute._fromState,
  routes: [
    GoRouteData.$route(
      path: 'fire-detail/:id',

      factory: _$FireDetailRoute._fromState,
    ),
    GoRouteData.$route(path: 'partners', factory: _$PartnersRoute._fromState),
    GoRouteData.$route(
      path: 'notifications_list_municipalities',

      factory: _$NotificationsListMunicipalitiesRoute._fromState,
    ),
    GoRouteData.$route(
      path: 'notifications_generic',

      factory: _$NotificationsGenericRoute._fromState,
    ),
    GoRouteData.$route(
      path: 'notifications_per_municipality',

      factory: _$NotificationsPerMunicipalityRoute._fromState,
    ),
  ],
);

mixin _$RootRoute on GoRouteData {
  static RootRoute _fromState(GoRouterState state) => const RootRoute();

  @override
  String get location => GoRouteData.$location('/');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin _$FireDetailRoute on GoRouteData {
  static FireDetailRoute _fromState(GoRouterState state) =>
      FireDetailRoute(id: state.pathParameters['id']!);

  FireDetailRoute get _self => this as FireDetailRoute;

  @override
  String get location =>
      GoRouteData.$location('/fire-detail/${Uri.encodeComponent(_self.id)}');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin _$PartnersRoute on GoRouteData {
  static PartnersRoute _fromState(GoRouterState state) => const PartnersRoute();

  @override
  String get location => GoRouteData.$location('/partners');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin _$NotificationsListMunicipalitiesRoute on GoRouteData {
  static NotificationsListMunicipalitiesRoute _fromState(GoRouterState state) =>
      const NotificationsListMunicipalitiesRoute();

  @override
  String get location =>
      GoRouteData.$location('/notifications_list_municipalities');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin _$NotificationsGenericRoute on GoRouteData {
  static NotificationsGenericRoute _fromState(GoRouterState state) =>
      const NotificationsGenericRoute();

  @override
  String get location => GoRouteData.$location('/notifications_generic');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin _$NotificationsPerMunicipalityRoute on GoRouteData {
  static NotificationsPerMunicipalityRoute _fromState(GoRouterState state) =>
      const NotificationsPerMunicipalityRoute();

  @override
  String get location =>
      GoRouteData.$location('/notifications_per_municipality');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}
