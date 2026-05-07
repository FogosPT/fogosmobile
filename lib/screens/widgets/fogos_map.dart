import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fogosmobile/constants/variables.dart';
import 'package:fogosmobile/models/fire.dart';
import 'package:fogosmobile/models/modis.dart';
import 'package:fogosmobile/models/viirs.dart';
import 'package:fogosmobile/screens/components/mapbox_copyright.dart';
import 'package:fogosmobile/screens/widgets/fire_annotation_manager.dart';
import 'package:fogosmobile/screens/widgets/kml_layer_manager.dart';
import 'package:fogosmobile/screens/widgets/map_overlay_error_info.dart';
import 'package:fogosmobile/screens/widgets/satellite_annotation_manager.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

class FogosMap extends StatefulWidget {
  final List<Fire> fires;
  final List<FireStatus>? fireFilters;
  final List<Modis>? modis;
  final List<Viirs>? viirs;
  final bool showModis;
  final bool showViirs;
  final bool showNatureCodes;
  final bool useSatelliteStyle;
  final List<String> kmlVostUrls;
  final String? kmlAreaUrl;
  final void Function(Fire)? onFireTap;
  final void Function(Modis)? onModisTap;
  final void Function(Viirs)? onViirsTap;
  final Widget? overlayButtons;

  const FogosMap({
    super.key,
    required this.fires,
    this.fireFilters,
    this.modis,
    this.viirs,
    this.showModis = false,
    this.showViirs = false,
    this.showNatureCodes = true,
    this.useSatelliteStyle = false,
    this.kmlVostUrls = const [],
    this.kmlAreaUrl,
    this.onFireTap,
    this.onModisTap,
    this.onViirsTap,
    this.overlayButtons,
  });

  @override
  State<FogosMap> createState() => _FogosMapState();
}

class _FogosMapState extends State<FogosMap> {
  static final Point _center =
      Point(coordinates: Position(-8.088591, 39.806251));
  static final List<String> _styles = [
    MAPBOX_TEMPLATE_STYLE,
    MAPBOX_URL_SATTELITE_TEMPLATE,
  ];

  MapboxMap? _mapController;
  FireAnnotationManager? _fireManager;
  SatelliteAnnotationManager? _satelliteManager;
  final Map<String, KmlLayerManager> _kmlVostManagers = {};
  KmlLayerManager? _kmlAreaManager;
  int _lastAppliedTemplate = -1;
  bool _managersReady = false;
  double _zoom = 7.0;

  int get _templateIndex => widget.useSatelliteStyle ? 1 : 0;

  void _onMapCreated(MapboxMap mapboxMap) {
    _mapController = mapboxMap;
    _configureOrnaments();
    _enableLocationPuck();
  }

  void _configureOrnaments() {
    _mapController!.compass.updateSettings(CompassSettings(
      enabled: false,
    ));
    // Native scale bar disabled — replaced by Flutter overlay widget.
    _mapController!.scaleBar.updateSettings(ScaleBarSettings(
      enabled: false,
    ));
  }

  Future<void> _enableLocationPuck() async {
    final status = await Permission.locationWhenInUse.request();
    if (status.isGranted && _mapController != null) {
      _mapController!.location.updateSettings(LocationComponentSettings(
        enabled: true,
        puckBearingEnabled: true,
      ));
    }
  }

  void _onStyleLoaded(StyleLoadedEventData data) async {
    _managersReady = false;

    await _fireManager?.dispose();
    await _satelliteManager?.dispose();

    if (_mapController == null || !mounted) return;

    _fireManager = FireAnnotationManager(
      mapboxMap: _mapController!,
      onFireTap: widget.onFireTap,
    );
    await _fireManager!.init();

    _satelliteManager = SatelliteAnnotationManager(
      mapboxMap: _mapController!,
      onModisTap: widget.onModisTap,
      onViirsTap: widget.onViirsTap,
    );
    await _satelliteManager!.init();

    _kmlVostManagers.clear();
    _kmlAreaManager = KmlLayerManager(mapboxMap: _mapController!, id: 'area');

    _managersReady = true;

    _configureOrnaments();
    _syncAll();
  }

  void _updateStyleIfNeeded() {
    final idx = _templateIndex;
    if (_mapController != null && idx != _lastAppliedTemplate) {
      _lastAppliedTemplate = idx;
      _mapController!.style.setStyleURI(_styles[idx]);
    }
  }

