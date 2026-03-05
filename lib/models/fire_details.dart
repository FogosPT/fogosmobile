class MeansHistory {
  final List<Means> means;

  MeansHistory({this.means = const []});

  factory MeansHistory.fromJson(List<dynamic> json) {
    List<Means> means = <Means>[];
    means = json.map((i) => Means.fromJson(i)).toList();
    return MeansHistory(means: means);
  }
}

class Means {
  final int aerial;
  final int man;
  final int terrain;
  final DateTime? label;

  Means({this.man = 0, this.aerial = 0, this.terrain = 0, this.label});

  factory Means.fromJson(Map<String, dynamic> parsedJson) {
    DateTime dateLabel =
        DateTime.fromMillisecondsSinceEpoch(
        parsedJson['created'].runtimeType == int
            ? parsedJson['created'] * 1000
            : parsedJson['created']['sec'] * 1000);

    return Means(
      man: parsedJson['man'] ?? 0,
      aerial: parsedJson['aerial'] ?? 0,
      terrain: parsedJson['terrain'] ?? 0,
      label: dateLabel,
    );
  }
}

class DetailsHistory {
  final List<Details> details;

  DetailsHistory({this.details = const []});

  factory DetailsHistory.fromJson(List<dynamic> json) {
    List<Details> details = <Details>[];
    details = json.map((i) => Details.fromJson(i)).toList();
    return DetailsHistory(details: details);
  }
}

class Details {
  final String status;
  final int statusCode;
  final DateTime? label;

  Details({this.status = '', this.statusCode = 0, this.label});

  factory Details.fromJson(Map<String, dynamic> parsedJson) {
    DateTime dateLabel =
        DateTime.fromMillisecondsSinceEpoch(
        parsedJson['created'].runtimeType == int
            ? parsedJson['created'] * 1000
            : parsedJson['created']['sec'] * 1000);
    return Details(
      status: parsedJson['status'] ?? '',
      statusCode: parsedJson['statusCode'] ?? 0,
      label: dateLabel,
    );
  }
}
