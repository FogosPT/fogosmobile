import 'package:flutter/material.dart';
import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:fogosmobile/models/app_state.dart';

final store = new Store<AppState>(
  appReducer,
  initialState: new AppState(),
  middleware: [],
);
