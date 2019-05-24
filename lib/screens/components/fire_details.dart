import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:fogosmobile/actions/fires_actions.dart';
import 'package:fogosmobile/actions/preferences_actions.dart';
import 'package:fogosmobile/localization/fogos_localizations.dart';
import 'package:fogosmobile/models/app_state.dart';
import 'package:fogosmobile/models/fire.dart';
import 'package:fogosmobile/constants/routes.dart';
import 'package:fogosmobile/screens/utils/widget_utils.dart';
import 'package:fogosmobile/screens/assets/images.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:redux/redux.dart';
import 'package:share/share.dart';

typedef SetPreferenceCallBack = Function(String key, int value);

class FireDetails extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, VoidCallback>(
      converter: (Store<AppState> store) {
        return () {
          store.dispatch(ClearFireAction());
        };
      },
      builder: (BuildContext context, VoidCallback clearFireAction) {
        return StoreConnector<AppState, AppState>(
          converter: (Store<AppState> store) => store.state,
          builder: (BuildContext context, AppState state) {
            Fire fire = state.fire;
            if (fire == null) {
              return ModalProgressHUD(
                opacity: 0.75,
                color: Colors.black,
                inAsyncCall: true,
                child: Container(),
              );
            }

            return new StoreConnector<AppState, SetPreferenceCallBack>(
              converter: (Store<AppState> store) {
                return (String fireId, int value) {
                  store.dispatch(new SetFireNotificationAction(fireId, value));
                };
              },
              builder: (BuildContext context,
                  SetPreferenceCallBack setPreferenceAction) {
                bool isFireSubscribed = false;
                if ((state.preferences['subscribedFires'] ?? []).length > 0) {
                  var subbedFire = state.preferences['subscribedFires']
                      .firstWhere((fs) => fs.id == fire.id, orElse: () {});
                  if (subbedFire != null) {
                    isFireSubscribed = true;
                  }
                }
                return StoreConnector<AppState, VoidCallback>(
                  converter: (Store<AppState> store) {
                    return () =>
                        store.dispatch(LoadFireMeansHistoryAction(fire.id));
                  },
                  builder: (BuildContext context,
                      VoidCallback loadFireMeansHistoryAction) {
                    return StoreConnector<AppState, VoidCallback>(
                      converter: (Store<AppState> store) {
                        return () => store
                            .dispatch(LoadFireDetailsHistoryAction(fire.id));
                      },
                      builder: (BuildContext context,
                          VoidCallback loadFireDetailsHistoryAction) {
                        return StoreConnector<AppState, VoidCallback>(
                          converter: (Store<AppState> store) {
                            return () =>
                                store.dispatch(LoadFireRiskAction(fire.id));
                          },
                          builder: (BuildContext context,
                              VoidCallback loadFireRiskAction) {
                            return SingleChildScrollView(
                              child: Container(
                                child: Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                      16.0, 16.0, 16.0, 32.0),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16.0),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: <Widget>[
                                                IconButton(
                                                  icon: Icon(Icons.share),
                                                  onPressed: () {
                                                    Share.share(
                                                        'Incêndio em ${fire.city} https://fogos.pt/fogo/${fire.id}');
                                                  },
                                                ),
                                                SizedBox(width: 8),
                                                state.isLoading
                                                    ? IconButton(
                                                        icon:
                                                            CircularProgressIndicator(),
                                                        onPressed: () {},
                                                      )
                                                    : new IconButton(
                                                        icon: new Icon(isFireSubscribed
                                                            ? Icons
                                                                .notifications_active
                                                            : Icons
                                                                .notifications_none),
                                                        onPressed: () {
                                                          setPreferenceAction(
                                                              fire.id,
                                                              isFireSubscribed
                                                                  ? 0
                                                                  : 1);
                                                        },
                                                      ),
                                                SizedBox(width: 8),
                                                IconButton(
                                                  icon: Icon(Icons.close),
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                    clearFireAction();
                                                  },
                                                ),
                                              ],
                                            ),
                                            Row(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: <Widget>[
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: 16.0),
                                                  child: Icon(
                                                    FontAwesomeIcons.map,
                                                    color: getFireColor(
                                                        fire.statusColor),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .stretch,
                                                    children: <Widget>[
                                                      Text(
                                                        fire.district,
                                                        style: TextStyle(
                                                            fontSize: 16.0),
                                                      ),
                                                      Text(
                                                        fire.city,
                                                        style: TextStyle(
                                                            fontSize: 16.0),
                                                      ),
                                                      Text(
                                                        fire.town,
                                                        style: TextStyle(
                                                            fontSize: 16.0),
                                                      ),
                                                      Text(
                                                        fire.local,
                                                        style: TextStyle(
                                                            fontSize: 16.0),
                                                      ),
                                                    ],
                                                  ),
                                                )
                                              ],
                                            ),
                                            Padding(
                                              padding:
                                                  EdgeInsets.only(top: 20.0),
                                            ),
                                            Row(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: <Widget>[
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: 16.0),
                                                  child: SvgPicture.asset(
                                                    getCorrectStatusImage(
                                                      fire.statusCode,
                                                      fire.important,
                                                    ),
                                                    width: 25.0,
                                                    height: 25.0,
                                                    color: getFireColor(fire.statusColor),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .stretch,
                                                    children: <Widget>[
                                                      Text(
                                                        '${FogosLocalizations.of(context).textStatus}: ${fire.status}',
                                                        style: TextStyle(
                                                            fontSize: 16.0),
                                                      ),
                                                    ],
                                                  ),
                                                )
                                              ],
                                            ),
                                            Padding(
                                              padding:
                                                  EdgeInsets.only(top: 20.0),
                                            ),
                                            Row(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: <Widget>[
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: 16.0),
                                                  child: SvgPicture.asset(
                                                    imgSvgFireman,
                                                    width: 35.0,
                                                    height: 35.0,
                                                    color: getFireColor(fire.statusColor),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .stretch,
                                                    children: <Widget>[
                                                      Text(
                                                        '${FogosLocalizations.of(context).textHumanMeans}: ${fire.human}',
                                                        style: TextStyle(
                                                            fontSize: 16.0),
                                                      ),
                                                      Text(
                                                        '${FogosLocalizations.of(context).textTerrainMeans}: ${fire.terrain}',
                                                        style: TextStyle(
                                                            fontSize: 16.0),
                                                      ),
                                                      Text(
                                                        '${FogosLocalizations.of(context).textAerealMeans}: ${fire.aerial}',
                                                        style: TextStyle(
                                                            fontSize: 16.0),
                                                      )
                                                    ],
                                                  ),
                                                )
                                              ],
                                            ),
                                            Padding(
                                              padding:
                                                  EdgeInsets.only(top: 20.0),
                                            ),
                                            Row(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: <Widget>[
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: 16.0),
                                                  child: Icon(
                                                    FontAwesomeIcons.clock,
                                                    color: getFireColor(
                                                        fire.statusColor),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .stretch,
                                                    children: <Widget>[
                                                      Text(
                                                        '${fire.date} ${fire.time}',
                                                        style: TextStyle(
                                                            fontSize: 16.0),
                                                      ),
                                                    ],
                                                  ),
                                                )
                                              ],
                                            ),
                                            Padding(
                                              padding:
                                                  EdgeInsets.only(top: 20.0),
                                            ),
                                            Row(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: <Widget>[
                                                FlatButton(
                                                  child: Text("MAIS INFO"),
                                                  onPressed: () {
                                                    loadFireMeansHistoryAction();
                                                    loadFireDetailsHistoryAction();
                                                    loadFireRiskAction();
                                                    Navigator.of(context)
                                                        .pushNamed(
                                                            FIRE_DETAILS_ROUTE);
                                                  },
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      },
                    );
                  },
                );
              },
            );
          },
        );
      },
    );
  }
}
