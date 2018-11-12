import 'package:fogosmobile/actions/fires_actions.dart';

firesReducer(List fires, action) {
  if (action is LoadFiresAction) {
    print('action LoadFiresAction');
    // TODO DEVELOP THE REDUCER
    return fires;
  } else if (action is FiresLoadedAction) {
    print('fires loaded!!');
    // TODO DEVELOP THE REDUCER
  } else {
    return fires;
  }
}
