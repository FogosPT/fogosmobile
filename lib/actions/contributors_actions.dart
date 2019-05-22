import 'package:fogosmobile/models/contributor.dart';

class LoadContributorsAction {}

class ContributorsLoadedAction {
  final List<Contributor> contributors;

  ContributorsLoadedAction(this.contributors);
}
