class Warning {
  final String timestamp;
  final String title;
  final String description;

  Warning({
    required this.timestamp,
    required this.title,
    required this.description,
  });

  factory Warning.fromJson(Map<String, dynamic> parsedJson) {
    return Warning(
      timestamp: parsedJson['label'],
      title: parsedJson['title'],
      description: parsedJson['text'],
    );
  }
}

class WarningMadeira extends Warning {
  WarningMadeira({timestamp, title, description})
      : super(timestamp: timestamp, title: title, description: description);

  factory WarningMadeira.fromJson(Map<String, dynamic> parsedJson) {
    return WarningMadeira(
      timestamp: parsedJson['label'],
      title: parsedJson['title'],
      description: parsedJson['description'],
    );
  }
}
