import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:fogosmobile/actions/fires_actions.dart';
import 'package:fogosmobile/constants/variables.dart';
import 'package:fogosmobile/middleware/preferences_middleware.dart';
import 'package:fogosmobile/models/app_state.dart';
import 'package:fogosmobile/models/modis.dart';
import 'package:fogosmobile/models/viirs.dart';
import 'package:fogosmobile/screens/components/fire_details.dart';
import 'package:fogosmobile/screens/widgets/modis_modal.dart';
import 'package:fogosmobile/screens/widgets/viirs_modal.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:redux/redux.dart';

class HomePage extends StatefulWidget {
  const HomePage();
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final LatLng _center = LatLng(39.806251, -8.088591);
  final List<String> _stylesStrings = [
    MAPBOX_TEMPLATE_STYLE,
    MAPBOX_URL_SATTELITE_TEMPLATE,
  ];

  var currentMapboxTemplate = 0;

  MapboxMapController? _mapController;

  @override
  Widget build(BuildContext context) {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Firebase onMessage ${message.data}');
    });
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('Firebase onMessageOpenedApp ${message.toString()}');
      String fireId = message.data["fireId"];
      final store = StoreProvider.of<AppState>(context);
      store.dispatch(ClearFireAction());
      store.dispatch(LoadFireAction(fireId));
      _openModalSheet(context);
    });

    return StoreConnector<AppState, AppState>(
      converter: (Store<AppState> store) => store.state,
      builder: (BuildContext context, AppState state) {
        currentMapboxTemplate =
            state.preferences?[preferenceSatellite] == 1 ? 1 : 0;

        return Container();

        //TODO When we need to show Lightning
        //   MarkerStack<Lightning, LightningMarker,
        //       LightningMarkerState, void>(
        //     mapController: _mapController,
        //     data: state.lightnings,
        //   );

        // return ModalProgressHUD(
        //   opacity: 0.75,
        //   color: Colors.black,
        //   inAsyncCall: state.isLoading && state.selectedFire == null,
        //   child: Stack(
        //     children: <Widget>[
        //       MapboxMap(
        //         accessToken: MAPBOX_ACCESS_TOKEN,
        //         trackCameraPosition: true,
        //         myLocationEnabled: true,
        //         myLocationRenderMode: MyLocationRenderMode.GPS,
        //         onMapCreated: _onMapCreated,
        //         styleString: _stylesStrings[currentMapboxTemplate],
        //         initialCameraPosition: CameraPosition(
        //           target: _center,
        //           zoom: 7.0,
        //         ),
        //       ),
        //       MarkerStack<Fire, FireMarker, FireMarkerState, FireStatus>(
        //         mapController: _mapController,
        //         data: state.fires,
        //         filters: state.activeFilters,
        //         openModal: (_) {
        //           _openModalSheet(context);
        //         },
        //       ),
        //       if (state.showModis ?? false)
        //         MarkerStack<Modis, ModisMarker, ModisMarkerState, void>(
        //           mapController: _mapController,
        //           data: state.modis,
        //           openModal: (item) {
        //             _openModisModal(context, item);
        //           },
        //         ),
        //       if (state.showViirs ?? false)
        //         MarkerStack<Viirs, ViirsMarker, ViirsMarkerState, void>(
        //           mapController: _mapController,
        //           data: state.viirs,
        //           openModal: (item) {
        //             _openViirsModal(context, item);
        //           },
        //         ),
        //       MapboxCopyright(),
        //       Positioned(
        //         right: 0.0,
        //         top: 0.0,
        //         child: SafeArea(
        //           child: Column(
        //             children: [
        //               const MapButtonOverlayBackground(
        //                 child: const SatelliteButton(),
        //               ),
        //               const SizedBox(height: 24),
        //               const MapButtonOverlayBackground(
        //                 child: const ViirsButton(),
        //               ),
        //               const SizedBox(height: 24),
        //               const MapButtonOverlayBackground(
        //                 child: const ModisButton(),
        //               ),
        //             ],
        //           ),
        //         ),
        //       ),
        //       MapOverlayErrorInfoWidget(),
        //     ],
        //   ),
        // );
      },
    );
  }

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
}
