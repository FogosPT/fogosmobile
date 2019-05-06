import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:fogosmobile/actions/fires_actions.dart';
import 'package:fogosmobile/models/app_state.dart';
import 'package:fogosmobile/models/fire.dart';
import 'package:fogosmobile/screens/utils/widget_utils.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:redux/redux.dart';
import 'package:share/share.dart';

class FireDetails extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, VoidCallback>(
        converter: (Store<AppState> store) {
      return () {
        store.dispatch(ClearFireAction());
      };
    }, builder: (BuildContext context, VoidCallback clearFireAction) {
      return StoreConnector<AppState, Fire>(
          converter: (Store<AppState> store) => store.state.fire,
          builder: (BuildContext context, Fire fire) {
            if (fire == null) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            return Container(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 32.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              IconButton(
                                icon: Icon(Icons.share),
                                onPressed: () {
                                  Share.share(
                                      '[${fire.dateTime}] Incêndio em ${fire.city} https://fogos.pt/fogo/${fire.id}');
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
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(right: 16.0),
                                child: Icon(
                                  FontAwesomeIcons.map,
                                  color: getFireColor(fire.statusColor),
                                ),
                              ),
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  SizedBox(
                                    width: 275.0,
                                    child: Text(
                                      fire.district,
                                      style: TextStyle(fontSize: 16.0),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 275.0,
                                    child: Text(
                                      fire.city,
                                      style: TextStyle(fontSize: 16.0),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 275.0,
                                    child: Text(
                                      fire.town,
                                      style: TextStyle(fontSize: 16.0),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 275.0,
                                    child: Text(
                                      fire.local,
                                      style: TextStyle(fontSize: 16.0),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(right: 16.0),
                                child: Icon(FontAwesomeIcons.mapMarker,
                                    color: getFireColor(fire.statusColor)),
                              ),
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    'Estado: ${fire.status}',
                                    style: TextStyle(fontSize: 16.0),
                                  ),
                                ],
                              )
                            ],
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(right: 16.0),
                                child: Icon(
                                  FontAwesomeIcons.fighterJet,
                                  color: getFireColor(fire.statusColor),
                                ),
                              ),
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    'Meios humanos: ${fire.human}',
                                    style: TextStyle(fontSize: 16.0),
                                  ),
                                  Text(
                                    'Meios terrestres: ${fire.terrain}',
                                    style: TextStyle(fontSize: 16.0),
                                  ),
                                  Text(
                                    'Meios aéreos: ${fire.aerial}',
                                    style: TextStyle(fontSize: 16.0),
                                  )
                                ],
                              )
                            ],
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(right: 16.0),
                                child: Icon(
                                  FontAwesomeIcons.clock,
                                  color: getFireColor(fire.statusColor),
                                ),
                              ),
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    '${fire.date} ${fire.time}',
                                    style: TextStyle(fontSize: 16.0),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          });
    });
  }
}
