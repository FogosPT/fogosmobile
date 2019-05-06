import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

import 'package:fogosmobile/models/app_state.dart';
import 'package:fogosmobile/actions/preferences_actions.dart';

typedef SetFireNotificationActionCallBack = Function(String key, int value);

class FireNotifications extends StatefulWidget {
  @override
  _FireNotificationsState createState() => _FireNotificationsState();
}

class _FireNotificationsState extends State<FireNotifications> {
  @override
  Widget build(BuildContext context) {
    return new StoreConnector<AppState, AppState>(
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

        var subscribedFires = state.preferences['subscribedFires'] ?? [];

        if (subscribedFires.length == 0) {
          return Center(
            child: Text('Não tem notificações ativas para fogos.'),
          );
        }

        return new StoreConnector<AppState, SetFireNotificationActionCallBack>(
          converter: (Store<AppState> store) {
            return (String key, int value) {
              print('$key, ${value.toString()}');
              store.dispatch(new SetFireNotificationAction(key, value));
            };
          },
          builder: (BuildContext context,
              SetFireNotificationActionCallBack SetFireNotificationAction) {
            return new Column(
              children: <Widget>[
                new Padding(
                  padding: new EdgeInsets.only(top: 20.0),
                ),
                new Expanded(
                  child: new ListView.builder(
                    itemCount: subscribedFires.length,
                    itemBuilder: (BuildContext context, int index) {
                      final _subscribedFire = subscribedFires[index];
                      String _title = _subscribedFire.town;

                      if (_subscribedFire.town != _subscribedFire.local) {
                        _title = '$_title, ${_subscribedFire.local}';
                      }

                      return ListTile(
                        title: Text(_title),
                        subtitle: Text('${_subscribedFire.city}, ${_subscribedFire.district}'),
                        isThreeLine: true,
                        trailing: IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            SetFireNotificationAction(_subscribedFire.id, 0);
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
