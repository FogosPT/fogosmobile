import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:fogosmobile/localization/fogos_localizations.dart';
import 'package:redux/redux.dart';
import 'package:fogosmobile/models/app_state.dart';
import 'package:fogosmobile/actions/preferences_actions.dart';

typedef SetPreferenceCallBack = Function(String key, int value);

class OtherNotifications extends StatefulWidget {
  @override
  _OtherNotificationsState createState() => _OtherNotificationsState();
}

class _OtherNotificationsState extends State<OtherNotifications> {
  @override
  Widget build(BuildContext context) {
    return new StoreConnector<AppState, AppState>(
      converter: (Store<AppState> store) => store.state,
      onInit: (store) {
        store.dispatch(LoadAllPreferencesAction());
      },
      builder: (BuildContext context, AppState state) {
        return new StoreConnector<AppState, SetPreferenceCallBack>(
          converter: (Store<AppState> store) {
            return (String key, int value) {
              print('$key, ${value.toString()}');
              store.dispatch(new SetPreferenceAction(key, value));
            };
          },
          builder: (BuildContext context, SetPreferenceCallBack setPreferenceCallBack) {
            return Container(
              child: new ListView(
                children: <Widget>[
                  CheckboxListTile(
                    title: Text("Ocorrências significativas"),
                    value: state.preferences['pref-ocorrencia-significativa'] == 1,
                    onChanged: (bool value) {
                      setPreferenceCallBack('ocorrencia-significativa', value == true ? 1 : 0);
                    },
                  ),
                  CheckboxListTile(
                    title: Text("Avisos"),
                    value: state.preferences['pref-avisos'] == 1,
                    onChanged: (bool value) {
                      setPreferenceCallBack('avisos', value == true ? 1 : 0);
                    },
                  )
                ],
              ),
            );
          },
        );
      },
    );
  }
}
