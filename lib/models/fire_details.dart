class Details {
  final String status;
  final int statusCode;
  final DateTime label;

  Details(
      {required this.status, required this.statusCode, required this.label});

  factory Details.fromJson(Map<String, dynamic> parsedJson) {
    DateTime dateLabel = DateTime.fromMillisecondsSinceEpoch(
        parsedJson['created'].runtimeType == int
            ? parsedJson['created'] * 1000
            : parsedJson['created']['sec'] * 1000);
    return Details(
      status: parsedJson['status'],
      statusCode: parsedJson['statusCode'],
      label: dateLabel,
    );
  }
}

class DetailsHistory {
  final List<Details> details;

  DetailsHistory({required this.details});

  factory DetailsHistory.fromJson(List<dynamic> json) {
    List<Details> details = <Details>[];
    details = json.map((i) => Details.fromJson(i)).toList();
    return DetailsHistory(details: details);
  }
}

class Means {
  final int aerial;
  final int man;
  final int terrain;
  final DateTime label;

  Means({
    required this.man,
    required this.aerial,
    required this.terrain,
    required this.label,
  });

  factory Means.fromJson(Map<String, dynamic> parsedJson) {
    DateTime dateLabel = DateTime.fromMillisecondsSinceEpoch(
        parsedJson['created'].runtimeType == int
            ? parsedJson['created'] * 1000
            : parsedJson['created']['sec'] * 1000);

    return Means(
      man: parsedJson['man'],
      aerial: parsedJson['aerial'],
      terrain: parsedJson['terrain'],
      label: dateLabel,
    );
  }
}

class MeansHistory {
  final List<Means>? means;

  MeansHistory({this.means});

  factory MeansHistory.fromJson(List<dynamic> json) {
    List<Means> means = <Means>[];
    means = json.map((i) => Means.fromJson(i)).toList();
    return MeansHistory(means: means);
  }
}
