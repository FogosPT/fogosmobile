import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

import 'package:fogosmobile/actions/warnings_actions.dart';
import 'package:fogosmobile/models/app_state.dart';
import 'package:fogosmobile/localization/fogos_localizations.dart';
import 'package:fogosmobile/screens/components/fire_gradient_app_bar.dart';
import 'package:fogosmobile/screens/components/warnings_list.dart';

class WarningsMadeira extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: FireGradientAppBar(
        title: new Text(
          FogosLocalizations.of(context).textWarningsMadeira,
          style: new TextStyle(color: Colors.white),
        ),
      ),
      body: new Container(
        child: StoreConnector<AppState, AppState>(
          converter: (Store<AppState> store) => store.state,
          onInit: (Store<AppState> store) {
            store.dispatch(LoadWarningsMadeiraAction());
          },
          builder: (BuildContext context, AppState state) {
            List warnings = state.warningsMadeira;
            if (warnings == null) {
              if (state.errors != null && state.errors.contains('warningsMadeira')) {
                return Center(child: Text(FogosLocalizations.of(context).textProblemLoadingData));
              }

              return Center(child: CircularProgressIndicator());
            }

            return WarningsList(warnings: warnings);
          },
        ),
      ),
    );
  }
}
