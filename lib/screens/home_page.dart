import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fogosmobile/actions/fires_actions.dart';
import 'package:fogosmobile/actions/modis_actions.dart';
import 'package:fogosmobile/actions/preferences_actions.dart';
import 'package:fogosmobile/actions/viirs_actions.dart';
import 'package:fogosmobile/localization/fogos_localizations.dart';
import 'package:fogosmobile/middleware/preferences_middleware.dart';
import 'package:fogosmobile/models/app_state.dart';
import 'package:fogosmobile/models/fire.dart';
import 'package:fogosmobile/models/modis.dart';
import 'package:fogosmobile/models/viirs.dart';
import 'package:fogosmobile/screens/components/fire_details.dart';
import 'package:fogosmobile/screens/components/mapbox_copyright.dart';
import 'package:fogosmobile/screens/utils/widget_utils.dart';
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

        if (state.modis != null && (state.showModis ?? false)) {
          for (final Modis modis in state.modis) {
            if (modis.latitude == null || modis.longitude == null) {
              continue;
            }
            markers.add(
              new Marker(
                point: new LatLng(modis.latitude, modis.longitude),
                builder: (BuildContext context) {
                  return GestureDetector(
                    onTap: () => _openModisModal(context, modis),
                    child: new Container(
                        decoration: BoxDecoration(
                            color: Colors.amberAccent, shape: BoxShape.circle),
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Text(
                              "M",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18),
                            ),
                          ),
                        )),
                  );
                },
              ),
            );
          }
        }

        if (state.viirs != null && (state.showViirs ?? false)) {
          for (final Viirs viirs in state.viirs) {
            if (viirs.latitude == null || viirs.longitude == null) {
              continue;
            }
            markers.add(
              new Marker(
                point: new LatLng(viirs.latitude, viirs.longitude),
                builder: (BuildContext context) {
                  return GestureDetector(
                    onTap: () => _openViirsModal(context, viirs),
                    child: new Container(
                        decoration: BoxDecoration(
                            color: Colors.amberAccent, shape: BoxShape.circle),
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Text(
                              "V",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18),
                            ),
                          ),
                        )),
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
              FlutterMap(
                mapController: mapController,
                options: MapOptions(
                  center: _center,
                  zoom: 7.0,
                  minZoom: 1.0,
                  maxZoom: 20.0,
                ),
                layers: [
                  TileLayerOptions(
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
                  child: Column(
                    children: [
                      _getBakcground(
                        _getSatelliteButton(state, context),
                      ),
                      SizedBox(
                        height: 24,
                      ),
                      _getBakcground(_getViirsButton(state, context)),
                      SizedBox(
                        height: 24,
                      ),
                      _getBakcground(_getModisButton(state, context)),
                    ],
                  ),
                ),
              ),
              overlayWidget,
            ],
          ),
        );
      },
    );
  }

  Widget _getBakcground(Widget child) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(14.0)),
        color: Colors.white54,
      ),
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: child,
      ),
    );
  }

  Widget _getSatelliteButton(state, context) {
    var currentPreferenceState = state.preferences[preferenceSatellite];
    return Stack(
      children: [
        IconButton(
          icon: Icon(Icons.satellite),
          onPressed: () {
            print("Current ${currentPreferenceState}");
            print(
                "Pressed the button to dispatch ${currentPreferenceState == 1 ? 0 : 1}");
            StoreProvider.of<AppState>(context).dispatch(SetPreferenceAction(
                preferenceSatellite, currentPreferenceState == 1 ? 0 : 1));
          },
        ),
        if (currentPreferenceState == 1)
          Positioned(
            bottom: 5,
            right: 5,
            child: Icon(
              Icons.check_circle,
              size: 18,
              color: Colors.green,
            ),
          )
      ],
    );
  }

  Widget _getViirsButton(AppState state, context) {
    return InkWell(
      onTap: () =>
          StoreProvider.of<AppState>(context).dispatch(ShowViirsAction()),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 16.0,
              horizontal: 8.0,
            ),
            child: Text('Viirs'),
          ),
          if (state.showViirs ?? false)
            Positioned(
              top: 5,
              right: 5,
              child: Icon(
                Icons.check_circle,
                size: 18,
                color: Colors.green,
              ),
            )
        ],
      ),
    );
  }

  Widget _getModisButton(AppState state, context) {
    return InkWell(
      onTap: () =>
          StoreProvider.of<AppState>(context).dispatch(ShowModisAction()),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 16.0,
              horizontal: 8.0,
            ),
            child: Text('Modis'),
          ),
          if (state.showModis ?? false)
            Positioned(
              top: 5,
              right: 5,
              child: Icon(
                Icons.check_circle,
                size: 18,
                color: Colors.green,
              ),
            )
        ],
      ),
    );
  }
}

