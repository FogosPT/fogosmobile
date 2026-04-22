import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:fogosmobile/actions/fires_actions.dart';
import 'package:fogosmobile/middleware/preferences_middleware.dart';
import 'package:fogosmobile/models/app_state.dart';
import 'package:fogosmobile/models/fire.dart';
import 'package:fogosmobile/models/modis.dart';
import 'package:fogosmobile/models/viirs.dart';
import 'package:fogosmobile/screens/components/fire_details.dart';
import 'package:fogosmobile/screens/widgets/fogos_map.dart';
import 'package:fogosmobile/screens/widgets/map_button_overlay_background.dart';
import 'package:fogosmobile/screens/widgets/map_layers_button.dart';
import 'package:fogosmobile/screens/widgets/modis_modal.dart';
import 'package:fogosmobile/screens/widgets/viirs_modal.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:redux/redux.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
    return StoreConnector<AppState, AppState>(
      converter: (Store<AppState> store) => store.state,
      builder: (BuildContext context, AppState state) {
        return ModalProgressHUD(
          opacity: 0.75,
          color: Colors.black,
          inAsyncCall: state.isLoading && state.selectedFire == null,
          child: FogosMap(
            fires: state.fires,
            fireFilters: state.activeFilters,
            modis: state.modis,
            viirs: state.viirs,
            showModis: state.showModis ?? false,
            showViirs: state.showViirs ?? false,
            showNatureCodes: state.showNatureCodes,
            useSatelliteStyle:
                state.preferences[preferenceSatellite] == 1,
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
