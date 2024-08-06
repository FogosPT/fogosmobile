class Env {
  static String get mapboxAccessToken =>
      const String.fromEnvironment('MAPBOX_ACCESS_TOKEN');
  static String get mapboxAccessId =>
      const String.fromEnvironment('MAPBOX_ACCESS_ID');
}
