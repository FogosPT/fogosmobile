class Warning {
  final String title;
  final String description;

  Warning({
    this.title,
    this.description,
  });

  factory Warning.fromJson(Map<String, dynamic> map) {
    return new Warning(
      title: map['label'],
      description: map['description'],
    );
  }
}

class WarningMadeira {
  final String title;
  final String description;

  WarningMadeira({
    this.title,
    this.description,
  });

  factory WarningMadeira.fromJson(Map<String, dynamic> map) {
    return new WarningMadeira(
      title: map['title'],
      description: map['description'],
    );
  }
}
