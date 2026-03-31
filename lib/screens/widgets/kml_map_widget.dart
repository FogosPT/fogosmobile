import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fogosmobile/constants/variables.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

class KmlMapWidget extends StatefulWidget {
  final String kmlContent;

  const KmlMapWidget({super.key, required this.kmlContent});

  @override
  State<KmlMapWidget> createState() => _KmlMapWidgetState();
}

class _KmlMapWidgetState extends State<KmlMapWidget> {
  MapboxMap? _map;
  late final Map<String, dynamic>? _geoJson;
  late final CameraOptions _initialCamera;

  @override
  void initState() {
    super.initState();
    _geoJson = _parseKml(widget.kmlContent);
    _initialCamera = _cameraFromGeoJson(_geoJson);
  }

  void _onMapCreated(MapboxMap map) {
    _map = map;
    map.compass.updateSettings(CompassSettings(enabled: false));
    map.scaleBar.updateSettings(ScaleBarSettings(enabled: false));
    map.attribution.updateSettings(AttributionSettings(enabled: false));
    map.logo.updateSettings(LogoSettings(enabled: false));
  }

  void _onStyleLoaded(StyleLoadedEventData _) async {
    if (_geoJson == null || _map == null) return;

    await _map!.style.addSource(GeoJsonSource(
      id: 'kml',
      data: jsonEncode(_geoJson),
    ));

    await _map!.style.addLayer(FillLayer(
      id: 'kml-fill',
      sourceId: 'kml',
      fillColor: 0x33F25C54,
      fillOutlineColor: 0xFFF25C54,
    ));

    await _map!.style.addLayer(LineLayer(
      id: 'kml-line',
      sourceId: 'kml',
      lineColor: 0xFFF25C54,
      lineWidth: 2.0,
    ));

    await _fitCamera();
  }

  Future<void> _fitCamera() async {
    if (_geoJson == null || _map == null) return;

    double minLng = 180, maxLng = -180, minLat = 90, maxLat = -90;
    for (final feature in _geoJson!['features']) {
      for (final c in _flatCoords(feature['geometry'])) {
        if (c[0] < minLng) minLng = c[0];
        if (c[0] > maxLng) maxLng = c[0];
        if (c[1] < minLat) minLat = c[1];
        if (c[1] > maxLat) maxLat = c[1];
      }
    }

    try {
      final camera = await _map!.cameraForCoordinateBounds(
        CoordinateBounds(
          southwest: Point(coordinates: Position(minLng, minLat)),
          northeast: Point(coordinates: Position(maxLng, maxLat)),
          infiniteBounds: false,
        ),
        MbxEdgeInsets(top: 40, left: 40, bottom: 40, right: 40),
        null,
        null,
        null,
        null,
      );
      await _map!.setCamera(camera);
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    if (_geoJson == null) return const SizedBox.shrink();

    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: SizedBox(
        height: 220,
        child: MapWidget(
          styleUri: MAPBOX_TEMPLATE_STYLE,
          onMapCreated: _onMapCreated,
          onStyleLoadedListener: _onStyleLoaded,
          cameraOptions: _initialCamera,
        ),
      ),
    );
  }

  // ── KML parsing ────────────────────────────────────────────────────────────

  CameraOptions _cameraFromGeoJson(Map<String, dynamic>? geoJson) {
    if (geoJson == null) {
      return CameraOptions(
        center: Point(coordinates: Position(-8.09, 39.81)),
        zoom: 7.0,
      );
    }
    double minLng = 180, maxLng = -180, minLat = 90, maxLat = -90;
    for (final feature in geoJson['features']) {
      for (final c in _flatCoords(feature['geometry'])) {
        if (c[0] < minLng) minLng = c[0];
        if (c[0] > maxLng) maxLng = c[0];
        if (c[1] < minLat) minLat = c[1];
        if (c[1] > maxLat) maxLat = c[1];
      }
    }
    return CameraOptions(
      center: Point(coordinates: Position((minLng + maxLng) / 2, (minLat + maxLat) / 2)),
      zoom: 12.0,
    );
  }

  Map<String, dynamic>? _parseKml(String kml) {
    final features = <Map<String, dynamic>>[];

    final placemarkRegex = RegExp(
      r'<Placemark[^>]*>([\s\S]*?)</Placemark>',
      caseSensitive: false,
    );

    for (final pm in placemarkRegex.allMatches(kml)) {
      final block = pm.group(1)!;

      final outerRegex = RegExp(
        r'<outerBoundaryIs>[\s\S]*?<coordinates>([\s\S]*?)</coordinates>',
        caseSensitive: false,
      );
      final outerMatch = outerRegex.firstMatch(block);
      if (outerMatch != null) {
        final ring = _parseCoords(outerMatch.group(1)!);
        if (ring.length >= 3) {
          final innerRings = <List<List<double>>>[];
          final innerRegex = RegExp(
            r'<innerBoundaryIs>[\s\S]*?<coordinates>([\s\S]*?)</coordinates>',
            caseSensitive: false,
          );
          for (final inner in innerRegex.allMatches(block)) {
            final hole = _parseCoords(inner.group(1)!);
            if (hole.length >= 3) innerRings.add(hole);
          }
          features.add({
            'type': 'Feature',
            'geometry': {'type': 'Polygon', 'coordinates': [ring, ...innerRings]},
            'properties': {},
          });
        }
        continue;
      }

      final lineRegex = RegExp(
        r'<LineString>[\s\S]*?<coordinates>([\s\S]*?)</coordinates>',
        caseSensitive: false,
      );
      for (final lm in lineRegex.allMatches(block)) {
        final coords = _parseCoords(lm.group(1)!);
        if (coords.length >= 2) {
          features.add({
            'type': 'Feature',
            'geometry': {'type': 'LineString', 'coordinates': coords},
            'properties': {},
          });
        }
      }
    }

    if (features.isEmpty) return null;
    return {'type': 'FeatureCollection', 'features': features};
  }

  List<List<double>> _parseCoords(String raw) {
    final result = <List<double>>[];
    for (final token in raw.trim().split(RegExp(r'\s+'))) {
      final parts = token.split(',');
      if (parts.length < 2) continue;
      final lng = double.tryParse(parts[0]);
      final lat = double.tryParse(parts[1]);
      if (lng != null && lat != null) result.add([lng, lat]);
    }
    return result;
  }

  List<List<double>> _flatCoords(Map<String, dynamic> geometry) {
    final type = geometry['type'];
    final coords = geometry['coordinates'];
    if (type == 'LineString') return List<List<double>>.from(coords.map((c) => List<double>.from(c)));
    if (type == 'Polygon') return List<List<double>>.from((coords[0] as List).map((c) => List<double>.from(c)));
    return [];
  }
}
