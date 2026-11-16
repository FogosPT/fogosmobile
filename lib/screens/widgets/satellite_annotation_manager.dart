import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fogosmobile/models/modis.dart';
import 'package:fogosmobile/models/viirs.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

/// Renders MODIS/VIIRS hotspots as clustered GeoJSON circle layers.
///
/// A CircleAnnotation per point (the previous approach) makes panning and
/// zooming very slow once the feed has hundreds of points — the public VIIRS
/// endpoint regularly returns 400+ detections, almost all outside Portugal,
/// and many more in fire season. Style layers are drawn on the GPU as a
/// single source, and clustering keeps the map readable at country zoom.
class SatelliteAnnotationManager {
  static const _viirsColor = 0xffE76700;
  static const _modisColor = 0xffE1BC29;

  final MapboxMap mapboxMap;
  final void Function(Modis)? onModisTap;
  final void Function(Viirs)? onViirsTap;

  final Map<String, Modis> _modisById = {};
  final Map<String, Viirs> _viirsById = {};

  bool _modisSourceAdded = false;
  bool _viirsSourceAdded = false;
  int _modisSyncGen = 0;
  int _viirsSyncGen = 0;

  SatelliteAnnotationManager({
    required this.mapboxMap,
    this.onModisTap,
    this.onViirsTap,
  });

  Future<void> init() async {
    // Layers are created lazily on the first sync, after the style is ready.
  }

  Future<void> syncModis(List<Modis> modisList) async {
    final gen = ++_modisSyncGen;
    final filtered = modisList.where((m) => !m.skip([])).toList();
    _modisById
      ..clear()
      ..addEntries(filtered.asMap().entries.map((e) => MapEntry('m${e.key}', e.value)));
    await _syncLayer(
      gen: gen,
      currentGen: () => _modisSyncGen,
      sourceAdded: _modisSourceAdded,
      markAdded: () => _modisSourceAdded = true,
      resetAdded: () => _modisSourceAdded = false,
      sourceId: 'fogos-modis-source',
      clusterLayerId: 'fogos-modis-clusters',
      countLayerId: 'fogos-modis-cluster-count',
      pointLayerId: 'fogos-modis-points',
      color: _modisColor,
      features: [
        for (final entry in _modisById.entries)
          _pointFeature(entry.key, entry.value.longitude, entry.value.latitude),
      ],
    );
  }

  Future<void> syncViirs(List<Viirs> viirsList) async {
    final gen = ++_viirsSyncGen;
    final filtered = viirsList.where((v) => !v.skip([])).toList();
    _viirsById
      ..clear()
      ..addEntries(filtered.asMap().entries.map((e) => MapEntry('v${e.key}', e.value)));
    await _syncLayer(
      gen: gen,
      currentGen: () => _viirsSyncGen,
      sourceAdded: _viirsSourceAdded,
      markAdded: () => _viirsSourceAdded = true,
      resetAdded: () => _viirsSourceAdded = false,
      sourceId: 'fogos-viirs-source',
      clusterLayerId: 'fogos-viirs-clusters',
      countLayerId: 'fogos-viirs-cluster-count',
      pointLayerId: 'fogos-viirs-points',
      color: _viirsColor,
      features: [
        for (final entry in _viirsById.entries)
          _pointFeature(entry.key, entry.value.longitude, entry.value.latitude),
      ],
    );
  }

  Future<void> clearModis() async {
    _modisSyncGen++;
    _modisById.clear();
    await _removeLayerSet(
      sourceId: 'fogos-modis-source',
      layerIds: const [
        'fogos-modis-cluster-count',
        'fogos-modis-clusters',
        'fogos-modis-points',
      ],
    );
    _modisSourceAdded = false;
  }

  Future<void> clearViirs() async {
    _viirsSyncGen++;
    _viirsById.clear();
    await _removeLayerSet(
      sourceId: 'fogos-viirs-source',
      layerIds: const [
        'fogos-viirs-cluster-count',
        'fogos-viirs-clusters',
        'fogos-viirs-points',
      ],
    );
    _viirsSourceAdded = false;
  }

