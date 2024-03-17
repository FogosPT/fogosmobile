import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fogosmobile/actions/fires_actions.dart';
import 'package:fogosmobile/actions/preferences_actions.dart';
import 'package:fogosmobile/constants/routes.dart';
import 'package:fogosmobile/constants/variables.dart';
import 'package:fogosmobile/localization/fogos_localizations.dart';
import 'package:fogosmobile/models/app_state.dart';
import 'package:fogosmobile/models/fire.dart';
import 'package:fogosmobile/screens/assets/images.dart';
import 'package:fogosmobile/screens/components/fire_details/important_fire_extra.dart';
import 'package:fogosmobile/screens/components/fire_gradient_app_bar.dart';
import 'package:fogosmobile/screens/utils/widget_utils.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:redux/redux.dart';
import 'package:share/share.dart';

class FireList extends StatefulWidget {
  const FireList();
  @override
  _FireListState createState() => _FireListState();
}

class _FireListState extends State<FireList> {
  MapboxMapController? mapController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: FireGradientAppBar(
        title: Text(
          FogosLocalizations.of(context).textFiresList,
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              final store = StoreProvider.of<AppState>(context);
              store.dispatch(LoadFiresAction());
            },
          ),
        ],
      ),
      body: Container(
        child: StoreConnector<AppState, AppState>(
          onInit: (Store<AppState> store) {
            store.dispatch(LoadFiresAction());
            store.dispatch(ClearFireAction());
          },
          converter: (Store<AppState> store) => store.state,
          builder: (BuildContext context, AppState state) {
            List<Fire> fires = state.fires ?? [];
            bool isLoading = state.isLoading ?? true;

            if (isLoading) {
              return ListView.builder(
                itemCount: 3,
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                    elevation: 8.0,
                    margin:
                        EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
                    child: Column(
                      children: [
                        Container(
                          height: 504.0,
                          child: Center(child: CircularProgressIndicator()),
                        ),
                      ],
                    ),
                  );
                },
              );
            }

            return Scrollbar(
              child: ListView.builder(
                itemCount: fires.length,
                itemBuilder: (BuildContext context, int index) {
                  Fire fire = fires[index];
                  String _title = fire.town;
                  final LatLng _center = LatLng(fire.lat, fire.lng);

                  if (fire.town != fire.local) {
                    _title = '$_title, ${fire.local}';
                  }

                  bool isFireSubscribed = false;
                  if ((state.preferences?['subscribedFires'] ?? []).length >
                      0) {
                    var subbedFire = state.preferences?['subscribedFires']
                        .firstWhere((fs) => fs.id == fire.id, orElse: () {});
                    if (subbedFire != null) {
                      isFireSubscribed = true;
                    }
                  }

                  final store = StoreProvider.of<AppState>(context);

                  return Card(
                    elevation: 8.0,
                    margin:
                        EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
                    child: Column(
                      children: [
                        Container(
                          height: 200.0,
                          child: MapboxMap(
                            initialCameraPosition: CameraPosition(
                              target: _center,
                              zoom: 14.0,
                            ),
                            tiltGesturesEnabled: false,
                            myLocationEnabled: true,
                            myLocationRenderMode: MyLocationRenderMode.GPS,
                            rotateGesturesEnabled: false,
                            scrollGesturesEnabled: false,
                            zoomGesturesEnabled: false,
                            styleString: MAPBOX_URL_SATTELITE_TEMPLATE,
                          ),
                        ),
                        Container(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(
                              16.0,
                              16.0,
                              16.0,
                              16.0,
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                            right: 16.0,
                                          ),
                                          child: Icon(
                                            Icons.map,
                                            color: getFireColor(fire),
                                          ),
                                        ),
                                        Expanded(
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.stretch,
                                            children: [
                                              Text(
                                                "${fire.district}, ${fire.city}, ${fire.town}, ${fire.local}",
                                                style:
                                                    TextStyle(fontSize: 16.0),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(top: 20.0),
                                    ),
                                    Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                            right: 16.0,
                                          ),
                                          child: SvgPicture.asset(
                                              getCorrectStatusImage(
                                                fire.statusCode,
                                                fire.important,
                                              ),
                                              width: 25.0,
                                              height: 25.0,
                                              colorFilter: ColorFilter.mode(
                                                getFireColor(fire),
                                                BlendMode.srcIn,
                                              )),
                                        ),
                                        Expanded(
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.stretch,
                                            children: [
                                              Text(
                                                '${FogosLocalizations.of(context).textStatus}: ${FogosLocalizations.of(context).textFireStatus(fire.status)}',
                                                style:
                                                    TextStyle(fontSize: 16.0),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(top: 20.0),
                                    ),
                                    Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                            right: 16.0,
                                          ),
                                          child: SvgPicture.asset(
                                            imgSvgFireman,
                                            width: 35.0,
                                            height: 35.0,
                                            colorFilter: ColorFilter.mode(
                                              getFireColor(fire),
                                              BlendMode.srcIn,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.stretch,
                                            children: [
                                              Text(
                                                '${FogosLocalizations.of(context).textHumanMeans}: ${fire.human}',
                                                style:
                                                    TextStyle(fontSize: 16.0),
                                              ),
                                              Text(
                                                '${FogosLocalizations.of(context).textTerrainMeans}: ${fire.terrain}',
                                                style:
                                                    TextStyle(fontSize: 16.0),
                                              ),
                                              Text(
                                                '${FogosLocalizations.of(context).textAerealMeans}: ${fire.aerial}',
                                                style:
                                                    TextStyle(fontSize: 16.0),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(top: 20.0),
                                    ),
                                    Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                            right: 16.0,
                                          ),
                                          child: Icon(
                                            Icons.access_time,
                                            color: getFireColor(fire),
                                          ),
                                        ),
                                        Expanded(
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.stretch,
                                            children: [
                                              Text(
                                                '${fire.date} ${fire.time}',
                                                style:
                                                    TextStyle(fontSize: 16.0),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(top: 20.0),
                                    ),
                                    ImportantFireExtra(fire),
                                    Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        IconButton(
                                          icon: Icon(Icons.share),
                                          onPressed: () {
                                            Share.share(
                                              FogosLocalizations.of(context)
                                                  .textShare(
                                                fire.city,
                                                fire.id,
                                              ),
                                            );
                                          },
                                        ),
                                        SizedBox(width: 8),
                                        state.isLoading ?? true
                                            ? IconButton(
                                                icon:
                                                    CircularProgressIndicator(),
                                                onPressed: () {},
                                              )
                                            : IconButton(
                                                icon: Icon(isFireSubscribed
                                                    ? Icons.notifications_active
                                                    : Icons.notifications_none),
                                                onPressed: () {
                                                  store.dispatch(
                                                    SetFireNotificationAction(
                                                      fire.id,
                                                      isFireSubscribed ? 0 : 1,
                                                    ),
                                                  );
                                                },
                                              ),
                                        SizedBox(width: 8),
                                        IconButton(
                                          icon: Icon(Icons.info),
                                          onPressed: () {
                                            final store =
                                                StoreProvider.of<AppState>(
                                              context,
                                            );
                                            store.dispatch(
                                              LoadFireAction(fire.id),
                                            );
                                            Navigator.of(context)
                                                .pushNamed(FIRE_DETAILS_ROUTE);
                                          },
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }

  // ignore: unused_element
  void _onMapCreated(MapboxMapController controller) {
    mapController = controller;
  }
}
