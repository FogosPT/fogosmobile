import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fogosmobile/models/fire.dart';
import 'package:fogosmobile/screens/utils/widget_utils.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

class FireAnnotationManager {
  final MapboxMap mapboxMap;
  final void Function(Fire)? onFireTap;

  PointAnnotationManager? _manager;
  Cancelable? _tapListener;
  final Map<String, Fire> _annotationToFire = {};

  /// Cache icon PNG bytes keyed by "colorValue_size_svgAsset"
  final Map<String, Uint8List> _iconCache = {};

  /// Cache loaded SVG PictureInfo keyed by asset path
  final Map<String, PictureInfo> _svgCache = {};

  FireAnnotationManager({
    required this.mapboxMap,
    this.onFireTap,
  });

  Future<void> init() async {
    _manager = await mapboxMap.annotations.createPointAnnotationManager();
    _tapListener = _manager!.tapEvents(onTap: _onAnnotationClick);
  }

  Future<PictureInfo> _loadSvg(String assetPath) async {
    if (_svgCache.containsKey(assetPath)) return _svgCache[assetPath]!;
    final loader = SvgAssetLoader(assetPath);
    final pictureInfo = await vg.loadPicture(loader, null);
    _svgCache[assetPath] = pictureInfo;
    return pictureInfo;
  }

  Future<Uint8List> _renderFireIcon(
      Color color, int size, String svgAsset) async {
    final cacheKey = '${color.value}_${size}_$svgAsset';
    if (_iconCache.containsKey(cacheKey)) return _iconCache[cacheKey]!;

    final s = size.toDouble();
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);

    // Draw colored circle background
    final paint = Paint()..color = color;
    canvas.drawCircle(Offset(s / 2, s / 2), s / 2, paint);

    // Draw white border
    final borderPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.8)
      ..style = PaintingStyle.stroke
      ..strokeWidth = s * 0.06;
    canvas.drawCircle(Offset(s / 2, s / 2), s / 2 - 1, borderPaint);

    // Draw SVG icon centered inside the circle
    try {
      final pictureInfo = await _loadSvg(svgAsset);
      final svgSize = s * 0.55;
      final svgOffset = (s - svgSize) / 2;

      canvas.save();
      canvas.translate(svgOffset, svgOffset);
      canvas.scale(
        svgSize / pictureInfo.size.width,
        svgSize / pictureInfo.size.height,
      );
      canvas.drawPicture(pictureInfo.picture);
      canvas.restore();
    } catch (_) {
      // Fallback: just the colored circle
    }

    final picture = recorder.endRecording();
    final img = await picture.toImage(size, size);
    final byteData = await img.toByteData(format: ui.ImageByteFormat.png);
    final bytes = byteData!.buffer.asUint8List();
    _iconCache[cacheKey] = bytes;
    return bytes;
  }

  int _getIconSize(double scale) {
    double pinSize = 72.0 * scale;
    if (pinSize == 0 || pinSize < 54) pinSize = 54.0;
    if (pinSize > 108) pinSize = 108.0;
    return pinSize.toInt();
  }

  Future<void> syncFires(List<Fire> fires, List<FireStatus>? filters) async {
    if (_manager == null) return;

    await _manager!.deleteAll();
    _annotationToFire.clear();

    final filtered = fires.where((f) => !f.skip(filters ?? [])).toList();
    if (filtered.isEmpty) return;

    final options = <PointAnnotationOptions>[];
    for (final fire in filtered) {
      final color = getFireColor(fire);
      final size = _getIconSize(fire.scale);
      final svgAsset =
          getCorrectStatusImage(fire.statusCode, fire.important);
      final imageBytes = await _renderFireIcon(color, size, svgAsset);

      options.add(PointAnnotationOptions(
        geometry: fire.location,
        image: imageBytes,
        iconSize: 1.0,
        iconAnchor: IconAnchor.CENTER,
      ));
    }

    final annotations = await _manager!.createMulti(options);

    for (int i = 0; i < annotations.length; i++) {
      final annotation = annotations[i];
      if (annotation != null) {
        _annotationToFire[annotation.id] = filtered[i];
      }
    }
  }

  void _onAnnotationClick(PointAnnotation annotation) {
    final fire = _annotationToFire[annotation.id];
    if (fire != null && onFireTap != null) {
      onFireTap!(fire);
    }
  }

  Future<void> dispose() async {
    _tapListener?.cancel();
    _tapListener = null;
    if (_manager != null) {
      await _manager!.deleteAll();
      _manager = null;
    }
    _annotationToFire.clear();
  }
}
