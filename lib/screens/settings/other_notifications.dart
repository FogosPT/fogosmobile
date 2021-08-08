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
              store.dispatch(new SetPreferenceAction(key, value));
            };
          },
          builder: (BuildContext context,
              SetPreferenceCallBack setPreferenceCallBack) {
            return Container(
              child: new ListView(
                children: <Widget>[
                  CheckboxListTile(
                    title: Text(FogosLocalizations.of(context).textSignificatOccurences),
                    value: state.preferences['pref-important'] == 1,
                    onChanged: (bool value) {
                      setPreferenceCallBack('important', value == true ? 1 : 0);
                      setState(() {
                        state.preferences['pref-important'] =
                            value == true ? 1 : 0;
                      });
                    },
                  ),
                  CheckboxListTile(
                    title: Text(FogosLocalizations.of(context).textWarnings),
                    value: state.preferences['pref-warnings'] == 1,
                    onChanged: (bool value) {
                      setPreferenceCallBack('warnings', value == true ? 1 : 0);
                      setState(() {
                        state.preferences['pref-warnings'] =
                            value == true ? 1 : 0;
                      });
                    },
                  ),
                  CheckboxListTile(
                    title: Text(FogosLocalizations.of(context).textPlanes),
                    value: state.preferences['pref-planes'] == 1,
                    onChanged: (bool value) {
                      setPreferenceCallBack('planes', value == true ? 1 : 0);
                      setState(() {
                        state.preferences['pref-planes'] =
                            value == true ? 1 : 0;
                      });
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
