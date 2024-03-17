import 'package:fogosmobile/actions/contributors_actions.dart';
import 'package:fogosmobile/models/contributor.dart';

contributorsReducer(List<Contributor>? contributors, action) {
  if (action is LoadContributorsAction) {
    return contributors;
  } else if (action is ContributorsLoadedAction) {
    return action.contributors;
  }
  return contributors;
}
