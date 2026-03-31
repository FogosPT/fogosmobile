import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

class KmlLayerManager {
  final MapboxMap mapboxMap;
  final String id;

  late final String _sourceId;
  late final String _fillLayerId;
  late final String _lineLayerId;

  String? _current;

  KmlLayerManager({required this.mapboxMap, this.id = 'vost'}) {
    _sourceId = 'kml-$id-source';
    _fillLayerId = 'kml-$id-fill';
    _lineLayerId = 'kml-$id-line';
  }

  Future<void> show(String kmlOrUrl) async {
    if (kmlOrUrl == _current) return;
    await clear();
    _current = kmlOrUrl;

    try {
      final String kml;
      if (kmlOrUrl.startsWith('http')) {
        final response = await http.get(Uri.parse(kmlOrUrl));
        if (response.statusCode != 200) return;
        kml = response.body;
      } else {
        kml = kmlOrUrl;
      }

      final geoJson = _kmlToGeoJson(kml);
      if (geoJson == null) return;

      await mapboxMap.style.addSource(GeoJsonSource(
        id: _sourceId,
        data: jsonEncode(geoJson),
      ));

      await mapboxMap.style.addLayer(FillLayer(
        id: _fillLayerId,
        sourceId: _sourceId,
        fillColor: 0x33F25C54,
        fillOutlineColor: 0xFFF25C54,
      ));

      await mapboxMap.style.addLayer(LineLayer(
        id: _lineLayerId,
        sourceId: _sourceId,
        lineColor: 0xFFF25C54,
        lineWidth: 2.0,
      ));
    } catch (_) {
      _current = null;
    }
  }

  Future<void> clear() async {
    if (_current == null) return;
    _current = null;
    try {
      await mapboxMap.style.removeStyleLayer(_fillLayerId);
      await mapboxMap.style.removeStyleLayer(_lineLayerId);
      await mapboxMap.style.removeStyleSource(_sourceId);
    } catch (_) {}
  }

  Future<void> reapply() async {
    final kmlOrUrl = _current;
    if (kmlOrUrl == null) return;
    _current = null;
    await show(kmlOrUrl);
  }

  Map<String, dynamic>? _kmlToGeoJson(String kml) {
    final features = <Map<String, dynamic>>[];

    final placemarkRegex = RegExp(
      r'<Placemark[^>]*>([\s\S]*?)</Placemark>',
      caseSensitive: false,
    );

    for (final pm in placemarkRegex.allMatches(kml)) {
      final block = pm.group(1)!;

      // Polygon
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
            'geometry': {
              'type': 'Polygon',
              'coordinates': [ring, ...innerRings],
            },
            'properties': {},
          });
        }
        continue;
      }

      // LineString
      final lineRegex = RegExp(
        r'<LineString>[\s\S]*?<coordinates>([\s\S]*?)</coordinates>',
        caseSensitive: false,
      );
      for (final lm in lineRegex.allMatches(block)) {
        final coords = _parseCoords(lm.group(1)!);
        if (coords.length >= 2) {
          features.add({
            'type': 'Feature',
            'geometry': {
              'type': 'LineString',
              'coordinates': coords,
            },
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
}
