import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fogosmobile/actions/fires_actions.dart';
import 'package:fogosmobile/models/app_state.dart';
import 'package:fogosmobile/models/base_location_model.dart';
import 'package:fogosmobile/models/fire.dart';
import 'package:fogosmobile/models/modis.dart';
import 'package:fogosmobile/models/viirs.dart';
import 'package:fogosmobile/screens/widgets/mapbox_markers/marker_base.dart';
import 'package:fogosmobile/screens/widgets/mapbox_markers/marker_fire.dart';
import 'package:fogosmobile/screens/widgets/mapbox_markers/marker_modis.dart';
import 'package:fogosmobile/screens/widgets/mapbox_markers/marker_viirs.dart';
import 'package:fogosmobile/screens/utils/widget_utils.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

class MarkerStack<T extends BaseMapboxModel, V extends BaseMarker,
    B extends BaseMarkerState, F> extends StatefulWidget {
  final bool ignoreTouch;
  final MapboxMap? mapController;
  final List<T> data;
  final void Function(dynamic item)? openModal;
  final List<F>? filters;

  MarkerStack({
    required this.mapController,
    required this.data,
    this.ignoreTouch = false,
    this.openModal,
    this.filters,
    GlobalKey<MarkerStackState>? key,
  }) : super(key: key);

  @override
  MarkerStackState createState() => MarkerStackState<T, V, B, F>();
}

class MarkerStackState<T extends BaseMapboxModel, V extends BaseMarker,
    B extends BaseMarkerState, F> extends State<MarkerStack> {
  final Map<String, _MarkerData> _markerData = {};
  bool _isUpdating = false;

  @override
  void initState() {
    super.initState();
    // Initial position calculation after first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _rebuildMarkers();
    });
  }

  @override
  void didUpdateWidget(covariant MarkerStack oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.data != oldWidget.data ||
        widget.mapController != oldWidget.mapController) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _rebuildMarkers();
      });
    }
  }

  void updatePositions() {
    _updateAllScreenPositions();
  }

  void _rebuildMarkers() async {
    if (!mounted || widget.mapController == null) return;
    if (_isUpdating) return;
    _isUpdating = true;

    try {
      final filteredData = widget.data
          .where((value) => !value.skip(widget.filters ?? []))
          .toList();

      final newMarkerData = <String, _MarkerData>{};

      for (final item in filteredData) {
        final id = item.getId;
        final location = item.location;
        final screenCoord =
            await widget.mapController!.pixelForCoordinate(location);

        newMarkerData[id] = _MarkerData(
          item: item,
          location: location,
          screenPosition: screenCoord,
        );
      }

      if (mounted) {
        setState(() {
          _markerData.clear();
          _markerData.addAll(newMarkerData);
        });
      }
    } finally {
      _isUpdating = false;
    }
  }

  void _updateAllScreenPositions() async {
    if (!mounted || widget.mapController == null || _markerData.isEmpty) return;
    if (_isUpdating) return;
    _isUpdating = true;

    try {
      for (final entry in _markerData.entries) {
        if (!mounted) break;
        final screenCoord =
            await widget.mapController!.pixelForCoordinate(entry.value.location);
        entry.value.screenPosition = screenCoord;
      }

      if (mounted) {
        setState(() {});
      }
    } finally {
      _isUpdating = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: widget.ignoreTouch,
      child: Stack(
        children: _markerData.entries.map((entry) {
          return _buildMarker(entry.value);
        }).toList(),
      ),
    );
  }

  Widget _buildMarker(_MarkerData data) {
    final pos = data.screenPosition;
    final item = data.item;

    if (V == FireMarker) {
      final fire = item as Fire;
      final size = _getFireIconSize(fire.scale);
      return Positioned(
        left: pos.x - size / 2,
        top: pos.y - size / 2,
        child: _FireMarkerWidget(
          fire: fire,
          size: size,
          openModal: widget.openModal,
        ),
      );
    } else if (V == ModisMarker) {
      final modis = item as Modis;
      return Positioned(
        left: pos.x - 15,
        top: pos.y - 15,
        child: _SimpleMarkerWidget(
          label: 'M',
          onTap: () => widget.openModal?.call(modis),
        ),
      );
    } else if (V == ViirsMarker) {
      final viirs = item as Viirs;
      return Positioned(
        left: pos.x - 15,
        top: pos.y - 15,
        child: _SimpleMarkerWidget(
          label: 'V',
          onTap: () => widget.openModal?.call(viirs),
        ),
      );
    }

    return const SizedBox.shrink();
  }

  double _getFireIconSize(double scale) {
    double pinSize = 30.0 * scale;
    if (pinSize == 0 || pinSize < 20) {
      pinSize = 20.0;
    }
    if (pinSize > 40) {
      pinSize = 40.0;
    }
    return pinSize;
  }
}

class _MarkerData {
  final dynamic item;
  final Point location;
  ScreenCoordinate screenPosition;

  _MarkerData({
    required this.item,
    required this.location,
    required this.screenPosition,
  });
}

class _FireMarkerWidget extends StatelessWidget {
  final Fire fire;
  final double size;
  final void Function(dynamic)? openModal;

  const _FireMarkerWidget({
    required this.fire,
    required this.size,
    this.openModal,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        final store = StoreProvider.of<AppState>(context);
        store.dispatch(ClearFireAction());
        store.dispatch(LoadFireAction(fire.id));
        openModal?.call(fire);
      },
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: getFireColor(fire),
          shape: BoxShape.circle,
        ),
        child: Center(
          child: SvgPicture.asset(
            getCorrectStatusImage(fire.statusCode, fire.important),
            width: size * 0.6,
            height: size * 0.6,
            semanticsLabel: 'Fire Marker',
          ),
        ),
      ),
    );
  }
}

class _SimpleMarkerWidget extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;

  const _SimpleMarkerWidget({
    required this.label,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          color: Colors.amberAccent,
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }
}
