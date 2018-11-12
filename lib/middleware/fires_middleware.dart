import 'package:fogosmobile/models/app_state.dart';
import 'package:redux/redux.dart';

Middleware<AppState> getFiresMiddleware() {
  print('middleware');
  return (Store store, action, NextDispatcher next) async {
    next(action);
  };
}
