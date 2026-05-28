import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fogosmobile/constants/ipma_layers.dart';
import 'package:fogosmobile/constants/variables.dart';
import 'package:fogosmobile/models/fire.dart';
import 'package:fogosmobile/models/modis.dart';
import 'package:fogosmobile/models/viirs.dart';
import 'package:fogosmobile/screens/components/mapbox_copyright.dart';
import 'package:fogosmobile/screens/widgets/fire_annotation_manager.dart';
import 'package:fogosmobile/screens/widgets/ipma_layer_manager.dart';
import 'package:fogosmobile/screens/widgets/ipma_legend_overlay.dart';
import 'package:fogosmobile/screens/widgets/kml_layer_manager.dart';
import 'package:fogosmobile/screens/widgets/map_overlay_error_info.dart';
import 'package:fogosmobile/screens/widgets/satellite_annotation_manager.dart';
import 'package:geolocator/geolocator.dart' show Geolocator;
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
  final Set<String> activeIpmaLayers;
  final String? ipmaReferenceTime;
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
    this.activeIpmaLayers = const {},
    this.ipmaReferenceTime,
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
  static const String _neutralStyle = 'mapbox://styles/mapbox/light-v11';

  MapboxMap? _mapController;
  FireAnnotationManager? _fireManager;
  SatelliteAnnotationManager? _satelliteManager;
  IpmaLayerManager? _ipmaManager;
  final Map<String, KmlLayerManager> _kmlVostManagers = {};
  KmlLayerManager? _kmlAreaManager;
  String? _lastAppliedStyle;
  bool _managersReady = false;
  double _zoom = 7.0;

  bool get _hasIpmaWmsActive => widget.activeIpmaLayers
      .any((k) => ipmaAromeGroups.any((g) => g.key == k));

  String get _currentStyle {
    if (_hasIpmaWmsActive) return _neutralStyle;
    return widget.useSatelliteStyle
        ? MAPBOX_URL_SATTELITE_TEMPLATE
        : MAPBOX_TEMPLATE_STYLE;
  }

  void _onMapCreated(MapboxMap mapboxMap) {
    _mapController = mapboxMap;
    _lastAppliedStyle = _currentStyle;
    _configureOrnaments();
    _enableLocationPuck();
  }

  void _configureOrnaments() {
    // Compass top-left, below the scale bar (~24px tall at top:8). Fades to
    // invisible when facing north so it doesn't clutter the map most of the
    // time. Top-right is taken by IPMA banner + layers button; bottom corners
    // are taken by copyright (right) and IPMA legend (left).
    _mapController!.compass.updateSettings(CompassSettings(
      enabled: true,
      position: OrnamentPosition.TOP_LEFT,
      marginLeft: 8,
      marginTop: 44,
      fadeWhenFacingNorth: true,
    ));
    // Native scale bar disabled — replaced by Flutter overlay widget.
    _mapController!.scaleBar.updateSettings(ScaleBarSettings(
      enabled: false,
    ));
  }

  Future<void> _enableLocationPuck() async {
    // Don't prompt for permission here — only enable the puck if the user has
    // *already* granted permission and turned location services on (typically
    // through the nearby-notifications opt-in). Avoids the system "enable
    // location" loop when services are off.
    final status = await Permission.locationWhenInUse.status;
    if (!status.isGranted) return;

    final serviceOn = await Geolocator.isLocationServiceEnabled();
    if (!serviceOn) return;

    if (_mapController == null) return;
    _mapController!.location.updateSettings(LocationComponentSettings(
      enabled: true,
      puckBearingEnabled: true,
    ));
  }

  void _onStyleLoaded(StyleLoadedEventData data) async {
    _managersReady = false;

    await _fireManager?.dispose();
    await _satelliteManager?.dispose();
    _ipmaManager = null;

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
    _ipmaManager = IpmaLayerManager(mapboxMap: _mapController!);

    _managersReady = true;

    _configureOrnaments();
    _syncAll();
  }

  void _updateStyleIfNeeded() {
    final next = _currentStyle;
    if (_mapController != null && next != _lastAppliedStyle) {
      _lastAppliedStyle = next;
      _mapController!.style.setStyleURI(next);
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

    if (widget.activeIpmaLayers != oldWidget.activeIpmaLayers ||
        widget.ipmaReferenceTime != oldWidget.ipmaReferenceTime) {
      _syncIpma();
    }
  }

  void _syncAll() {
    _syncIpma(reapply: true);
    _syncFires();
    _syncModis();
    _syncViirs();
    _syncKml();
    _syncKmlArea();
  }

  void _syncIpma({bool reapply = false}) {
    final desired = widget.activeIpmaLayers;
    final refTime = widget.ipmaReferenceTime;
    if (reapply) {
      _ipmaManager?.reapply(desired, referenceTime: refTime);
    } else {
      _ipmaManager?.sync(desired, referenceTime: refTime);
    }
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
          styleUri: _currentStyle,
          onMapCreated: _onMapCreated,
          onStyleLoadedListener: _onStyleLoaded,
          onCameraChangeListener: (_) {
            _mapController?.getCameraState().then((state) {
              if (!mounted) return;
              if (state.zoom != _zoom) setState(() => _zoom = state.zoom);
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
        const IpmaLegendOverlay(),
        if (_hasIpmaWmsActive && widget.ipmaReferenceTime != null)
          _IpmaRunBanner(referenceTime: widget.ipmaReferenceTime!),
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

class _IpmaRunBanner extends StatelessWidget {
  final String referenceTime;
  const _IpmaRunBanner({required this.referenceTime});

  static String _two(int n) => n < 10 ? '0$n' : '$n';

  @override
  Widget build(BuildContext context) {
    DateTime? local;
    try {
      final hasTz = referenceTime.endsWith('Z') ||
          RegExp(r'[+-]\d{2}:?\d{2}$').hasMatch(referenceTime);
      local = DateTime.parse(
              hasTz ? referenceTime : '${referenceTime}Z')
          .toLocal();
    } catch (_) {
      return const SizedBox.shrink();
    }
    final formatted = '${_two(local.day)}/${_two(local.month)}/${local.year} '
        '${_two(local.hour)}:${_two(local.minute)}';
    return Positioned(
      top: 8,
      right: 8,
      child: SafeArea(
        child: Container(
          padding:
              const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.85),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            'Corrida do modelo: $formatted (hora local)',
            style: const TextStyle(
              fontSize: 10,
              color: Colors.black87,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
