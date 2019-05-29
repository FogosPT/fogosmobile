import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:fogosmobile/localization/fogos_localizations.dart';
import 'package:fogosmobile/screens/components/details_history.dart';
import 'package:fogosmobile/screens/components/fireRisk.dart';
import 'package:fogosmobile/screens/components/meansStatistics.dart';
import 'package:redux/redux.dart';
import 'package:fogosmobile/screens/components/fire_gradient_app_bar.dart';
import 'package:fogosmobile/models/app_state.dart';
import 'package:fogosmobile/models/fire.dart';
import 'package:fogosmobile/actions/fires_actions.dart';

class FireDetailsPage extends StatelessWidget {
  final TextStyle _header = TextStyle(
    color: Color(0xffff512f),
    fontSize: 20,
  );

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppState>(
      onDispose: (Store<AppState> store) {
        store.dispatch(ClearFireMeansAction());
        store.dispatch(ClearFireRiskAction());
        store.dispatch(ClearFireDetailsAction());
      },
      converter: (Store<AppState> store) => store.state,
      builder: (BuildContext context, AppState state) {
        Fire fire = state.fire;

        if (fire == null) {
          return Scaffold(
            appBar: FireGradientAppBar(
              title: Text(
                "",
                style: TextStyle(color: Colors.white),
              ),
            ),
            body: Container(
              child: CircularProgressIndicator(),
            ),
          );
        }

        String _title = fire.town;

        if (fire.town != fire.local) {
          _title = '$_title, ${fire.local}';
        }

        return Scaffold(
          appBar: FireGradientAppBar(
            title: Text(
              _title,
              style: TextStyle(color: Colors.white),
            ),
          ),
          body: Container(
            child: ListView(
              children: <Widget>[
                ListTile(title: Text(FogosLocalizations.of(context).textResources.toUpperCase(), style: _header)),
                SizedBox(height: 15),
                MeansStatistics(),
                SizedBox(height: 25),
                ListTile(title: Text(FogosLocalizations.of(context).textStatus.toUpperCase(), style: _header)),
                SizedBox(height: 15),
                DetailsHistoryStats(),
                SizedBox(height: 25),
                ListTile(title: Text(FogosLocalizations.of(context).textRiskOfFire.toUpperCase(), style: _header)),
                SizedBox(height: 15),
                FireRisk(),
                SizedBox(height: 25),
              ],
            ),
          ),
        );
      },
    );
  }
}
