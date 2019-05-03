import 'dart:convert';
import 'dart:convert' show utf8;
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

import 'package:fogosmobile/constants/endpoints.dart';
import 'package:fogosmobile/models/app_state.dart';
import 'package:fogosmobile/actions/preferences_actions.dart';

typedef SetPreferenceCallBack = Function(String key, int value);

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  List locations = [];
  TextEditingController controller = new TextEditingController();
  String filter;

  @override
  initState() {
    super.initState();
    controller.addListener(() {
      setState(() {
        filter = controller.text;
      });
    });
  }

  getLocations() async {
    String url = endpoints['getLocations'];
    final response = await http.get(url);
    final data = json.decode(utf8.decode(response.bodyBytes));
    return data['rows'];
  }

  @override
  Widget build(BuildContext context) {
    if (this.locations.length == 0) {
      getLocations().then((locs) {
        setState(() {
          this.locations = locs;
        });
      });

      return new Scaffold(
        appBar: new AppBar(
          backgroundColor: Colors.redAccent,
          iconTheme: new IconThemeData(color: Colors.white),
          title: new Text(
            'Fogos.pt',
            style: new TextStyle(color: Colors.white),
          ),
        ),
        body: Container(
          child: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      );
    }

    return new Scaffold(
      appBar: new AppBar(
        backgroundColor: Colors.redAccent,
        iconTheme: new IconThemeData(color: Colors.white),
        title: new Text(
          'Fogos.pt',
          style: new TextStyle(color: Colors.white),
        ),
      ),
      body: new StoreConnector<AppState, AppState>(
        converter: (Store<AppState> store) => store.state,
        onInit: (store) {
          store.dispatch(LoadAllPreferencesAction());
        },
        builder: (BuildContext context, AppState state) {
          if (!state.hasPreferences && !state.isLoading) {
            return new Center(
              child: CircularProgressIndicator(),
            );
          }

          return new StoreConnector<AppState, SetPreferenceCallBack>(
            converter: (Store<AppState> store) {
              return (String key, int value) {
                store.dispatch(new SetPreferenceAction(key, value));
              };
            },
            builder: (BuildContext context, SetPreferenceCallBack setPreferenceAction) {
              return new Column(
                children: <Widget>[
                  new Padding(
                    padding: new EdgeInsets.only(top: 20.0),
                  ),
                  new ListTile(
                    title: new TextField(
                      decoration: new InputDecoration(labelText: "Concelho"),
                      controller: controller,
                    ),
                  ),
                  new Expanded(
                    child: new ListView.builder(
                      itemCount: this.locations.length,
                      itemBuilder: (BuildContext context, int index) {
                        final _location = this.locations[index];
                        return filter == null ||
                                filter == "" ||
                                _location['value']['name'].toLowerCase().contains(filter.toLowerCase())
                            ? CheckboxListTile(
                                title: Text(_location['value']['name']),
                                value: state.preferences['pref-${_location['key']}'] == 1,
                                onChanged: (bool value) {
                                  setPreferenceAction(_location['key'], value == true ? 1 : 0);
                                },
                              )
                            : new Container();
                      },
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
