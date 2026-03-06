import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:fogosmobile/actions/all_incidents_actions.dart';
import 'package:fogosmobile/actions/fires_actions.dart';
import 'package:fogosmobile/middleware/preferences_middleware.dart';
import 'package:fogosmobile/models/app_state.dart';
import 'package:fogosmobile/models/fire.dart';
import 'package:fogosmobile/screens/components/fire_details.dart';
import 'package:fogosmobile/screens/widgets/fogos_map.dart';
import 'package:fogosmobile/screens/widgets/map_button_overlay_background.dart';
import 'package:fogosmobile/screens/widgets/satellite_button.dart';
import 'package:fogosmobile/screens/components/fire_gradient_app_bar.dart';
import 'package:fogosmobile/localization/fogos_localizations.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:redux/redux.dart';

class AllIncidentsPage extends StatefulWidget {
  @override
  _AllIncidentsPageState createState() => _AllIncidentsPageState();
}

class _AllIncidentsPageState extends State<AllIncidentsPage> {
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
          return ModalProgressHUD(
            opacity: 0.75,
            color: Colors.black,
            inAsyncCall: state.isLoading && state.allIncidents.isEmpty,
            child: FogosMap(
              fires: state.allIncidents,
              fireFilters: state.activeFilters,
              useSatelliteStyle:
                  state.preferences[preferenceSatellite] == 1,
              onFireTap: (Fire fire) {
                final store = StoreProvider.of<AppState>(context);
                store.dispatch(ClearFireAction());
                store.dispatch(LoadFireAction(fire.id));
                _openModalSheet(context);
              },
              overlayButtons: Positioned(
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
            ),
          );
        },
      ),
    );
  }
}
