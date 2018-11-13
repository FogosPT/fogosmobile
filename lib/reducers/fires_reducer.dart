import 'package:fogosmobile/actions/fires_actions.dart';

firesReducer(List fires, action) {
  if (action is LoadFiresAction) {
    print('loadFiresAction');
    return fires;
  } else if (action is FiresLoadedAction) {
    return action.fires;
  } else {
    return fires;
  }
}
