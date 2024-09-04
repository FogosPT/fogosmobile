base class AppBaseRoute {}

base class WarningCoreRoute extends AppBaseRoute {
  /// Corresponds to the path name of the route. Only visible in the codebase.
  final String navigationName;

  /// Route has all the steps needed to navigate to a specific page
  /// Prefix always with '/' and its the one visible to the user.
  final String path;

  WarningCoreRoute({
    required this.navigationName,
    required this.path,
  });
}
