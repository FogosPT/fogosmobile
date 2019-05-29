import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:fogosmobile/actions/warnings_actions.dart';
import 'package:redux/redux.dart';
import 'package:fogosmobile/models/app_state.dart';
import 'package:fogosmobile/localization/fogos_localizations.dart';
import 'package:fogosmobile/screens/components/fire_gradient_app_bar.dart';
import 'package:fogosmobile/models/warning.dart';

class WarningsMadeira extends StatelessWidget {
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
        child: StoreConnector<AppState, List>(
          converter: (Store<AppState> store) => store.state.warningsMadeira,
          onInit: (Store<AppState> store) {
            store.dispatch(LoadWarningsMadeiraAction());
          },
          builder: (BuildContext context, List warnings) {
            return new Column(
              children: <Widget>[
                new Padding(
                  padding: new EdgeInsets.only(top: 20.0),
                ),
                new Expanded(
                  child: new ListView.builder(
                    itemCount: warnings.length,
                    itemBuilder: (BuildContext context, int index) {
                      WarningMadeira warning = warnings[index];
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
