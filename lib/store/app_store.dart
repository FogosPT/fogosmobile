import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:fogosmobile/models/app_state.dart';
import 'package:fogosmobile/reducers/app_reducer.dart';

final store = new Store<AppState>(
  appReducer,
  initialState: new AppState(),
  middleware: [],
);
