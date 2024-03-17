import 'package:fogosmobile/models/fire.dart';
import 'package:fogosmobile/models/fire_details.dart';

class ClearFireAction {
  const ClearFireAction();
}

class ClearFireDetailsAction {
  const ClearFireDetailsAction();
}

class ClearFireMeansAction {
  const ClearFireMeansAction();
}

class ClearFireRiskAction {
  const ClearFireRiskAction();
}

class FireDetailsHistoryLoadedAction {
  final DetailsHistory? data;

  const FireDetailsHistoryLoadedAction(this.data);
}

class FireLoadedAction {
  final Fire? fire;

  const FireLoadedAction(this.fire);
}

class FireMeansHistoryLoadedAction {
  final MeansHistory? data;

  const FireMeansHistoryLoadedAction(this.data);
}

class FireRiskLoadedAction {
  final String? risk;

  const FireRiskLoadedAction(this.risk);
}

class FiresLoadedAction {
  final List<Fire> fires;

  const FiresLoadedAction(this.fires);
}

class LoadFireAction {
  final String? fireId;

  const LoadFireAction(this.fireId);
}

class LoadFireDetailsHistoryAction {
  final String? fireId;

  const LoadFireDetailsHistoryAction(this.fireId);
}

class LoadFireMeansHistoryAction {
  final String? fireId;

  const LoadFireMeansHistoryAction(this.fireId);
}

class LoadFireRiskAction {
  final String? fireId;

  const LoadFireRiskAction(this.fireId);
}

class LoadFiresAction {
  const LoadFiresAction();
}

class SavedFireFiltersAction {
  final List<FireStatus> filters;
  const SavedFireFiltersAction(this.filters);
}

class SelectFireFiltersAction {
  final FireStatus filter;
  const SelectFireFiltersAction(this.filter);
}
