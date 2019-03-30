import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:fogosmobile/styles/theme.dart';
import 'package:fogosmobile/actions/fires_actions.dart';
import 'package:fogosmobile/store/app_store.dart';
import 'package:fogosmobile/models/app_state.dart';
import 'package:fogosmobile/screens/home_page.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new StoreProvider(
      store: store, // store comes from the app_store.dart import
      child: MaterialApp(
        title: 'Fogos.pt',
        debugShowCheckedModeBanner: false,
        home: new Scaffold(
          appBar: new AppBar(
            backgroundColor: Colors.redAccent,
            iconTheme: new IconThemeData(color: Colors.white),
            title: new Text(
              'Fogos.pt',
              style: new TextStyle(color: Colors.white),
            ),
            actions: [
              new IconButton(
                icon: Icon(
                  Icons.settings,
                ),
                onPressed: () {},
              ),
              new StoreConnector<AppState, VoidCallback>(
                converter: (Store<AppState> store) {
                  return () {
                    store.dispatch(new LoadFiresAction());
                  };
                },
                builder: (BuildContext context, VoidCallback loadFiresAction) {
                  return new StoreConnector<AppState, AppState>(
                    converter: (Store<AppState> store) => store.state,
                    builder: (BuildContext context, AppState state) {
                      print(state);
                      if ((state.hasFirstLoad == false || state.hasFirstLoad == null) && (state.isLoading == false || state.isLoading == null)) {
                        loadFiresAction();
                      }

                      if (state.isLoading) {
                        return Container(
                          width: 54.0,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: new CircularProgressIndicator(
                              strokeWidth: 2.0,
                            ),
                          ),
                        );
                      } else {
                        return new IconButton(
                          onPressed: loadFiresAction,
                          icon: new Icon(Icons.refresh),
                        );
                      }
                    },
                  );
                },
              ),
            ],
          ),
          body: new HomePage(),
        ),
      ),
    );
  }
}