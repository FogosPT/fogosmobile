import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fogosmobile/actions/fires_actions.dart';
import 'package:fogosmobile/models/app_state.dart';
import 'package:fogosmobile/screens/assets/icons.dart';
import 'package:fogosmobile/screens/components/fire_details.dart';
import 'package:fogosmobile/screens/components/mapbox_copyright.dart';
import 'package:fogosmobile/screens/utils/widget_utils.dart';
import 'package:latlong/latlong.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:redux/redux.dart';

const fullPinSize = 50.0;

class HomePage extends StatelessWidget {
  final MapController mapController = new MapController();
  final LatLng _center = new LatLng(39.806251, -8.088591);
  final List<Marker> markers = [];

  @override
  Widget build(BuildContext context) {
    return new StoreConnector<AppState, List>(
      converter: (Store<AppState> store) => store.state.fires,
      builder: (BuildContext context, List fires) {
        if (fires != null) {
          for (final fire in fires) {
            markers.add(
              new Marker(
                width: fullPinSize * fire.scale,
                height: fullPinSize * fire.scale,
                point: new LatLng(fire.lat, fire.lng),
                builder: (_) => new StoreConnector<AppState, VoidCallback>(
                      converter: (Store<AppState> store) {
                        return () {
                          store.dispatch(new LoadFireAction(fire.id));
                        };
                      },
                      builder:
                          (BuildContext context, VoidCallback loadFireAction) {
                        return new StoreConnector<AppState, AppState>(
                          converter: (Store<AppState> store) => store.state,
                          builder: (BuildContext context, AppState state) {
                            return new Container(
                              decoration: BoxDecoration(
                                  color: getFireColor(fire.statusColor),
                                  shape: BoxShape.circle),
                              child: StoreConnector<AppState, VoidCallback>(
                                  converter: (Store<AppState> store) => () {
                                        store.dispatch(ClearFireAction());
                                      },
                                  builder: (BuildContext context, VoidCallback clearFireAction) {
                                    return new IconButton(
                                        icon: new SvgPicture.asset(
                                            getCorrectStatusImage(
                                                fire.statusCode,
                                                fire.important),
                                            semanticsLabel: 'Acme Logo'),
                                        onPressed: () async {
                                          loadFireAction();
                                          await showModalBottomSheet<void>(
                                            context: context,
                                            builder: (BuildContext context) =>
                                                FireDetails(),
                                          );
                                          clearFireAction();
                                        });
                                  }),
                            );
                          },
                        );
                      },
                    ),
              ),
            );
          }
        }

        return StoreConnector<AppState, AppState>(
            converter: (Store<AppState> store) => store.state,
            builder: (BuildContext context, AppState state) {
            return ModalProgressHUD(
              opacity: 0.75,
              color: Colors.black,
              inAsyncCall: state.isLoading,
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
          }
        );
      },
    );
  }

  String getCorrectStatusImage(int statusId, bool important) {
    var status = "status-";
    if (important) {
      status = status + "important";
    } else {
      status = status + statusId.toString();
    }
    switch (status) {
      case "status-important":
      case "status-5":
      case "status-7":
      case "status-99":
      case "status-8":
        return imgSvgIconFire;
      case "status-3":
      case "status-4":
        return imgSvgIconAlarm;
      case "status-9":
        return imgSvgIconWatch;
      case "status-6":
      case "status-10":
        return imgSvgIconPointer;
      case "status-11":
      case "status-12":
        return imgSvgIconFake;
      default:
        return imgSvgIconFire;
    }
  }
}