  /// Handles a map tap. Returns true if a hotspot or cluster was hit, so the
  /// caller can stop other overlay handling.
  Future<bool> handleTap(ScreenCoordinate touchPosition) async {
    final hits = await mapboxMap.queryRenderedFeatures(
      RenderedQueryGeometry.fromScreenCoordinate(touchPosition),
      RenderedQueryOptions(
        layerIds: const [
          'fogos-viirs-points',
          'fogos-viirs-clusters',
          'fogos-viirs-cluster-count',
          'fogos-modis-points',
          'fogos-modis-clusters',
          'fogos-modis-cluster-count',
        ],
      ),
    );
    for (final hit in hits) {
      if (hit == null) continue;
      final feature = hit.queriedFeature.feature;
      final props = _properties(feature);
      if (props == null) continue;

      if (props['cluster'] == true || props['point_count'] != null) {
        await _expandCluster(hit.queriedFeature.source, feature);
        return true;
      }

      final id = props['id']?.toString();
      if (id != null && _viirsById.containsKey(id)) {
        onViirsTap?.call(_viirsById[id]!);
        return true;
      }
      if (id != null && _modisById.containsKey(id)) {
        onModisTap?.call(_modisById[id]!);
        return true;
      }
    }
    return false;
  }

  Future<void> dispose() async {
    await clearViirs();
    await clearModis();
  }

  Map<String, dynamic> _pointFeature(String id, double lon, double lat) {
    return {
      'type': 'Feature',
      'id': id,
      'geometry': {
        'type': 'Point',
        'coordinates': [lon, lat],
      },
      'properties': {'id': id},
    };
  }

  Future<void> _syncLayer({
    required int gen,
    required int Function() currentGen,
    required bool sourceAdded,
    required VoidCallback markAdded,
    required VoidCallback resetAdded,
    required String sourceId,
    required String clusterLayerId,
    required String countLayerId,
    required String pointLayerId,
    required int color,
    required List<Map<String, dynamic>> features,
  }) async {
    final geoJson = jsonEncode({
      'type': 'FeatureCollection',
      'features': features,
    });

    try {
      if (!sourceAdded) {
        await mapboxMap.style.addSource(GeoJsonSource(
          id: sourceId,
          data: geoJson,
          cluster: true,
          clusterRadius: 50,
          clusterMaxZoom: 12,
        ));
        await mapboxMap.style.addLayer(CircleLayer(
          id: clusterLayerId,
          sourceId: sourceId,
          filter: const ['has', 'point_count'],
          circleColor: color,
          circleRadiusExpression: const [
            'step',
            ['get', 'point_count'],
            16,
            10,
            20,
            50,
            26,
          ],
          circleStrokeColor: Colors.white.value,
          circleStrokeWidth: 1.5,
        ));
        await mapboxMap.style.addLayer(SymbolLayer(
          id: countLayerId,
          sourceId: sourceId,
          filter: const ['has', 'point_count'],
          textField: '{point_count_abbreviated}',
          textSize: 12,
          textColor: Colors.white.value,
          textAllowOverlap: true,
        ));
        await mapboxMap.style.addLayer(CircleLayer(
          id: pointLayerId,
          sourceId: sourceId,
          filter: const [
            '!',
            ['has', 'point_count']
          ],
          circleRadius: 8.0,
          circleColor: color,
          circleStrokeColor: Colors.white.value,
          circleStrokeWidth: 1.5,
        ));
        if (currentGen() != gen) return;
        markAdded();
      } else {
        final source =
            await mapboxMap.style.getSource(sourceId) as GeoJsonSource?;
        await source?.updateGeoJSON(geoJson);
      }
    } catch (_) {
      // Style may have been swapped out — recreate on the next sync.
      resetAdded();
    }
  }

  Future<void> _removeLayerSet({
    required String sourceId,
    required List<String> layerIds,
  }) async {
    for (final id in layerIds) {
      try {
        await mapboxMap.style.removeStyleLayer(id);
      } catch (_) {}
    }
    try {
      await mapboxMap.style.removeStyleSource(sourceId);
    } catch (_) {}
  }

  Map<String, dynamic>? _properties(Map<String?, Object?> feature) {
    final raw = feature['properties'];
    if (raw is Map) {
      return raw.map((key, value) => MapEntry(key.toString(), value));
    }
    return null;
  }

  Future<void> _expandCluster(
    String sourceId,
    Map<String?, Object?> feature,
  ) async {
    try {
      final zoomValue =
          await mapboxMap.getGeoJsonClusterExpansionZoom(sourceId, feature);
      final zoom = double.tryParse('${zoomValue.value}');
      final geometry = feature['geometry'];
      List? coordinates;
      if (geometry is Map) {
        coordinates = geometry['coordinates'] as List?;
      }
      if (zoom == null || coordinates == null || coordinates.length < 2) {
        return;
      }
      await mapboxMap.easeTo(
        CameraOptions(
          center: Point(
            coordinates: Position(
              (coordinates[0] as num).toDouble(),
              (coordinates[1] as num).toDouble(),
            ),
          ),
          zoom: zoom,
        ),
        MapAnimationOptions(duration: 450),
      );
    } catch (_) {}
  }
}
