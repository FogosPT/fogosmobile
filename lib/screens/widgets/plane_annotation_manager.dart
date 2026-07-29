import 'dart:convert';
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fogosmobile/models/plane.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

/// Latest attempt at syncing planes onto the map. Kept as a top-level
/// static so the notifications-diagnostics screen can display it — the
/// map manager is torn down between navigations, but this survives.
class PlaneSyncReport {
  static int? lastAttemptMs;
  static int? totalPlanes;
  static int? withPositions;
  static int? placedAnnotations;
  static String? lastError;
}

/// Draws firefighting aircraft markers (rotated by heading) + their recent
/// flight tracks as polylines. Mirrors the setup used by
/// [FireAnnotationManager] for point annotations and [KmlLayerManager] for
/// GeoJSON line layers.
class PlaneAnnotationManager {
  final MapboxMap mapboxMap;
  final void Function(Plane)? onPlaneTap;

  PointAnnotationManager? _manager;
  Cancelable? _tapListener;
  final Map<String, Plane> _annotationToPlane = {};

  static const String _tracksSourceId = 'planes-tracks-source';
  static const String _tracksLayerId = 'planes-tracks-line';
  bool _tracksSourceAdded = false;

  /// Cache of rendered plane icon PNG bytes, keyed by `kind_size`.
  final Map<String, Uint8List> _iconCache = {};
  final Map<String, PictureInfo> _svgCache = {};

  static const int _iconSize = 64;

  PlaneAnnotationManager({
    required this.mapboxMap,
    this.onPlaneTap,
  });

  Future<void> init() async {
    _manager = await mapboxMap.annotations.createPointAnnotationManager();
    // Planes fly directly over fire markers — without allow-overlap the
    // symbol placement engine hides every plane that collides with a fire
    // (or another plane). Ignore-placement keeps fires visible too.
    try {
      await _manager!.setIconAllowOverlap(true);
      await _manager!.setIconIgnorePlacement(true);
    } catch (e) {
      debugPrint('[planes] init overlap settings failed: $e');
    }
    // NOTE: intentionally NOT calling setIconRotationAlignment(MAP). It
    // aligns iconRotate to map-east (an icon with rotation 0 faces east
    // on the map), which mismatched our SVG that points north — planes
    // rendered but at wrong headings and, in mapbox_maps_flutter 2.19,
    // appeared to be dropped by the placement engine entirely. Default
    // (viewport) alignment keeps the compass-bearing rotation aligned
    // with a north-up map, which is how the map opens 99% of the time.
    _tapListener = _manager!.tapEvents(onTap: _onAnnotationClick);
  }

  Future<PictureInfo> _loadSvg(String assetPath) async {
    if (_svgCache.containsKey(assetPath)) return _svgCache[assetPath]!;
    final loader = SvgAssetLoader(assetPath);
    final pictureInfo = await vg.loadPicture(loader, null);
    _svgCache[assetPath] = pictureInfo;
    return pictureInfo;
  }

  Future<Uint8List> _renderPlaneIcon(String kind) async {
    final cacheKey = '${kind}_$_iconSize';
    if (_iconCache.containsKey(cacheKey)) return _iconCache[cacheKey]!;

    final svgAsset = kind == 'helicopter'
        ? 'assets/tracking-helicopter.svg'
        : 'assets/tracking-plane.svg';
    final s = _iconSize.toDouble();
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);

    try {
      final pictureInfo = await _loadSvg(svgAsset);
      final iconSize = s * 0.9;
      final offset = (s - iconSize) / 2;

      canvas.save();
      canvas.translate(offset, offset);
      canvas.scale(
        iconSize / pictureInfo.size.width,
        iconSize / pictureInfo.size.height,
      );
      canvas.drawPicture(pictureInfo.picture);
      canvas.restore();
    } catch (_) {
      // Fallback: filled triangle pointing north.
      final paint = Paint()..color = const Color(0xFF1F2937);
      final path = Path()
        ..moveTo(s / 2, s * 0.1)
        ..lineTo(s * 0.85, s * 0.9)
        ..lineTo(s / 2, s * 0.75)
        ..lineTo(s * 0.15, s * 0.9)
        ..close();
      canvas.drawPath(path, paint);
    }

