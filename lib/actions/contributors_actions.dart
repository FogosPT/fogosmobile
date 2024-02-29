import 'package:fogosmobile/models/contributor.dart';

class ContributorsLoadedAction {
  final List<Contributor> contributors;

  ContributorsLoadedAction(this.contributors);
}

class LoadContributorsAction {}
