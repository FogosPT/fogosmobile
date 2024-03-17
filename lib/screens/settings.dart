import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:fogosmobile/actions/preferences_actions.dart';
import 'package:fogosmobile/constants/endpoints.dart';
import 'package:fogosmobile/localization/fogos_localizations.dart';
import 'package:fogosmobile/models/app_state.dart';
import 'package:fogosmobile/utils/network_utils.dart';
import 'package:redux/redux.dart';

import 'components/fire_gradient_app_bar.dart';

typedef SetPreferenceCallBack = Function(String key, int value);

class Settings extends StatefulWidget {
  const Settings();
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  List locations = [];
  TextEditingController controller = TextEditingController();
  String? filter;

  @override
  Widget build(BuildContext context) {
    if (this.locations.length == 0) {
      getLocations().then((locs) {
        setState(() {
          this.locations = locs;
        });
      });

      return Scaffold(
        appBar: FireGradientAppBar(
          title: Text(
            FogosLocalizations.of(context).appTitle,
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: Container(child: Center(child: CircularProgressIndicator())),
      );
    }

    return Scaffold(
      appBar: FireGradientAppBar(
        title: Text(
          FogosLocalizations.of(context).appTitle,
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: StoreConnector<AppState, AppState>(
        converter: (Store<AppState> store) => store.state,
        onInit: (store) {
          store.dispatch(LoadAllPreferencesAction());
        },
        builder: (BuildContext context, AppState state) {
          if (!(state.hasPreferences ?? false) && !(state.isLoading ?? false)) {
            return Center(child: CircularProgressIndicator());
          }

          return StoreConnector<AppState, SetPreferenceCallBack>(
            converter: (Store<AppState> store) {
              return (String key, int value) {
                store.dispatch(SetPreferenceAction(key, value));
              };
            },
            builder: (
              BuildContext context,
              SetPreferenceCallBack setPreferenceAction,
            ) {
              return Column(
                children: [
                  Padding(padding: EdgeInsets.only(top: 20.0)),
                  ListTile(
                    title: TextField(
                      decoration: InputDecoration(
                        labelText: FogosLocalizations.of(context).textCounty,
                      ),
                      controller: controller,
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: this.locations.length,
                      itemBuilder: (BuildContext context, int index) {
                        final _location = this.locations[index];
                        return filter == "" ||
                                _location['value']['name']
                                    .toLowerCase()
                                    .contains(filter?.toLowerCase())
                            ? SizedBox()
                            // CheckboxListTile(
                            //     title: Text(_location['value']['name']),
                            //     value: state.preferences[
                            //             'pref-${_location['key']}'] ==
                            //         1,
                            //     onChanged: (bool value) {
                            //       setPreferenceAction(
                            //           _location['key'], value == true ? 1 : 0);
                            //     },
                            //   )
                            : Container();
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

  getLocations() async {
    String url = Endpoints.getLocations;
    final response = await get(url);
    return response.data['rows'];
  }

  @override
  initState() {
    super.initState();
    controller.addListener(() {
      setState(() {
        filter = controller.text;
      });
    });
  }
}