    final picture = recorder.endRecording();
    final img = await picture.toImage(_iconSize, _iconSize);
    final byteData = await img.toByteData(format: ui.ImageByteFormat.png);
    final bytes = byteData!.buffer.asUint8List();
    _iconCache[cacheKey] = bytes;
    return bytes;
  }

  Future<void> syncPlanes(List<Plane> planes) async {
    PlaneSyncReport.lastAttemptMs = DateTime.now().millisecondsSinceEpoch;
    PlaneSyncReport.totalPlanes = planes.length;
    PlaneSyncReport.withPositions = null;
    PlaneSyncReport.placedAnnotations = null;
    PlaneSyncReport.lastError = null;

    if (_manager == null) {
      PlaneSyncReport.lastError = 'manager_null';
      return;
    }

    try {
      await _manager!.deleteAll();
      _annotationToPlane.clear();

      final visible = planes.where((p) => p.lastPosition != null).toList();
      PlaneSyncReport.withPositions = visible.length;
      debugPrint('[planes] sync ${planes.length} total, ${visible.length} with positions');

      // Markers
      if (visible.isNotEmpty) {
        final options = <PointAnnotationOptions>[];
        final iconByKind = <String, Uint8List>{};

        for (final plane in visible) {
          final last = plane.lastPosition!;
          iconByKind[plane.kind] ??= await _renderPlaneIcon(plane.kind);
          final rotation = (last.track ?? 0).toDouble();

          options.add(PointAnnotationOptions(
            geometry: Point(coordinates: Position(last.lon, last.lat)),
            image: iconByKind[plane.kind],
            iconSize: 1.0,
            iconAnchor: IconAnchor.CENTER,
            iconRotate: rotation,
          ));
        }

        final annotations = await _manager!.createMulti(options);
        int placed = 0;
        for (int i = 0; i < annotations.length; i++) {
          final annotation = annotations[i];
          if (annotation != null) {
            _annotationToPlane[annotation.id] = visible[i];
            placed++;
          }
        }
        PlaneSyncReport.placedAnnotations = placed;
        debugPrint('[planes] placed $placed annotations');
      } else {
        PlaneSyncReport.placedAnnotations = 0;
      }

      // Track polylines
      await _syncTracks(visible);
    } catch (e, st) {
      PlaneSyncReport.lastError = e.toString();
      debugPrint('[planes] sync failed: $e\n$st');
    }
  }

  Future<void> _syncTracks(List<Plane> planes) async {
    final features = <Map<String, dynamic>>[];
    for (final plane in planes) {
      if (plane.positions.length < 2) continue;
      features.add({
        'type': 'Feature',
        'geometry': {
          'type': 'LineString',
          'coordinates': plane.positions
              .map((p) => [p.lon, p.lat])
              .toList(),
        },
        'properties': {'icao': plane.icao},
      });
    }

    final geoJson = jsonEncode({
      'type': 'FeatureCollection',
      'features': features,
    });

    try {
      if (!_tracksSourceAdded) {
        await mapboxMap.style.addSource(GeoJsonSource(
          id: _tracksSourceId,
          data: geoJson,
        ));
        await mapboxMap.style.addLayer(LineLayer(
          id: _tracksLayerId,
          sourceId: _tracksSourceId,
          lineColor: 0xFF3B82F6,
          lineWidth: 2.0,
          lineOpacity: 0.85,
        ));
        _tracksSourceAdded = true;
      } else {
        final source = await mapboxMap.style.getSource(_tracksSourceId)
            as GeoJsonSource?;
        await source?.updateGeoJSON(geoJson);
      }
    } catch (_) {
      // Style may have been swapped out — reset flag so next sync recreates.
      _tracksSourceAdded = false;
    }
  }

  Future<void> clear() async {
    await _manager?.deleteAll();
    _annotationToPlane.clear();

    if (_tracksSourceAdded) {
      _tracksSourceAdded = false;
      try {
        await mapboxMap.style.removeStyleLayer(_tracksLayerId);
        await mapboxMap.style.removeStyleSource(_tracksSourceId);
      } catch (_) {}
    }
  }

  void _onAnnotationClick(PointAnnotation annotation) {
    final plane = _annotationToPlane[annotation.id];
    if (plane != null && onPlaneTap != null) {
      onPlaneTap!(plane);
    }
  }

  Future<void> dispose() async {
    _tapListener?.cancel();
    _tapListener = null;
    await clear();
    _manager = null;
  }
}
