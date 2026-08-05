import 'package:fogosmobile/models/fire.dart';

class LoadAllIncidentsAction {}

class AllIncidentsLoadedAction {
  final List<Fire> fires;

  AllIncidentsLoadedAction(this.fires);
}
