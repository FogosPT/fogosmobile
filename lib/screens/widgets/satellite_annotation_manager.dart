import 'package:flutter/material.dart';
import 'package:fogosmobile/models/modis.dart';
import 'package:fogosmobile/models/viirs.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

class SatelliteAnnotationManager {
  final MapboxMap mapboxMap;
  final void Function(Modis)? onModisTap;
  final void Function(Viirs)? onViirsTap;

  CircleAnnotationManager? _modisManager;
  CircleAnnotationManager? _viirsManager;
  Cancelable? _modisTapListener;
  Cancelable? _viirsTapListener;

  final Map<String, Modis> _annotationToModis = {};
  final Map<String, Viirs> _annotationToViirs = {};

  SatelliteAnnotationManager({
    required this.mapboxMap,
    this.onModisTap,
    this.onViirsTap,
  });

  Future<void> init() async {
    _modisManager =
        await mapboxMap.annotations.createCircleAnnotationManager();
    _viirsManager =
        await mapboxMap.annotations.createCircleAnnotationManager();

    _modisTapListener = _modisManager!.tapEvents(onTap: _onModisClick);
    _viirsTapListener = _viirsManager!.tapEvents(onTap: _onViirsClick);
  }

  Future<void> syncModis(List<Modis> modisList) async {
    if (_modisManager == null) return;

    await _modisManager!.deleteAll();
    _annotationToModis.clear();

    final filtered = modisList.where((m) => !m.skip([])).toList();

    final options = filtered
        .map((m) => CircleAnnotationOptions(
              geometry: m.location,
              circleRadius: 8.0,
              circleColor: Colors.amber.value,
              circleStrokeColor: Colors.white.value,
              circleStrokeWidth: 1.5,
            ))
        .toList();

    final annotations = await _modisManager!.createMulti(options);

    for (int i = 0; i < annotations.length; i++) {
      final annotation = annotations[i];
      if (annotation != null) {
        _annotationToModis[annotation.id] = filtered[i];
      }
    }
  }

  Future<void> syncViirs(List<Viirs> viirsList) async {
    if (_viirsManager == null) return;

    await _viirsManager!.deleteAll();
    _annotationToViirs.clear();

    final filtered = viirsList.where((v) => !v.skip([])).toList();

    final options = filtered
        .map((v) => CircleAnnotationOptions(
              geometry: v.location,
              circleRadius: 8.0,
              circleColor: Colors.orangeAccent.value,
              circleStrokeColor: Colors.white.value,
              circleStrokeWidth: 1.5,
            ))
        .toList();

    final annotations = await _viirsManager!.createMulti(options);

    for (int i = 0; i < annotations.length; i++) {
      final annotation = annotations[i];
      if (annotation != null) {
        _annotationToViirs[annotation.id] = filtered[i];
      }
    }
  }

  Future<void> clearModis() async {
    await _modisManager?.deleteAll();
    _annotationToModis.clear();
  }

  Future<void> clearViirs() async {
    await _viirsManager?.deleteAll();
    _annotationToViirs.clear();
  }

  void _onModisClick(CircleAnnotation annotation) {
    final modis = _annotationToModis[annotation.id];
    if (modis != null && onModisTap != null) {
      onModisTap!(modis);
    }
  }

  void _onViirsClick(CircleAnnotation annotation) {
    final viirs = _annotationToViirs[annotation.id];
    if (viirs != null && onViirsTap != null) {
      onViirsTap!(viirs);
    }
  }

  Future<void> dispose() async {
    _modisTapListener?.cancel();
    _viirsTapListener?.cancel();
    _modisTapListener = null;
    _viirsTapListener = null;
    await _modisManager?.deleteAll();
    await _viirsManager?.deleteAll();
    _modisManager = null;
    _viirsManager = null;
    _annotationToModis.clear();
    _annotationToViirs.clear();
  }
}
