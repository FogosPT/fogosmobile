import 'package:fogosmobile/models/fire.dart';
import 'package:fogosmobile/models/fire_details.dart';

class ClearFireAction {}

class ClearFireDetailsAction {}

class ClearFireMeansAction {}

class ClearFireRiskAction {}

class FireDetailsHistoryLoadedAction {
  final DetailsHistory? data;

  FireDetailsHistoryLoadedAction(this.data);
}

class FireLoadedAction {
  final Fire? fire;

  FireLoadedAction(this.fire);
}

class FireMeansHistoryLoadedAction {
  final MeansHistory? data;

  FireMeansHistoryLoadedAction(this.data);
}

class FireRiskLoadedAction {
  final String? risk;

  FireRiskLoadedAction(this.risk);
}

class FiresLoadedAction {
  final List<Fire> fires;

  FiresLoadedAction(this.fires);
}

class LoadFireAction {
  final String? fireId;

  LoadFireAction(this.fireId);
}

class LoadFireDetailsHistoryAction {
  final String? fireId;

  LoadFireDetailsHistoryAction(this.fireId);
}

class LoadFireMeansHistoryAction {
  final String? fireId;

  LoadFireMeansHistoryAction(this.fireId);
}

class LoadFireRiskAction {
  final String? fireId;

  LoadFireRiskAction(this.fireId);
}

class LoadFiresAction {}

class SavedFireFiltersAction {
  final List<FireStatus> filters;
  SavedFireFiltersAction(this.filters);
}

class SelectFireFiltersAction {
  final FireStatus filter;
  SelectFireFiltersAction(this.filter);
}
