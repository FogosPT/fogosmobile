import 'package:flutter/material.dart';
import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';

import 'package:fogosmobile/actions/fires_actions.dart';
import 'package:fogosmobile/store/app_store.dart';
import 'package:fogosmobile/models/app_state.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new StoreProvider(
        store: store, // store comes from the app_store.dart import
        child: MaterialApp(
          title: 'Flutter Demo',
          theme: new ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: new MyHomePage(title: 'Flutter Demo Home Page'),
        ));
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
      ),
      body: new Center(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Text(
              'You have pushed the button this many times:',
            ),
            new Text(
              '$_counter',
              style: Theme.of(context).textTheme.display1,
            ),
          ],
        ),
      ),
      floatingActionButton: new StoreConnector<AppState, VoidCallback>(
        converter: (Store<AppState> store) {
          return () {
            store.dispatch(new LoadFiresAction());
          };
        },
        builder: (BuildContext context, VoidCallback increase) {
          return new FloatingActionButton(
            onPressed: increase,
            child: new Icon(Icons.add),
          );
        },
      ),
    );
  }
}
