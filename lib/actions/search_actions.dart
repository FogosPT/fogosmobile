import 'package:fogosmobile/models/fire.dart';

class SearchIncidentsAction {
  final String concelho;
  final bool all;
  final String? after;
  final String? before;

  SearchIncidentsAction({
    required this.concelho,
    this.all = true,
    this.after,
    this.before,
  });
}

class SearchIncidentsLoadedAction {
  final List<Fire> results;

  SearchIncidentsLoadedAction(this.results);
}

class ClearSearchAction {}
