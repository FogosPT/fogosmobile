import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:fogosmobile/actions/preferences_actions.dart';
import 'package:fogosmobile/middleware/preferences_middleware.dart';
import 'package:fogosmobile/models/app_state.dart';
import 'package:redux/redux.dart';

class SatelliteButton extends StatefulWidget {
  const SatelliteButton({Key? key}) : super(key: key);

  @override
  _SatelliteButtonState createState() => _SatelliteButtonState();
}

class _SatelliteButtonState extends State<SatelliteButton> {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppState>(
      converter: (Store<AppState> store) => store.state,
      builder: (context, state) {
        List<Widget> widgets = [
          IconButton(
            icon: Icon(Icons.satellite),
            onPressed: () {
              final store = StoreProvider.of<AppState>(context);
              store.dispatch(
                SetPreferenceAction(
                  preferenceSatellite,
                  state.preferences?[preferenceSatellite] == 1 ? 0 : 1,
                ),
              );

              setState(() {});
            },
          ),
        ];

        if (state.preferences?[preferenceSatellite] == 1) {
          widgets.add(Positioned(
            bottom: 5,
            right: 5,
            child: Icon(Icons.check_circle, size: 18, color: Colors.green),
          ));
        }

        return Stack(children: widgets);
      },
    );
  }
}
