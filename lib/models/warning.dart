class Warning {
  final String timestamp;
  final String title;
  final String description;

  Warning({
    this.timestamp,
    this.title,
    this.description,
  });

  factory Warning.fromJson(Map<String, dynamic> parsedJson) {
    return new Warning(
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
    return new WarningMadeira(
      timestamp: parsedJson['label'],
      title: parsedJson['title'],
      description: parsedJson['description'],
    );
  }
}
