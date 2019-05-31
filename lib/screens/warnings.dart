import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

import 'package:fogosmobile/actions/warnings_actions.dart';
import 'package:fogosmobile/models/warning.dart';
import 'package:fogosmobile/models/app_state.dart';
import 'package:fogosmobile/localization/fogos_localizations.dart';
import 'package:fogosmobile/screens/components/fire_gradient_app_bar.dart';

class Warnings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: FireGradientAppBar(
        title: new Text(
          FogosLocalizations.of(context).textWarnings,
          style: new TextStyle(color: Colors.white),
        ),
      ),
      body: new Container(
        child: StoreConnector<AppState, AppState>(
          converter: (Store<AppState> store) => store.state,
          onInit: (Store<AppState> store) {
            store.dispatch(LoadWarningsAction());
          },
          builder: (BuildContext context, AppState state) {
            print(state.toString());
            List warnings = state.warnings;
            if (warnings == null) {
              if (state.errors != null && state.errors.contains('warnings')) {
                return Center(child: Text('There was an error loading this info.'));
              }

              return Center(child: CircularProgressIndicator());
            }
            return new Column(
              children: <Widget>[
                new Padding(
                  padding: new EdgeInsets.only(top: 20.0),
                ),
                new Expanded(
                  child: new ListView.builder(
                    itemCount: warnings.length,
                    itemBuilder: (BuildContext context, int index) {
                      Warning warning = warnings[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10.0),
                        child: ListTile(
                          title: Text(
                            warning.title,
                            style: TextStyle(color: Colors.redAccent),
                          ),
                          subtitle: Text(warning.description),
                          isThreeLine: false,
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
