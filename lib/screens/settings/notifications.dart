import 'package:diacritic/diacritic.dart';
import 'package:fogosmobile/localization/fogos_localizations.dart';
import 'package:fogosmobile/screens/utils/text_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fogosmobile/screens/assets/images.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:fogosmobile/utils/network_utils.dart';
import 'package:redux/redux.dart';
import 'package:fogosmobile/constants/endpoints.dart';
import 'package:fogosmobile/models/app_state.dart';
import 'package:fogosmobile/actions/preferences_actions.dart';

typedef SetPreferenceCallBack = Function(String key, int value);

class Notifications extends StatefulWidget {
  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  List locations = [];
  TextEditingController controller = new TextEditingController();
  String? filter;
  /// When true, subscribes to all incident types (not just fires) per concelho.
  bool _allIncidents = false;

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
    String url = Endpoints.getLocations;
    final response = await get(url);
    return response!.data['rows'];
  }

  @override
  Widget build(BuildContext context) {
    if (this.locations.length == 0) {
      getLocations().then((locs) {
        setState(() {
          this.locations = locs;
          this.locations.sort((a, b) {
            return removeDiacritics(a['value']['name'])
                .toLowerCase()
                .compareTo(removeDiacritics(b['value']['name']).toLowerCase());
          });
        });
      });

      return Container(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return new StoreConnector<AppState, AppState>(
      converter: (Store<AppState> store) => store.state,
      onInit: (store) {
        store.dispatch(LoadAllPreferencesAction());
      },
      builder: (BuildContext context, AppState state) {
        if (state.hasPreferences == false && state.isLoading == false) {
          return new Center(
            child: CircularProgressIndicator(),
          );
        }

        return new StoreConnector<AppState, SetPreferenceCallBack>(
          converter: (Store<AppState> store) {
            return (String key, int value) {
              store.dispatch(new SetPreferenceAction(key, value));
              store.dispatch(new LoadAllPreferencesAction());
            };
          },
          builder: (BuildContext context, SetPreferenceCallBack setPreferenceAction) {
            // Sort: selected locations first, then alphabetical within each group
            final sortedLocations = [...this.locations]..sort((a, b) {
                final aKey = _allIncidents ? 'all-${a['key']}' : a['key'];
                final bKey = _allIncidents ? 'all-${b['key']}' : b['key'];
                final aSelected = state.preferences['pref-$aKey'] == 1;
                final bSelected = state.preferences['pref-$bKey'] == 1;
                if (aSelected == bSelected) return 0;
                return aSelected ? -1 : 1;
              });

            return new Column(
              children: <Widget>[
                new Padding(
                  padding: new EdgeInsets.only(top: 20.0),
                ),
                // Toggle between fires only and all incidents
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: SegmentedButton<bool>(
                    segments: [
                      ButtonSegment<bool>(
                        value: false,
                        icon: SvgPicture.asset(imgSvgLogoIconCor, height: 18),
                        label: Text(FogosLocalizations.of(context).textFires),
                      ),
                      ButtonSegment<bool>(
                        value: true,
                        label: Text('📋 ${FogosLocalizations.of(context).textAllIncidents}'),
                      ),
                    ],
                    selected: {_allIncidents},
                    onSelectionChanged: (Set<bool> selection) {
                      setState(() {
                        _allIncidents = selection.first;
                      });
                    },
                  ),
                ),
                new ListTile(
                  title: new TextField(
                    decoration: new InputDecoration(labelText: FogosLocalizations.of(context).textCounty),
                    controller: controller,
                  ),
                ),
                new Expanded(
                  child: Scrollbar(
                    child: new ListView.builder(
                      itemCount: sortedLocations.length,
                      itemBuilder: (BuildContext context, int index) {
                        final _location = sortedLocations[index];
                        final prefKey = _allIncidents
                            ? 'all-${_location['key']}'
                            : _location['key'];
                        return filter == null ||
                                filter == "" ||
                                transformStringToSearch(_location['value']['name']).contains(transformStringToSearch(filter ?? ''))
                            ? CheckboxListTile(
                                title: Text(_location['value']['name']),
                                subtitle: _allIncidents
                                    ? Text('Todos os incidentes', style: TextStyle(fontSize: 12, color: Colors.grey))
                                    : null,
                                value: state.preferences['pref-$prefKey'] == 1,
                                onChanged: (bool? value) {
                                  setPreferenceAction(prefKey, value == true ? 1 : 0);
                                },
                              )
                            : new Container();
                      },
                    ),
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
