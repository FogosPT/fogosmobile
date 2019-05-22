import 'package:fogosmobile/actions/contributors_actions.dart';

contributorsReducer(List contributors, action) {
  if (action is LoadContributorsAction) {
    return contributors;
  } else if (action is ContributorsLoadedAction) {
    return action.contributors;
  } else {
    return contributors;
  }
}
