class Contributor {
  final String avatarUrl;
  final String name;
  final String login;
  final String bio;
  final String websiteUrl;
  final String location;

  Contributor({
    required this.avatarUrl,
    required this.name,
    required this.login,
    required this.bio,
    required this.websiteUrl,
    required this.location,
  });

  factory Contributor.map(Map<String, dynamic> obj) {
    return Contributor(
      avatarUrl: obj["avatar_url"],
      name: obj["name"],
      login: obj["login"],
      bio: obj["bio"],
      websiteUrl: obj["blog"],
      location: obj["location"],
    );
  }

  static Contributor fromMap(Map<String, dynamic> obj) => Contributor.map(obj);
  static List<Contributor> fromList(List<dynamic> obj) {
    return obj.cast<Map<String, dynamic>>().map(Contributor.fromMap).toList();
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = Map<String, dynamic>();

    map["avatar_url"] = avatarUrl;
    map["name"] = name;
    map["login"] = location;
    map["bio"] = bio;
    map["blog"] = websiteUrl;
    map["location"] = location;
    return map;
  }
}
