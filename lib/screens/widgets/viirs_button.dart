import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:fogosmobile/actions/viirs_actions.dart';
import 'package:fogosmobile/models/app_state.dart';
import 'package:redux/redux.dart';

class ViirsButton extends StatelessWidget {
  const ViirsButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppState>(
      converter: (Store<AppState> store) => store.state,
      builder: (context, state) {
        return InkWell(
          onTap: () =>
              StoreProvider.of<AppState>(context).dispatch(ShowViirsAction()),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 16.0,
                  horizontal: 8.0,
                ),
                child: Text('Viirs'),
              ),
              if (state.showViirs ?? false)
                Positioned(
                  top: 5,
                  right: 5,
                  child: Icon(
                    Icons.check_circle,
                    size: 18,
                    color: Colors.green,
                  ),
                )
            ],
          ),
        );
      },
    );
  }
}
