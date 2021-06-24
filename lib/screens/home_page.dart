import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:fogosmobile/actions/fires_actions.dart';
import 'package:fogosmobile/constants/variables.dart';
import 'package:fogosmobile/middleware/preferences_middleware.dart';
import 'package:fogosmobile/models/app_state.dart';
import 'package:fogosmobile/models/fire.dart';
import 'package:fogosmobile/models/modis.dart';
import 'package:fogosmobile/models/viirs.dart';
import 'package:fogosmobile/screens/components/fire_details.dart';
import 'package:fogosmobile/screens/components/mapbox_copyright.dart';
import 'package:fogosmobile/screens/widgets/map_button_overlay_background.dart';
import 'package:fogosmobile/screens/widgets/map_overlay_error_info.dart';
import 'package:fogosmobile/screens/widgets/mapbox_markers/marker_fire.dart';
import 'package:fogosmobile/screens/widgets/mapbox_markers/marker_modis.dart';
import 'package:fogosmobile/screens/widgets/mapbox_markers/marker_viirs.dart';
import 'package:fogosmobile/screens/widgets/markers_stack.dart';
import 'package:fogosmobile/screens/widgets/modis_button.dart';
import 'package:fogosmobile/screens/widgets/modis_modal.dart';
import 'package:fogosmobile/screens/widgets/satellite_button.dart';
import 'package:fogosmobile/screens/widgets/viirs_button.dart';
import 'package:fogosmobile/screens/widgets/viirs_modal.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:redux/redux.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final LatLng _center = LatLng(39.806251, -8.088591);
  final List<String> _stylesStrings = [
    MAPBOX_TEMPLATE_STYLE,
    MAPBOX_URL_SATTELITE_TEMPLATE
  ];

  var currentMapboxTemplate = 0;

  MapboxMapController _mapController;

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  void _onMapCreated(MapboxMapController controller) {
    _mapController = controller;
  }

  _openModalSheet(context) async {
    await showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) => FireDetails(),
    );
  }

  _openModisModal(BuildContext context, Modis modis) async {
    await showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) => ModisModal(modis: modis),
    );
  }

  _openViirsModal(BuildContext context, Viirs viirs) async {
    await showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) => ViirsModal(viirs: viirs),
    );
  }

  @override
  Widget build(BuildContext context) {
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print('on message $message');
      },
      onResume: (Map<String, dynamic> message) async {
        print('on resume $message');
        String fireId = message["data"]["fireId"];
        if (fireId != null) {
          final store = StoreProvider.of<AppState>(context);
          store.dispatch(ClearFireAction());
          store.dispatch(LoadFireAction(fireId));
          _openModalSheet(context);
        }
      },
      onLaunch: (Map<String, dynamic> message) async {},
    );

    return StoreConnector<AppState, AppState>(
      converter: (Store<AppState> store) => store.state,
      builder: (BuildContext context, AppState state) {
        currentMapboxTemplate =
            state.preferences[preferenceSatellite] == 1 ? 1 : 0;

        //TODO When we need to show Lightning
        //   MarkerStack<Lightning, LightningMarker,
        //       LightningMarkerState, void>(
        //     mapController: _mapController,
        //     data: state.lightnings,
        //   );

        return ModalProgressHUD(
          opacity: 0.75,
          color: Colors.black,
          inAsyncCall: state.isLoading && state.selectedFire == null,
          child: Stack(
            children: <Widget>[
              MapboxMap(
                accessToken: MAPBOX_ACCESS_TOKEN,
                trackCameraPosition: true,
                myLocationEnabled: true,
                myLocationRenderMode: MyLocationRenderMode.GPS,
                onMapCreated: _onMapCreated,
                styleString: _stylesStrings[currentMapboxTemplate],
                initialCameraPosition: CameraPosition(
                  target: _center,
                  zoom: 7.0,
                ),
              ),
              MarkerStack<Fire, FireMarker, FireMarkerState, FireStatus>(
                mapController: _mapController,
                data: state.fires,
                filters: state.activeFilters,
                openModal: (_) {
                  _openModalSheet(context);
                },
              ),
              if (state.showModis ?? false)
                MarkerStack<Modis, ModisMarker, ModisMarkerState, void>(
                  mapController: _mapController,
                  data: state.modis,
                  openModal: (item) {
                    _openModisModal(context, item);
                  },
                ),
              if (state.showViirs ?? false)
                MarkerStack<Viirs, ViirsMarker, ViirsMarkerState, void>(
                  mapController: _mapController,
                  data: state.viirs,
                  openModal: (item) {
                    _openViirsModal(context, item);
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
                      const SizedBox(height: 24),
                      const MapButtonOverlayBackground(
                        child: const ViirsButton(),
                      ),
                      const SizedBox(height: 24),
                      const MapButtonOverlayBackground(
                        child: const ModisButton(),
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
    );
  }
}
