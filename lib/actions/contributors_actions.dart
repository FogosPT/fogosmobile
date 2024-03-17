import 'package:fogosmobile/models/contributor.dart';

class ContributorsLoadedAction {
  final List<Contributor> contributors;

  const ContributorsLoadedAction(this.contributors);
}

class LoadContributorsAction {
  const LoadContributorsAction();
}
