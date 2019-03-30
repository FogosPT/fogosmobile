import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:fogosmobile/models/app_state.dart';
import 'package:fogosmobile/models/fire.dart';
import 'package:fogosmobile/actions/fires_actions.dart';

class FireDetails extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new StoreConnector<AppState, VoidCallback>(
        converter: (Store<AppState> store) {
      return () {
        store.dispatch(new ClearFireAction());
      };
    }, builder: (BuildContext context, VoidCallback clearFireAction) {
      return new StoreConnector<AppState, Fire>(
          converter: (Store<AppState> store) => store.state.fire,
          builder: (BuildContext context, Fire fire) {
            if (fire == null) {
              return new Center(
                child: CircularProgressIndicator(),
              );
            }

            return new Container(
              child: new Padding(
                padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 32.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    new Padding(
                      padding: const EdgeInsets.only(left: 16.0),
                      child: new Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          new Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              new Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  new Padding(
                                    padding: const EdgeInsets.only(right: 16.0),
                                    child: new Icon(
                                      FontAwesomeIcons.map,
                                      color: Colors.redAccent,
                                    ),
                                  ),
                                  new Column(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      new SizedBox(
                                        width: 275.0,
                                        child: new Text(
                                          fire.district,
                                          style: new TextStyle(fontSize: 16.0),
                                        ),
                                      ),
                                      new SizedBox(
                                        width: 275.0,
                                        child: new Text(
                                          fire.city,
                                          style: new TextStyle(fontSize: 16.0),
                                        ),
                                      ),
                                      new SizedBox(
                                        width: 275.0,
                                        child: new Text(
                                          fire.town,
                                          style: new TextStyle(fontSize: 16.0),
                                        ),
                                      ),
                                      new SizedBox(
                                        width: 275.0,
                                        child: new Text(
                                          fire.local,
                                          style: new TextStyle(fontSize: 16.0),
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                              new Divider(),
                              new Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  new Padding(
                                    padding: const EdgeInsets.only(right: 16.0),
                                    child: new Icon(FontAwesomeIcons.mapMarker,
                                        color: Colors.redAccent),
                                  ),
                                  new Column(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      new Text(
                                        'Estado: ${fire.status}',
                                        style: new TextStyle(fontSize: 16.0),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                              new Divider(),
                              new Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  new Padding(
                                    padding: const EdgeInsets.only(right: 16.0),
                                    child: new Icon(
                                      FontAwesomeIcons.fighterJet,
                                      color: Colors.redAccent,
                                    ),
                                  ),
                                  new Column(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      new Text(
                                        'Meios humanos: ${fire.human}',
                                        style: new TextStyle(fontSize: 16.0),
                                      ),
                                      new Text(
                                        'Meios terrestres: ${fire.terrain}',
                                        style: new TextStyle(fontSize: 16.0),
                                      ),
                                      new Text(
                                        'Meios aéreos: ${fire.aerial}',
                                        style: new TextStyle(fontSize: 16.0),
                                      )
                                    ],
                                  )
                                ],
                              ),
                              new Divider(),
                              new Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  new Padding(
                                    padding: const EdgeInsets.only(right: 16.0),
                                    child: new Icon(
                                      FontAwesomeIcons.clock,
                                      color: Colors.redAccent,
                                    ),
                                  ),
                                  new Column(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      new Text(
                                        '${fire.date} ${fire.time}',
                                        style: new TextStyle(fontSize: 16.0),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                              new Divider(),
                            ],
                          ),
                          new IconButton(
                            icon: new Icon(Icons.close),
                            onPressed: () {
                              Navigator.of(context).pop();
                              clearFireAction();
                            },
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
