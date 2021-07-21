import 'package:flutter/material.dart';
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
import 'package:redux/redux.dart';
import 'package:fogosmobile/screens/utils/widget_utils.dart';
import 'package:share/share.dart';
import 'package:fogosmobile/screens/assets/images.dart';

class FiresTablePage extends StatefulWidget {
  @override
  _FiresTablePageState createState() => _FiresTablePageState();
}

class _FiresTablePageState extends State<FiresTablePage> {
  int _currentSortColumn = 1;
  bool _isAscending = false;

  orderFires(columnIndex, List<Fire> fires, field) {
    setState(() {
      _currentSortColumn = columnIndex;
      if (_isAscending == true) {
        _isAscending = false;
        fires.sort((a, b) => b.get(field).compareTo(a.get(field)));
      } else {
        _isAscending = true;
        fires.sort((a, b) => a.get(field).compareTo(b.get(field)));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: FireGradientAppBar(
        title: new Text(
          FogosLocalizations.of(context).textFiresTable,
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
                  sortColumnIndex: _currentSortColumn,
                  sortAscending: _isAscending,
                  columns: [
                    DataColumn(
                      label: Text(
                        'ID',
                      ),
                      onSort: (columnIndex, _) {
                        orderFires(columnIndex, fires, 'id');
                      },
                    ),
                    DataColumn(
                        label: Text(
                          FogosLocalizations.of(context).textDataTableStart,
                        ),
                        onSort: (columnIndex, _) {
                          orderFires(columnIndex, fires, 'dateTime');
                        }),
                    DataColumn(
                        label: Text(
                          FogosLocalizations.of(context).textDataTableDistrict,
                        ),
                        onSort: (columnIndex, _) {
                          orderFires(columnIndex, fires, 'district');
                        }),
                    DataColumn(
                        label: Text(
                          FogosLocalizations.of(context).textDataTableCounty,
                        ),
                        onSort: (columnIndex, _) {
                          orderFires(columnIndex, fires, 'city');
                        }),
                    DataColumn(
                        label: Text(
                          FogosLocalizations.of(context).textDataTableParish,
                        ),
                        onSort: (columnIndex, _) {
                          orderFires(columnIndex, fires, 'town');
                        }),
                    DataColumn(
                        label: Text(
                          FogosLocalizations.of(context).textDataTableLocality,
                        ),
                        onSort: (columnIndex, _) {
                          orderFires(columnIndex, fires, 'local');
                        }),
                    DataColumn(
                        label: Text(
                          FogosLocalizations.of(context).textDataTableStatus,
                        ),
                        onSort: (columnIndex, _) {
                          orderFires(columnIndex, fires, 'status');
                        }),
                    DataColumn(
                        label: Text(
                          '👩‍🚒',
                          style: TextStyle(fontSize: 24.0),
                        ),
                        onSort: (columnIndex, _) {
                          orderFires(columnIndex, fires, 'human');
                        }),
                    DataColumn(
                        label: Text(
                          '🚒',
                          style: TextStyle(fontSize: 24.0),
                        ),
                        onSort: (columnIndex, _) {
                          orderFires(columnIndex, fires, 'terrain');
                        }),
                    DataColumn(
                      label: Text(
                        '🚁',
                        style: TextStyle(fontSize: 24.0),
                      ),
                      onSort: (columnIndex, _) {
                        orderFires(columnIndex, fires, 'aerial');
                      },
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
