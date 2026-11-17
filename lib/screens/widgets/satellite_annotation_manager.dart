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
  String? _pendingModisGeoJson;
  String? _pendingViirsGeoJson;
  Future<void> _modisSyncChain = Future.value();
  Future<void> _viirsSyncChain = Future.value();

  SatelliteAnnotationManager({
    required this.mapboxMap,
    this.onModisTap,
    this.onViirsTap,
  });

  Future<void> init() async {
    // Layers are created lazily on the first sync, after the style is ready.
  }

  Future<void> syncModis(List<Modis> modisList) async {
    final filtered = modisList.where((m) => !m.skip([])).toList();
    _modisById
      ..clear()
      ..addEntries(filtered.asMap().entries.map((e) => MapEntry('m${e.key}', e.value)));
    _pendingModisGeoJson = _featureCollection([
      for (final entry in _modisById.entries)
        _pointFeature(entry.key, entry.value.longitude, entry.value.latitude),
    ]);
    await _runModis(() => _flushLayer(
          sourceAdded: () => _modisSourceAdded,
          markAdded: () => _modisSourceAdded = true,
          resetAdded: () => _modisSourceAdded = false,
          pendingData: () => _pendingModisGeoJson,
          sourceId: 'fogos-modis-source',
          clusterLayerId: 'fogos-modis-clusters',
          countLayerId: 'fogos-modis-cluster-count',
          pointLayerId: 'fogos-modis-points',
          color: _modisColor,
        ));
  }

  Future<void> syncViirs(List<Viirs> viirsList) async {
    final filtered = viirsList.where((v) => !v.skip([])).toList();
    _viirsById
      ..clear()
      ..addEntries(filtered.asMap().entries.map((e) => MapEntry('v${e.key}', e.value)));
    _pendingViirsGeoJson = _featureCollection([
      for (final entry in _viirsById.entries)
        _pointFeature(entry.key, entry.value.longitude, entry.value.latitude),
    ]);
    await _runViirs(() => _flushLayer(
          sourceAdded: () => _viirsSourceAdded,
          markAdded: () => _viirsSourceAdded = true,
          resetAdded: () => _viirsSourceAdded = false,
          pendingData: () => _pendingViirsGeoJson,
          sourceId: 'fogos-viirs-source',
          clusterLayerId: 'fogos-viirs-clusters',
          countLayerId: 'fogos-viirs-cluster-count',
          pointLayerId: 'fogos-viirs-points',
          color: _viirsColor,
        ));
  }

  Future<void> clearModis() async {
    _modisById.clear();
    _pendingModisGeoJson = null;
    await _runModis(() async {
      await _removeLayerSet(
        sourceId: 'fogos-modis-source',
        layerIds: const [
          'fogos-modis-cluster-count',
          'fogos-modis-clusters',
          'fogos-modis-points',
        ],
      );
      _modisSourceAdded = false;
    });
  }

  Future<void> clearViirs() async {
    _viirsById.clear();
    _pendingViirsGeoJson = null;
    await _runViirs(() async {
      await _removeLayerSet(
        sourceId: 'fogos-viirs-source',
        layerIds: const [
          'fogos-viirs-cluster-count',
          'fogos-viirs-clusters',
          'fogos-viirs-points',
        ],
      );
      _viirsSourceAdded = false;
    });
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

  String _featureCollection(List<Map<String, dynamic>> features) {
    return jsonEncode({
      'type': 'FeatureCollection',
      'features': features,
    });
  }

  /// Serialize source creation and updates for one feed so overlapping
  /// syncs cannot both observe `sourceAdded == false`. A failed step does
  /// not poison later work on the same source.
  Future<void> _runModis(Future<void> Function() action) {
    final run = _modisSyncChain.then((_) => action(), onError: (_) => action());
    _modisSyncChain = run.then((_) {}, onError: (_) {});
    return run;
  }

  Future<void> _runViirs(Future<void> Function() action) {
    final run = _viirsSyncChain.then((_) => action(), onError: (_) => action());
    _viirsSyncChain = run.then((_) {}, onError: (_) {});
    return run;
  }

  Future<void> _flushLayer({
    required bool Function() sourceAdded,
    required VoidCallback markAdded,
    required VoidCallback resetAdded,
    required String? Function() pendingData,
    required String sourceId,
    required String clusterLayerId,
    required String countLayerId,
    required String pointLayerId,
    required int color,
  }) async {
    final geoJson = pendingData();
    if (geoJson == null) {
      return;
    }

    try {
      if (!sourceAdded()) {
        await _ensureSourceAndLayers(
          sourceId: sourceId,
          clusterLayerId: clusterLayerId,
          countLayerId: countLayerId,
          pointLayerId: pointLayerId,
          color: color,
          geoJson: geoJson,
        );
        markAdded();
      }

      // Apply the latest pending data, not the snapshot we started with —
      // a newer sync may have arrived while the source was being created.
      final latest = pendingData();
      if (latest == null) {
        return;
      }
      final source =
          await mapboxMap.style.getSource(sourceId) as GeoJsonSource?;
      if (source == null) {
        resetAdded();
        return;
      }
      await source.updateGeoJSON(latest);
      markAdded();
    } catch (error) {
      if (isAlreadyExistsError(error)) {
        // The source (or a layer) already exists, so keep the flag set and
        // still try to push the latest data.
        markAdded();
        final latest = pendingData();
        if (latest != null) {
          try {
            final source =
                await mapboxMap.style.getSource(sourceId) as GeoJsonSource?;
            await source?.updateGeoJSON(latest);
          } catch (_) {}
        }
        return;
      }
      // Style may have been swapped out — recreate on the next sync.
      resetAdded();
    }
  }

  Future<void> _ensureSourceAndLayers({
    required String sourceId,
    required String clusterLayerId,
    required String countLayerId,
    required String pointLayerId,
    required int color,
    required String geoJson,
  }) async {
    await _addIgnoringExisting(() => mapboxMap.style.addSource(GeoJsonSource(
          id: sourceId,
          data: geoJson,
          cluster: true,
          clusterRadius: 50,
          clusterMaxZoom: 12,
        )));
    await _addIgnoringExisting(() => mapboxMap.style.addLayer(CircleLayer(
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
        )));
    await _addIgnoringExisting(() => mapboxMap.style.addLayer(SymbolLayer(
          id: countLayerId,
          sourceId: sourceId,
          filter: const ['has', 'point_count'],
          textField: '{point_count_abbreviated}',
          textSize: 12,
          textColor: Colors.white.value,
          textAllowOverlap: true,
        )));
    await _addIgnoringExisting(() => mapboxMap.style.addLayer(CircleLayer(
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
        )));
  }

  Future<void> _addIgnoringExisting(Future<void> Function() add) async {
    try {
      await add();
    } catch (error) {
      if (!isAlreadyExistsError(error)) {
        rethrow;
      }
    }
  }

  /// Mapbox style operations reject a second add of the same source or
  /// layer ID with an "already exists" / duplicate-ID error.
  static bool isAlreadyExistsError(Object error) {
    final msg = error.toString().toLowerCase();
    if (msg.contains('alreadyexists') ||
        msg.contains('already_exists') ||
        msg.contains('already exists') ||
        msg.contains('already added')) {
      return true;
    }
    return msg.contains('duplicate') &&
        (msg.contains('id') ||
            msg.contains('source') ||
            msg.contains('layer'));
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
