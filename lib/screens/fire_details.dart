import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:fogosmobile/screens/components/fire_gradient_app_bar.dart';
import 'package:fogosmobile/models/app_state.dart';
import 'package:fogosmobile/models/fire.dart';
import 'package:fogosmobile/actions/fires_actions.dart';

class FireDetails extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppState>(
      converter: (Store<AppState> store) => store.state,
      builder: (BuildContext context, AppState state) {
        Fire fire = state.fire;
        String _title = fire.town;

        if (fire.town != fire.local) {
          _title = '$_title, ${fire.local}';
        }

        return StoreConnector<AppState, VoidCallback>(
          converter: (Store<AppState> store) {
            return () {
              store.dispatch(new LoadFireMeansHistoryAction(fire.id));
            };
          },
          builder: (BuildContext context, VoidCallback loadFireMeansHistoryAction) {
            List history = state.fireMeansHistory;
            if (history == null) {
              loadFireMeansHistoryAction();
            } else {
              for (Map step in history) {
                // print(step);
              }
            }

            return Scaffold(
              appBar: new FireGradientAppBar(
                iconTheme: new IconThemeData(color: Colors.white),
                title: new Text(
                  _title,
                  style: new TextStyle(color: Colors.white),
                ),
              ),
              body: Container(
                
              ),
            );
          },
        );
      },
    );
  }
}
