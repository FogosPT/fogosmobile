import 'package:fogosmobile/models/fire.dart';
import 'package:fogosmobile/models/fire_details.dart';

class LoadFiresAction {}

class LoadFireAction {
  final String fireId;

  LoadFireAction(this.fireId);
}

class ClearFireAction {}

class FiresLoadedAction {
  final List<Fire> fires;

  FiresLoadedAction(this.fires);
}

class FireLoadedAction {
  final Fire fire;

  FireLoadedAction(this.fire);
}

class SelectFireFiltersAction {
  final FireStatus filter;
  SelectFireFiltersAction(this.filter);
}

class SavedFireFiltersAction {
  final List<FireStatus> filters;
  SavedFireFiltersAction(this.filters);
}

class LoadFireMeansHistoryAction {
  final String fireId;

  LoadFireMeansHistoryAction(this.fireId);
}

class ClearFireMeansAction {}

class FireMeansHistoryLoadedAction {
  final MeansHistory data;

  FireMeansHistoryLoadedAction(this.data);
}

class LoadFireDetailsHistoryAction {
  final String fireId;

  LoadFireDetailsHistoryAction(this.fireId);
}

class ClearFireDetailsAction {}

class FireDetailsHistoryLoadedAction {
  final DetailsHistory data;

  FireDetailsHistoryLoadedAction(this.data);
}

class LoadFireRiskAction {
  final String fireId;

  LoadFireRiskAction(this.fireId);
}

class ClearFireRiskAction {}

class FireRiskLoadedAction {
  final String risk;

  FireRiskLoadedAction(this.risk);
}
