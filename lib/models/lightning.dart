import 'dart:convert';

LightningRemote lightningFromJson(String str) => LightningRemote.fromJson(json.decode(str));

String lightningToJson(LightningRemote data) => json.encode(data.toJson());

class LightningRemote {
  LightningRemote({
    this.data,
  });

  List<Lightning> data;

  factory LightningRemote.fromJson(Map<String, dynamic> json) => LightningRemote(
        data: List<Lightning>.from(json["data"].map((x) => Lightning.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };

  static List<LightningRemote> fromList(List<dynamic> obj) {
    if (obj == null) {
      return [];
    }
    return obj
        .cast<Map<String, dynamic>>()
        .map((data) => LightningRemote.fromJson(data))
        .toList();
  }
}

class Lightning {
  Lightning({
    this.timestamp,
    this.payload,
  });

  String timestamp;
  LightningData payload;

  factory Lightning.fromJson(Map<String, dynamic> json) => Lightning(
        timestamp: json["timestamp"],
        payload: LightningData.fromJson(json["payload"]),
      );

  Map<String, dynamic> toJson() => {
        "timestamp": timestamp,
        "payload": payload.toJson(),
      };
}

class LightningData {
  LightningData({
    this.latitude,
    this.amplitude,
    this.longitude,
  });

  double latitude;
  double amplitude;
  double longitude;

  factory LightningData.fromJson(Map<String, dynamic> json) => LightningData(
        latitude: json["latitude"].toDouble(),
        amplitude: json["amplitude"].toDouble(),
        longitude: json["longitude"].toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "latitude": latitude,
        "amplitude": amplitude,
        "longitude": longitude,
      };
}
