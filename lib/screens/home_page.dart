import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fogosmobile/actions/fires_actions.dart';
import 'package:fogosmobile/actions/preferences_actions.dart';
import 'package:fogosmobile/localization/fogos_localizations.dart';
import 'package:fogosmobile/middleware/preferences_middleware.dart';
import 'package:fogosmobile/models/app_state.dart';
import 'package:fogosmobile/models/fire.dart';
import 'package:fogosmobile/models/lightning.dart';
import 'package:fogosmobile/screens/components/fire_details.dart';
import 'package:fogosmobile/screens/components/mapbox_copyright.dart';
import 'package:fogosmobile/screens/utils/widget_utils.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:latlong/latlong.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:redux/redux.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:fogosmobile/constants/variables.dart';

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

  Widget _getSatelliteButton(state, context) {
    List<Widget> widgets = [
      IconButton(
        icon: Icon(Icons.satellite),
        onPressed: () {
          final store = StoreProvider.of<AppState>(context);
          store.dispatch(SetPreferenceAction(
              'satellite', state.preferences['pref-satellite'] == 1 ? 0 : 1));
        },
      ),
    ];

    if (state.preferences['pref-satellite'] == 1) {
      widgets.add(Positioned(
        bottom: 5,
        right: 5,
        child: Icon(
          Icons.check_circle,
          size: 18,
          color: Colors.green,
        ),
      ));
    }

    return Stack(
      children: widgets,
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
        store.dispatch(ClearFireAction());
        store.dispatch(LoadFireAction(fireId));
        _openModalSheet(context);
      },
      onLaunch: (Map<String, dynamic> message) async {
        print('on launch $message');
      },
    );

    return new StoreConnector<AppState, AppState>(
      converter: (Store<AppState> store) => store.state,
      builder: (BuildContext context, AppState state) {
        final store = StoreProvider.of<AppState>(context);

        Widget overlayWidget = Container();

        if (state.fires.length < 1) {
          if (state.errors != null && state.errors.contains('fires')) {
            overlayWidget = Center(
              child: Container(
                height: 150,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4.0),
                  color: Colors.black54,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        FogosLocalizations.of(context).textProblemLoadingData,
                        style: TextStyle(color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        FogosLocalizations.of(context).textInternetConnection,
                        style: TextStyle(color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
        }

        if (state.fires != null) {
          for (final Fire fire in state.fires) {
            if (state.activeFilters.contains(fire.status)) {
              double pinSize = fullPinSize * fire.scale;

              if (pinSize == 0) {
                pinSize = fullPinSize;
              }

              markers.add(
                new Marker(
                  width: pinSize,
                  height: pinSize,
                  point: new LatLng(fire.lat, fire.lng),
                  builder: (BuildContext context) {
                    return new Container(
                      decoration: BoxDecoration(
                          color: getFireColor(fire), shape: BoxShape.circle),
                      child: IconButton(
                        icon: new SvgPicture.asset(
                            getCorrectStatusImage(
                                fire.statusCode, fire.important),
                            semanticsLabel: 'Acme Logo'),
                        onPressed: () async {
                          store.dispatch(ClearFireAction());
                          store.dispatch(LoadFireAction(fire.id));
                          _openModalSheet(context);
                        },
                      ),
                    );
                  },
                ),
              );
            }
          }
        }

        if (state.lightnings?.isNotEmpty ?? false) {
          for (final Lightning lightning in state.lightnings) {
            print(
                "Adding lightning on ${lightning.payload.latitude}, ${lightning.payload.longitude}");
            markers.add(
              new Marker(
                width: fullPinSize * 0.65,
                height: fullPinSize * 0.65,
                point: new LatLng(
                    lightning.payload.latitude, lightning.payload.longitude),
                builder: (BuildContext context) {
                  return new Container(
                    decoration: BoxDecoration(
                        color: Colors.purpleAccent, shape: BoxShape.circle),
                    child: IconButton(
                      icon: Center(
                        child: FaIcon(
                          FontAwesomeIcons.bolt,
                          size: fullPinSize * 0.33,
                          color: Colors.white,
                        ),
                      ),
                      onPressed: () async {
                        // todo: Add the action
                      },
                    ),
                  );
                },
              ),
            );
          }
        }

        String mapboxUrlTemplate;
        String mapboxId;

        if (state.preferences[preferenceSatellite] == 1) {
          mapboxUrlTemplate = MAPBOX_URL_SATTELITE_TEMPLATE;
          mapboxId = MAPBOX_SATTELITE_ID;
        } else {
          mapboxUrlTemplate = MAPBOX_URL_TEMPLATE;
          mapboxId = MAPBOX_ID;
        }

        return ModalProgressHUD(
          opacity: 0.75,
          color: Colors.black,
          inAsyncCall: state.isLoading && state.fire == null,
          child: Stack(
            children: <Widget>[
              new FlutterMap(
                key: Key(mapboxId),
                mapController: mapController,
                options: new MapOptions(
                  center: _center,
                  zoom: 7.0,
                  minZoom: 1.0,
                  maxZoom: 20.0,
                ),
                layers: [
                  new TileLayerOptions(
                    urlTemplate: mapboxUrlTemplate,
                    additionalOptions: {
                      'accessToken': MAPBOX_ACCESS_TOKEN,
                      'id': mapboxId,
                    },
                  ),
                  new MarkerLayerOptions(
                    markers: markers,
                  ),
                ],
              ),
              MapboxCopyright(),
              Positioned(
                right: 0.0,
                top: 0.0,
                child: SafeArea(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.only(bottomLeft: Radius.circular(14.0)),
                      color: Colors.white54,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: _getSatelliteButton(state, context),
                    ),
                  ),
                ),
              ),
              overlayWidget
            ],
          ),
        );
      },
    );
  }
}