class ViirsModal extends StatelessWidget {
  final Viirs viirs;

  const ViirsModal({Key key, this.viirs}) : super(key: key);

  String getConfidence (BuildContext context, String confidence) {
    if (confidence == 'nominal') {
        return FogosLocalizations.of(context).textNominalConfidence;
    } else if (confidence == 'low') {
        return FogosLocalizations.of(context).textLowConfidence;
    } else if (confidence == 'high') {
        return FogosLocalizations.of(context).textHighConfidence;
    } else {
        return confidence;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                icon: Icon(
                  Icons.close,
                ),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
            RichText(
              text: TextSpan(
                children: <TextSpan>[
                  TextSpan(
                      text: "${FogosLocalizations.of(context).textDate}: ",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.black)),
                  TextSpan(
                      text: viirs.acqDate.toIso8601String(),
                      style: TextStyle(color: Colors.black)),
                ],
              ),
            ),
            RichText(
              text: TextSpan(
                children: <TextSpan>[
                  TextSpan(
                      text: "${FogosLocalizations.of(context).textBrightTi4}: ",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.black)),
                  TextSpan(
                      text: viirs.brightTi4,
                      style: TextStyle(color: Colors.black)),
                ],
              ),
            ),
            RichText(
              text: TextSpan(
                children: <TextSpan>[
                  TextSpan(
                      text: "${FogosLocalizations.of(context).textBrightTi5}: ",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.black)),
                  TextSpan(
                      text: viirs.brightTi5,
                      style: TextStyle(color: Colors.black)),
                ],
              ),
            ),
            RichText(
              text: TextSpan(
                children: <TextSpan>[
                  TextSpan(
                      text: "${FogosLocalizations.of(context).textFrp}: ",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.black)),
                  TextSpan(
                      text: viirs.frp, style: TextStyle(color: Colors.black)),
                ],
              ),
            ),
            RichText(
              text: TextSpan(
                children: <TextSpan>[
                  TextSpan(
                      text:
                          "${FogosLocalizations.of(context).textConfidence}: ",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.black)),
                  TextSpan(
                      text: getConfidence(context, viirs.confidence),
                      style: TextStyle(color: Colors.black)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ModisModal extends StatelessWidget {
  final Modis modis;

  const ModisModal({Key key, this.modis}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: EdgeInsets.all(12.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                icon: Icon(
                  Icons.close,
                ),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
            RichText(
              text: TextSpan(
                children: <TextSpan>[
                  TextSpan(
                      text: "${FogosLocalizations.of(context).textDate}: ",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.black)),
                  TextSpan(
                      text: modis.acqDate.toIso8601String(),
                      style: TextStyle(color: Colors.black)),
                ],
              ),
            ),
            RichText(
              text: TextSpan(
                children: <TextSpan>[
                  TextSpan(
                      text: "${FogosLocalizations.of(context).textBrightT31}: ",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.black)),
                  TextSpan(
                      text: modis.brightT31,
                      style: TextStyle(color: Colors.black)),
                ],
              ),
            ),
            RichText(
              text: TextSpan(
                children: <TextSpan>[
                  TextSpan(
                      text:
                          "${FogosLocalizations.of(context).textBrightness}: ",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.black)),
                  TextSpan(
                      text: modis.brightness,
                      style: TextStyle(color: Colors.black)),
                ],
              ),
            ),
            RichText(
              text: TextSpan(
                children: <TextSpan>[
                  TextSpan(
                      text: "${FogosLocalizations.of(context).textFrp}: ",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.black)),
                  TextSpan(
                      text: modis.frp, style: TextStyle(color: Colors.black)),
                ],
              ),
            ),
            RichText(
              text: TextSpan(
                children: <TextSpan>[
                  TextSpan(
                      text:
                          "${FogosLocalizations.of(context).textConfidence}: ",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.black)),
                  TextSpan(
                      text: "${modis.confidence}%",
                      style: TextStyle(color: Colors.black)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
