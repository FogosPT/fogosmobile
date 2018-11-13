class Fire {
  final String sadoId;
  final int sharepointId;

  // Status
  final bool active;
  final bool important;
  final String status;
  final int statusCode;
  final String statusColor;

  final String nature;
  final String natureCode;

  // Active Fighting Means
  final int aerial;
  final int terrain;
  final int human;

  // Geography
  final String district; // distrito
  final String city; // concelho
  final String town; // freguesia
  final String local; // localidade

  final double lat;
  final double lng;

  // Chronology
  final int created;
  final String date;
  final int dateTime;
  final String time;

  Fire(
      {this.sadoId,
      this.sharepointId,
      this.active,
      this.important,
      this.status,
      this.statusCode,
      this.statusColor,
      this.nature,
      this.natureCode,
      this.aerial,
      this.terrain,
      this.human,
      this.district,
      this.city,
      this.town,
      this.local,
      this.lat,
      this.lng,
      this.created,
      this.date,
      this.dateTime,
      this.time});

  factory Fire.fromJson(Map<String, dynamic> map) {
    return new Fire(
        sadoId: map['sadoId'],
        sharepointId: map['sharepointId'],
        active: map['active'],
        important: map['important'],
        status: map['status'],
        statusCode: map['statusCode'],
        statusColor: map['statusColor'],
        nature: map['natureza'],
        natureCode: map['naturezaCode'],
        aerial: map['aerial'],
        terrain: map['terrain'],
        human: map['man'],
        district: map['district'],
        city: map['concelho'],
        town: map['freguesia'],
        local: map['localidade'],
        lat: map['lat'],
        lng: map['lng'],
        created: map['created']['sec'],
        date: map['date'],
        dateTime: map['dateTime']['sec'],
        time: map['hour']);
  }

  String get fullAddress => '$district, $city, $town, $local';
}
