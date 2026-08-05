abstract class Endpoints {
  Endpoints._();

  static const String fogosBaseApi = "https://source.fogos.pt";
  static const String getFires = "$fogosBaseApi/new/fires";
  static const String getFire = "$fogosBaseApi/fires?id=";
  static const String getFireMeansHistory = "$fogosBaseApi/fires/data?id=";
  static const String getFireDetailsHistory = "$fogosBaseApi/fires/status?id=";
  static const String getFireRisk = "$fogosBaseApi/fires/danger?id=";
  static const String getWarnings = "$fogosBaseApi/v1/warnings";
  static const String getWarningsMadeira = "$fogosBaseApi/v1/madeira/warnings";
  static const String getLocations = "https://fogos.pt/js/dico.json";
  static const String getYesterdayStats = "$fogosBaseApi/v1/stats/8hours/yesterday";
  static const String getTodayStats = "$fogosBaseApi/v1/stats/8hours";
  static const String getLastNightStats = "$fogosBaseApi/v1/stats/last-night";
  static const String getNowStats = "$fogosBaseApi/v1/now";
  static const String getWeekStats = "$fogosBaseApi/v1/stats/week";
  static const String getLastHoursStats = "$fogosBaseApi/v1/now/data";
  static const String getMobileContributors = "https://fogos.pt/v1/mobile-contributors";
  static const String getModis = "https://fogos.pt/v1/modis";
  static const String getViirs = "https://fogos.pt/v1/viirs";
  static const String getLightnings = "https://fogos.pt/lightnings";
  static const String getIpmaReferenceTime = "https://fogos.pt/v1/ipma-reference-time";

  static String getIpmaPoint(double lat, double lng) =>
      "https://fogos.pt/v1/ipma-point/$lat/$lng";

  static String incidentPhotoUploadUrl(String fireId) =>
      "$fogosBaseApi/v2/incidents/$fireId/photos";

  static String incidentPhotosListUrl(String fireId,
          {int page = 1, int perPage = 20}) =>
      "$fogosBaseApi/v2/incidents/$fireId/photos?page=$page&per_page=$perPage";

  static String getRecentPlanes({int hours = 6}) =>
      "$fogosBaseApi/v2/planes/recent?hours=$hours";

  static String liveActivityRegisterUrl(String fireId) =>
      "$fogosBaseApi/v2/incidents/$fireId/live-activity/register";

  static String liveActivityUnregisterUrl(String fireId) =>
      "$fogosBaseApi/v2/incidents/$fireId/live-activity/unregister";
}
