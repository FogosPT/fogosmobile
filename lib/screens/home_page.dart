import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fogosmobile/actions/fires_actions.dart';
import 'package:fogosmobile/models/app_state.dart';
import 'package:fogosmobile/models/fire.dart';
import 'package:fogosmobile/screens/components/fire_details.dart';
import 'package:fogosmobile/screens/components/mapbox_copyright.dart';
import 'package:fogosmobile/screens/utils/widget_utils.dart';
import 'package:latlong/latlong.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:redux/redux.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

const fullPinSize = 50.0;

class HomePage extends StatelessWidget {
  final MapController mapController = new MapController();
  final LatLng _center = new LatLng(39.806251, -8.088591);
  final List<Marker> markers = [];
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  _openModalSheet(context) async {
    await showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) => FireDetails(),
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
        String fireId = message["fireId"];
        final store = StoreProvider.of<AppState>(context);
        store.dispatch(LoadFireAction(fireId));
        _openModalSheet(context);
        store.dispatch(ClearFireAction());
      },
      onLaunch: (Map<String, dynamic> message) async {
        print('on launch $message');
      },
    );

    return new StoreConnector<AppState, AppState>(
      converter: (Store<AppState> store) => store.state,
      builder: (BuildContext context, AppState state) {
        final store = StoreProvider.of<AppState>(context);

        if (state.fires != null) {
          for (final Fire fire in state.fires) {
            if (state.activeFilters.isEmpty ||
                state.activeFilters.contains(fire.status)) {
              markers.add(
                new Marker(
                  width: fullPinSize * fire.scale,
                  height: fullPinSize * fire.scale,
                  point: new LatLng(fire.lat, fire.lng),
                  builder: (BuildContext context) {
                    return new Container(
                      decoration: BoxDecoration(
                          color: getFireColor(fire.statusColor),
                          shape: BoxShape.circle),
                      child: IconButton(
                        icon: new SvgPicture.asset(
                            getCorrectStatusImage(
                                fire.statusCode, fire.important),
                            semanticsLabel: 'Acme Logo'),
                        onPressed: () async {
                          store.dispatch(LoadFireAction(fire.id));
                          _openModalSheet(context);
                          store.dispatch(ClearFireAction());
                        },
                      ),
                    );
                  },
                ),
              );
            }
          }
        }

        return StoreConnector<AppState, AppState>(
            converter: (Store<AppState> store) => store.state,
            builder: (BuildContext context, AppState state) {
              return ModalProgressHUD(
                opacity: 0.75,
                color: Colors.black,
                inAsyncCall: state.isLoading && state.fire == null,
                child: Stack(
                  children: <Widget>[
                    new FlutterMap(
                      mapController: mapController,
                      options: new MapOptions(
                        center: _center,
                        zoom: 7.0,
                      ),
                      layers: [
                        new TileLayerOptions(
                          urlTemplate:
                              "https://api.mapbox.com/styles/v1/fogospt/cjgppvcdp00aa2spjclz9sjst/tiles/256/{z}/{x}/{y}?access_token={accessToken}",
                          additionalOptions: {
                            'accessToken':
                                'pk.eyJ1IjoiZm9nb3NwdCIsImEiOiJjamZ3Y2E5OTMyMjFnMnFxbjAxbmt3bmdtIn0.xg1X-A17WRBaDghhzsmjIA',
                            'id': 'mapbox.streets',
                          },
                        ),
                        new MarkerLayerOptions(
                          markers: markers,
                        ),
                      ],
                    ),
                    MapboxCopyright(),
                  ],
                ),
              );
            });
      },
    );
  }
}
