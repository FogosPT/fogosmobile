import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:fogosmobile/actions/all_incidents_actions.dart';
import 'package:fogosmobile/constants/variables.dart';
import 'package:fogosmobile/localization/fogos_localizations.dart';
import 'package:fogosmobile/middleware/preferences_middleware.dart';
import 'package:fogosmobile/models/app_state.dart';
import 'package:fogosmobile/models/fire.dart';
import 'package:fogosmobile/screens/components/fire_details.dart';
import 'package:fogosmobile/screens/components/mapbox_copyright.dart';
import 'package:fogosmobile/screens/widgets/map_button_overlay_background.dart';
import 'package:fogosmobile/screens/widgets/map_overlay_error_info.dart';
import 'package:fogosmobile/screens/widgets/mapbox_markers/marker_fire.dart';
import 'package:fogosmobile/screens/widgets/markers_stack.dart';
import 'package:fogosmobile/screens/widgets/satellite_button.dart';
import 'package:fogosmobile/screens/components/fire_gradient_app_bar.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:redux/redux.dart';

class AllIncidentsPage extends StatefulWidget {
  @override
  _AllIncidentsPageState createState() => _AllIncidentsPageState();
}

class _AllIncidentsPageState extends State<AllIncidentsPage> {
  final Point _center = Point(coordinates: Position(-8.088591, 39.806251));
  final List<String> _stylesStrings = [
    MAPBOX_TEMPLATE_STYLE,
    MAPBOX_URL_SATTELITE_TEMPLATE
  ];

  var currentMapboxTemplate = 0;
  var _lastAppliedTemplate = -1;

  MapboxMap? _mapController;

  final _fireMarkerKey = GlobalKey<MarkerStackState>();

  void _onCameraChanged(CameraChangedEventData data) {
    _fireMarkerKey.currentState?.updatePositions();
  }

  void _onMapCreated(MapboxMap mapboxMap) {
    _mapController = mapboxMap;
    _mapController?.location.updateSettings(LocationComponentSettings(
      enabled: true,
      puckBearingEnabled: true,
    ));
  }

  void _updateStyleIfNeeded(int templateIndex) {
    if (_mapController != null && templateIndex != _lastAppliedTemplate) {
      _lastAppliedTemplate = templateIndex;
      _mapController!.style.setStyleURI(_stylesStrings[templateIndex]);
    }
  }

  _openModalSheet(context) async {
    await showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) => FireDetails(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: FireGradientAppBar(
        title: Text(
          FogosLocalizations.of(context).textAllIncidents,
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          StoreConnector<AppState, VoidCallback>(
            converter: (Store<AppState> store) {
              return () => store.dispatch(LoadAllIncidentsAction());
            },
            builder: (BuildContext context, VoidCallback loadAction) {
              return StoreConnector<AppState, AppState>(
                converter: (Store<AppState> store) => store.state,
                builder: (BuildContext context, AppState state) {
                  return state.isLoading
                      ? SizedBox(
                          width: 48,
                          height: 48,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: CircularProgressIndicator(strokeWidth: 2.0),
                          ),
                        )
                      : IconButton(
                          onPressed: loadAction,
                          icon: Icon(Icons.refresh),
                        );
                },
              );
            },
          ),
        ],
      ),
      body: StoreConnector<AppState, AppState>(
        converter: (Store<AppState> store) => store.state,
        onInit: (Store<AppState> store) {
          store.dispatch(LoadAllIncidentsAction());
        },
        builder: (BuildContext context, AppState state) {
          currentMapboxTemplate =
              state.preferences[preferenceSatellite] == 1 ? 1 : 0;

          _updateStyleIfNeeded(currentMapboxTemplate);

          return ModalProgressHUD(
            opacity: 0.75,
            color: Colors.black,
            inAsyncCall: state.isLoading && state.allIncidents.isEmpty,
            child: Stack(
              children: <Widget>[
                MapWidget(
                  styleUri: _stylesStrings[currentMapboxTemplate],
                  onMapCreated: _onMapCreated,
                  onCameraChangeListener: _onCameraChanged,
                  cameraOptions: CameraOptions(
                    center: _center,
                    zoom: 7.0,
                  ),
                ),
                MarkerStack<Fire, FireMarker, FireMarkerState, FireStatus>(
                  key: _fireMarkerKey,
                  mapController: _mapController,
                  data: state.allIncidents,
                  filters: state.activeFilters,
                  openModal: (_) {
                    _openModalSheet(context);
                  },
                ),
                const MapboxCopyright(),
                Positioned(
                  right: 0.0,
                  top: 0.0,
                  child: SafeArea(
                    child: Column(
                      children: [
                        const MapButtonOverlayBackground(
                          child: const SatelliteButton(),
                        ),
                      ],
                    ),
                  ),
                ),
                const MapOverlayErrorInfoWidget(),
              ],
            ),
          );
        },
      ),
    );
  }
}
