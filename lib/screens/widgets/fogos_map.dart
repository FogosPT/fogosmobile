import 'package:flutter/material.dart';
import 'package:fogosmobile/constants/variables.dart';
import 'package:fogosmobile/models/fire.dart';
import 'package:fogosmobile/models/modis.dart';
import 'package:fogosmobile/models/viirs.dart';
import 'package:fogosmobile/screens/components/mapbox_copyright.dart';
import 'package:fogosmobile/screens/widgets/fire_annotation_manager.dart';
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
  final bool useSatelliteStyle;
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
    this.useSatelliteStyle = false,
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
  int _lastAppliedTemplate = -1;
  bool _managersReady = false;
  bool _pendingSync = false;

  int get _templateIndex => widget.useSatelliteStyle ? 1 : 0;

  void _onMapCreated(MapboxMap mapboxMap) {
    _mapController = mapboxMap;
    _configureOrnaments();
    _enableLocationPuck();
  }

  void _configureOrnaments() {
    // Move compass to top-left so it doesn't overlap the overlay buttons (top-right)
    _mapController!.compass.updateSettings(CompassSettings(
      position: OrnamentPosition.TOP_LEFT,
      marginTop: 16,
      marginLeft: 16,
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

    // Dispose old managers
    await _fireManager?.dispose();
    await _satelliteManager?.dispose();

    if (_mapController == null || !mounted) return;

    // Create new managers
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

    _managersReady = true;

    // Sync all data now
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

    if (!_managersReady) {
      // Managers not ready yet — data will be synced when they are
      return;
    }

    if (widget.fires != oldWidget.fires ||
        widget.fireFilters != oldWidget.fireFilters) {
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
  }

  void _syncAll() {
    _syncFires();
    _syncModis();
    _syncViirs();
  }

  void _syncFires() {
    _fireManager?.syncFires(widget.fires, widget.fireFilters);
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

  @override
  void dispose() {
    _fireManager?.dispose();
    _satelliteManager?.dispose();
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
          cameraOptions: CameraOptions(
            center: _center,
            zoom: 7.0,
          ),
        ),
        const MapboxCopyright(),
        if (widget.overlayButtons != null) widget.overlayButtons!,
        const MapOverlayErrorInfoWidget(),
      ],
    );
  }
}