  @override
  void didUpdateWidget(covariant FogosMap oldWidget) {
    super.didUpdateWidget(oldWidget);
    _updateStyleIfNeeded();

    if (!_managersReady) return;

    if (widget.fires != oldWidget.fires ||
        widget.fireFilters != oldWidget.fireFilters ||
        widget.showNatureCodes != oldWidget.showNatureCodes) {
      _syncFires();
    }

    if (widget.modis != oldWidget.modis ||
        widget.showModis != oldWidget.showModis) {
      _syncModis();
    }

    if (widget.viirs != oldWidget.viirs ||
        widget.showViirs != oldWidget.showViirs) {
      _syncViirs();
    }

    if (widget.kmlVostUrls != oldWidget.kmlVostUrls) {
      _syncKml();
    }

    if (widget.kmlAreaUrl != oldWidget.kmlAreaUrl) {
      _syncKmlArea();
    }
  }

  void _syncAll() {
    _syncFires();
    _syncModis();
    _syncViirs();
    _syncKml();
    _syncKmlArea();
  }

  void _syncFires() {
    _fireManager?.syncFires(widget.fires, widget.fireFilters,
        showNatureCodes: widget.showNatureCodes);
  }

  void _syncModis() {
    if (widget.showModis && widget.modis != null) {
      _satelliteManager?.syncModis(widget.modis!);
    } else {
      _satelliteManager?.clearModis();
    }
  }

  void _syncViirs() {
    if (widget.showViirs && widget.viirs != null) {
      _satelliteManager?.syncViirs(widget.viirs!);
    } else {
      _satelliteManager?.clearViirs();
    }
  }

  void _syncKml() {
    if (_mapController == null) return;
    final newUrls = widget.kmlVostUrls.toSet();
    final oldUrls = _kmlVostManagers.keys.toSet();

    // Remove managers for URLs no longer present
    for (final url in oldUrls.difference(newUrls)) {
      _kmlVostManagers.remove(url)?.clear();
    }

    // Add managers for new URLs
    for (final url in newUrls.difference(oldUrls)) {
      final idx = _kmlVostManagers.length;
      final manager = KmlLayerManager(mapboxMap: _mapController!, id: 'vost-$idx');
      _kmlVostManagers[url] = manager;
      manager.show(url);
    }
  }

  void _syncKmlArea() {
    final url = widget.kmlAreaUrl;
    if (url != null && url.isNotEmpty) {
      _kmlAreaManager?.show(url);
    } else {
      _kmlAreaManager?.clear();
    }
  }

  @override
  void dispose() {
    _fireManager?.dispose();
    _satelliteManager?.dispose();
    for (final m in _kmlVostManagers.values) {
      m.clear();
    }
    _kmlAreaManager?.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        MapWidget(
          styleUri: _styles[_templateIndex],
          onMapCreated: _onMapCreated,
          onStyleLoadedListener: _onStyleLoaded,
          onCameraChangeListener: (_) {
            _mapController?.getCameraState().then((state) {
              if (mounted) setState(() => _zoom = state.zoom);
            });
          },
          cameraOptions: CameraOptions(
            center: _center,
            zoom: 7.0,
          ),
        ),
        const MapboxCopyright(),
        Positioned(
          top: 8,
          left: 8,
          child: _MapScaleBar(zoom: _zoom),
        ),
        if (widget.overlayButtons != null) widget.overlayButtons!,
        const MapOverlayErrorInfoWidget(),
      ],
    );
  }
}

class _MapScaleBar extends StatelessWidget {
  final double zoom;
  static const _lat = 39.8; // Portugal centre latitude

  const _MapScaleBar({required this.zoom});

  @override
  Widget build(BuildContext context) {
    const targetWidth = 80.0;
    final metersPerPx =
        156543.03392 * cos(_lat * pi / 180) / pow(2, zoom);
    final targetMeters = targetWidth * metersPerPx;

    const steps = [
      10, 20, 50, 100, 200, 500, 1000, 2000, 5000,
      10000, 20000, 50000, 100000, 200000,
    ];
    final dist = steps.lastWhere((s) => s <= targetMeters,
        orElse: () => steps.first);
    final barWidth = dist / metersPerPx;
    final label = dist >= 1000 ? '${dist ~/ 1000} km' : '$dist m';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.75),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: barWidth,
            child: Row(children: [
              Container(width: 1, height: 6, color: Colors.black87),
              Expanded(child: Container(height: 2, color: Colors.black87)),
              Container(width: 1, height: 6, color: Colors.black87),
            ]),
          ),
          Text(label,
              style: const TextStyle(
                  fontSize: 10,
                  color: Colors.black87,
                  fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}
