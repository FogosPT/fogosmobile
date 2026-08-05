import 'package:fogosmobile/models/fire.dart';

class LoadOtherFiresAction {}

class OtherFiresLoadedAction {
  final List<Fire> fires;

  OtherFiresLoadedAction(this.fires);
}
