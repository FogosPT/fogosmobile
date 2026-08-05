import 'package:fogosmobile/constants/ipma_layers.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

class IpmaLayerManager {
  final MapboxMap mapboxMap;
  final Set<String> _active = <String>{};
  String? _referenceTime;

  IpmaLayerManager({required this.mapboxMap, String? referenceTime})
      : _referenceTime = referenceTime;

  String? get referenceTime => _referenceTime;

  Future<void> sync(Set<String> desired, {String? referenceTime}) async {
    final refChanged = referenceTime != _referenceTime;
    _referenceTime = referenceTime;

    // If the reference_time changed, drop and re-add every AROME layer that
    // is currently active so the new value gets baked into the tile URL.
    if (refChanged) {
      final aromeActive = _active
          .where((k) => ipmaGroupForKey(k)?.requiresReferenceTime ?? false)
          .toList();
      for (final key in aromeActive) {
        final group = ipmaGroupForKey(key);
        if (group != null) await _removeGroup(group);
        _active.remove(key);
      }
    }

    final effective = desired.where((k) {
      final g = ipmaGroupForKey(k);
      if (g == null) return false;
      // Skip AROME layers until reference_time is available.
      if (g.requiresReferenceTime &&
          (_referenceTime == null || _referenceTime!.isEmpty)) {
        return false;
      }
      return true;
    }).toSet();

    final toAdd = effective.difference(_active);
    final toRemove = _active.difference(effective);

    for (final key in toRemove) {
      final group = ipmaGroupForKey(key);
      if (group != null) await _removeGroup(group);
      _active.remove(key);
    }

    for (final key in toAdd) {
      final group = ipmaGroupForKey(key);
      if (group != null) await _addGroup(group);
      _active.add(key);
    }
  }

  Future<void> reapply(Set<String> desired, {String? referenceTime}) async {
    _active.clear();
    _referenceTime = referenceTime;
    await sync(desired, referenceTime: referenceTime);
  }

  Future<void> clear() async {
    final keys = Set<String>.from(_active);
    for (final key in keys) {
      final group = ipmaGroupForKey(key);
      if (group != null) await _removeGroup(group);
    }
    _active.clear();
  }

  Future<void> _addGroup(IpmaLayerGroup group) async {
    for (var i = 0; i < group.wmsLayerNames.length; i++) {
      final sourceId = '${group.key}-$i';
      final layerId = '$sourceId-layer';
      try {
        await mapboxMap.style.addSource(RasterSource(
          id: sourceId,
          tiles: [
            ipmaTileUrl(
              group.wmsLayerNames[i],
              referenceTime:
                  group.requiresReferenceTime ? _referenceTime : null,
            ),
          ],
          tileSize: 256,
        ));
        await mapboxMap.style.addLayer(RasterLayer(
          id: layerId,
          sourceId: sourceId,
          rasterOpacity: group.opacity,
          rasterContrast: group.isWindBarbs ? 1.0 : null,
          rasterBrightnessMax: group.isWindBarbs ? 0.4 : null,
          rasterBrightnessMin: group.isWindBarbs ? 0.0 : null,
          rasterSaturation: group.isWindBarbs ? -1.0 : null,
        ));
      } catch (_) {}
    }
  }

  Future<void> _removeGroup(IpmaLayerGroup group) async {
    for (var i = 0; i < group.wmsLayerNames.length; i++) {
      final sourceId = '${group.key}-$i';
      final layerId = '$sourceId-layer';
      try {
        await mapboxMap.style.removeStyleLayer(layerId);
      } catch (_) {}
      try {
        await mapboxMap.style.removeStyleSource(sourceId);
      } catch (_) {}
    }
  }
}
