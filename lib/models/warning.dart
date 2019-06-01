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

class WarningMadeira {
  final String timestamp;
  final String title;
  final String description;

  WarningMadeira({
    this.timestamp,
    this.title,
    this.description,
  });

  factory WarningMadeira.fromJson(Map<String, dynamic> parsedJson) {
    return new WarningMadeira(
      timestamp: parsedJson['label'],
      title: parsedJson['title'],
      description: parsedJson['description'],
    );
  }
}
