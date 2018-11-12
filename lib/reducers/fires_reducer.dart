import 'package:fogosmobile/actions/fires_actions.dart';

List firesReducer(List fires, action) {
  if (action is LoadFiresAction) {
    print('action LoadFiresAction');
    // TODO DEVELOP THE REDUCER
    return fires;
  } else {
    return fires;
  }
}
