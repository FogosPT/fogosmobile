import 'package:fogosmobile/models/fire.dart';

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

class LoadFireMeansHistoryAction {
  final String fireId;

  LoadFireMeansHistoryAction(this.fireId);
}

class FireMeansHistoryLoadedAction {
  final List data;

  FireMeansHistoryLoadedAction(this.data);
}