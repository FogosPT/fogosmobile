class Endpoints {
  static const String fogosBaseApi = "https://api-lb.fogos.pt";
  static const String getFires = "$fogosBaseApi/new/fires";
  static const String getFire = "$fogosBaseApi/fires?id=";
  static const String getWarnings = "$fogosBaseApi/v1/warnings";
  static const String getLocations = "https://fogos.pt/js/dico.json";
  static const String getMobileContributors = "https://fogos.pt/v1/mobile-contributors";
}
