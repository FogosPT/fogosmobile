import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

class PlanePosition {
  final double lat;
  final double lon;
  final int? altitude;
  final int? groundSpeed;
  final int? track;
  final bool onGround;
  final DateTime? sampledAt;
  final DateTime? created;

  PlanePosition({
    required this.lat,
    required this.lon,
    this.altitude,
    this.groundSpeed,
    this.track,
    this.onGround = false,
    this.sampledAt,
    this.created,
  });

  factory PlanePosition.fromJson(Map<String, dynamic> j) {
    return PlanePosition(
      lat: (j['lat'] as num).toDouble(),
      lon: (j['lon'] as num).toDouble(),
      altitude: (j['altitude'] as num?)?.toInt(),
      groundSpeed: (j['ground_speed'] as num?)?.toInt(),
      track: (j['track'] as num?)?.toInt(),
      onGround: j['on_ground'] == true,
      sampledAt: j['sampled_at'] != null
          ? DateTime.tryParse(j['sampled_at'] as String)
          : null,
      created: j['created'] != null
          ? DateTime.tryParse(j['created'] as String)
          : null,
    );
  }
}

class Plane {
  final String icao;
  final String? registration;
  final String? name;
  final String? aircraftType;
  final String kind;
  final String? base;
  final String? operator_;
  final List<PlanePosition> positions;

  Plane({
    required this.icao,
    this.registration,
    this.name,
    this.aircraftType,
    this.kind = 'airplane',
    this.base,
    this.operator_,
    this.positions = const [],
  });

  PlanePosition? get lastPosition =>
      positions.isEmpty ? null : positions.last;

  bool get isHelicopter => kind == 'helicopter';

  bool get isFlying {
    final last = lastPosition;
    final ts = last?.created ?? last?.sampledAt;
    if (ts == null) return false;
    return DateTime.now().toUtc().difference(ts.toUtc()) <=
        const Duration(minutes: 10);
  }

  Point? get lastPoint {
    final last = lastPosition;
    if (last == null) return null;
    return Point(coordinates: Position(last.lon, last.lat));
  }

  factory Plane.fromJson(Map<String, dynamic> j) {
    final rawPositions = (j['positions'] as List?) ?? const [];
    return Plane(
      // The upstream feed occasionally returns entries with `icao: null`
      // for aircraft that haven't been resolved yet. Treat them as
      // unknown rather than throwing — the middleware's positions filter
      // drops them anyway, but a single throw here used to poison the
      // whole map() and left the map empty.
      icao: (j['icao'] as String?) ?? '',
      registration: j['registration'] as String?,
      name: j['name'] as String?,
      aircraftType: j['aircraft_type'] as String?,
      kind: (j['kind'] as String?) ?? 'airplane',
      base: j['base'] as String?,
      operator_: j['operator'] as String?,
      positions: rawPositions
          .map((p) => PlanePosition.fromJson(p as Map<String, dynamic>))
          .toList(),
    );
  }
}
