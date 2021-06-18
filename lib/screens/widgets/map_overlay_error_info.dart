import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:fogosmobile/localization/fogos_localizations.dart';
import 'package:fogosmobile/models/app_state.dart';
import 'package:redux/redux.dart';

class MapOverlayErrorInfoWidget extends StatelessWidget {
  const MapOverlayErrorInfoWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return StoreConnector<AppState, AppState>(
      converter: (Store<AppState> store) => store.state,
      builder: (context, state) {
        if (state.fires.length < 1) {
          if (state.errors != null && state.errors.contains('fires')) {
            return _MapOverlayErrorMessage();
          }
        }
        return Container();
      },
    );
  }
}

class _MapOverlayErrorMessage extends StatelessWidget {
  const _MapOverlayErrorMessage({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: 150.0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4.0),
          color: Colors.black54,
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                FogosLocalizations.of(context).textProblemLoadingData,
                style: TextStyle(color: Colors.white),
                textAlign: TextAlign.center,
              ),
              Text(
                FogosLocalizations.of(context).textInternetConnection,
                style: TextStyle(color: Colors.white),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
