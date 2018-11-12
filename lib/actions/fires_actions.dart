class LoadFiresAction {}

class FiresLoadedAction {
  final List fires;

  FiresLoadedAction(this.fires);

  @override
  String toString() {
    return 'Fires loaded {fires: $fires}';
  }
}
