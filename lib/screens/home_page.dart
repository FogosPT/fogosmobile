import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:fogosmobile/actions/fires_actions.dart';
import 'package:fogosmobile/actions/planes_actions.dart';
import 'package:fogosmobile/middleware/preferences_middleware.dart';
import 'package:fogosmobile/models/app_state.dart';
import 'package:fogosmobile/models/fire.dart';
import 'package:fogosmobile/models/modis.dart';
import 'package:fogosmobile/models/plane.dart';
import 'package:fogosmobile/models/viirs.dart';
import 'package:fogosmobile/screens/components/fire_details.dart';
import 'package:fogosmobile/screens/widgets/fogos_map.dart';
import 'package:fogosmobile/screens/widgets/map_button_overlay_background.dart';
import 'package:fogosmobile/screens/widgets/map_layers_button.dart';
import 'package:fogosmobile/screens/widgets/modis_modal.dart';
import 'package:fogosmobile/screens/widgets/plane_modal.dart';
import 'package:fogosmobile/screens/widgets/viirs_modal.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:redux/redux.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Timer? _planesTimer;
  bool _planesTimerActive = false;

  static const _planesRefreshInterval = Duration(seconds: 60);

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

  _openPlaneModal(BuildContext context, Plane plane) async {
    await showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) => PlaneModal(plane: plane),
    );
  }

  void _syncPlanesTimer(Store<AppState> store, bool showPlanes) {
    if (showPlanes && !_planesTimerActive) {
      _planesTimerActive = true;
      _planesTimer =
          Timer.periodic(_planesRefreshInterval, (_) {
        store.dispatch(LoadPlanesAction());
      });
    } else if (!showPlanes && _planesTimerActive) {
      _planesTimerActive = false;
      _planesTimer?.cancel();
      _planesTimer = null;
    }
  }

  @override
  void dispose() {
    _planesTimer?.cancel();
    _planesTimer = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppState>(
      converter: (Store<AppState> store) => store.state,
      builder: (BuildContext context, AppState state) {
        _syncPlanesTimer(StoreProvider.of<AppState>(context), state.showPlanes);
        return ModalProgressHUD(
          opacity: 0.75,
          color: Colors.black,
          inAsyncCall: state.isLoading && state.selectedFire == null,
          child: FogosMap(
            fires: state.fires,
            fireFilters: state.activeFilters,
            modis: state.modis,
            viirs: state.viirs,
            planes: state.planes,
            showModis: state.showModis ?? false,
            showViirs: state.showViirs ?? false,
            showPlanes: state.showPlanes,
            showNatureCodes: state.showNatureCodes,
            useSatelliteStyle:
                state.preferences[preferenceSatellite] == 1,
            activeIpmaLayers: state.activeIpmaLayers,
            ipmaReferenceTime: state.ipmaReferenceTime,
            kmlVostUrls: state.fires
                .where((f) => f.kmlVost != null)
                .map((f) => f.kmlVost!)
                .toList(),
            kmlAreaUrl: state.selectedFire?.kml,
            onFireTap: (Fire fire) {
              final store = StoreProvider.of<AppState>(context);
              store.dispatch(ClearFireAction());
              store.dispatch(LoadFireAction(fire.id));
              _openModalSheet(context);
            },
            onModisTap: (Modis modis) {
              _openModisModal(context, modis);
            },
            onViirsTap: (Viirs viirs) {
              _openViirsModal(context, viirs);
            },
            onPlaneTap: (Plane plane) {
              _openPlaneModal(context, plane);
            },
            overlayButtons: Positioned(
              right: 0.0,
              top: 0.0,
              child: SafeArea(
                child: Column(
                  children: [
                    const SizedBox(height: 40),
                    const MapButtonOverlayBackground(
                      child: const MapLayersButton(),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
