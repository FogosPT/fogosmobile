import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fogosmobile/actions/fires_actions.dart';
import 'package:fogosmobile/actions/preferences_actions.dart';
import 'package:fogosmobile/constants/routes.dart';
import 'package:fogosmobile/constants/variables.dart';
import 'package:fogosmobile/models/app_state.dart';
import 'package:fogosmobile/models/fire.dart';
import 'package:fogosmobile/screens/components/fire_details/important_fire_extra.dart';
import 'package:fogosmobile/screens/components/fire_gradient_app_bar.dart';
import 'package:fogosmobile/localization/fogos_localizations.dart';
import 'package:latlong/latlong.dart';
import 'package:redux/redux.dart';
import 'package:fogosmobile/screens/utils/widget_utils.dart';
import 'package:share/share.dart';
import 'package:fogosmobile/screens/assets/images.dart';

class FiresTablePage extends StatelessWidget {
  final MapController mapController = new MapController();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: FireGradientAppBar(
        title: new Text(
          FogosLocalizations.of(context).textFiresList,
          style: new TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              final store = StoreProvider.of<AppState>(context);
              store.dispatch(LoadFiresAction());
            },
          ),
        ],
      ),
      body: new Container(
          child: new StoreConnector<AppState, AppState>(
        onInit: (Store<AppState> store) {
          store.dispatch(LoadFiresAction());
          store.dispatch(ClearFireAction());
        },
        converter: (Store<AppState> store) => store.state,
        builder: (BuildContext context, AppState state) {
          List<Fire> fires = state.fires;
          bool isLoading = state.isLoading;

          if (isLoading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          return Scrollbar(
            child: SingleChildScrollView(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columns: [
                    DataColumn(
                      label: Text(
                        'ID',
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        FogosLocalizations.of(context).textDataTableStart,
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        FogosLocalizations.of(context).textDataTableDistrict,
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        FogosLocalizations.of(context).textDataTableCounty,
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        FogosLocalizations.of(context).textDataTableParish,
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        FogosLocalizations.of(context).textDataTableLocality,
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        FogosLocalizations.of(context).textDataTableStatus,
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        '👩‍🚒',
                        style: TextStyle(fontSize: 24.0),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        '🚒',
                        style: TextStyle(fontSize: 24.0),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        '🚁',
                        style: TextStyle(fontSize: 24.0),
                      ),
                    ),
                  ],
                  rows: fires
                      .map(
                        (fire) => DataRow(
                          cells: <DataCell>[
                            DataCell(
                              Text(fire.id),
                            ),
                            DataCell(
                              Text('${fire.date} ${fire.time}'),
                            ),
                            DataCell(
                              Text(fire.district),
                            ),
                            DataCell(
                              Text(fire.city),
                            ),
                            DataCell(
                              Text(fire.town),
                            ),
                            DataCell(
                              Text(fire.local),
                            ),
                            DataCell(
                              Wrap(
                                crossAxisAlignment: WrapCrossAlignment.center,
                                children: [
                                  Container(
                                    height: 32.0,
                                    width: 32.0,
                                    margin: EdgeInsets.all(4.0),
                                    decoration: BoxDecoration(
                                        color: getFireColor(fire),
                                        shape: BoxShape.circle),
                                    child: IconButton(
                                      icon: new SvgPicture.asset(
                                          getCorrectStatusImage(
                                              fire.statusCode, fire.important),
                                          semanticsLabel: 'Acme Logo'),
                                      onPressed: null,
                                    ),
                                  ),
                                  Text(FogosLocalizations.of(context)
                                      .textFireStatus(fire.status)),
                                ],
                              ),
                            ),
                            DataCell(
                              Text(fire.human?.toString() ?? 0),
                            ),
                            DataCell(
                              Text(fire.terrain?.toString() ?? 0),
                            ),
                            DataCell(
                              Text(fire.aerial?.toString() ?? 0),
                            ),
                          ],
                        ),
                      )
                      .toList(),
                ),
              ),
            ),
          );
        },
      )),
    );
  }
}
