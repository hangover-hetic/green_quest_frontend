class Event {

  Event(
      {
        required this.title,
        required this.description,
        required this.id,
        required this.longitude,
        required this.latitude,
      }
  );

  factory Event.fromJson(Map<String, dynamic> json) {
    print(json);
    return Event(
        title      : (json['title'] ?? '') as String,
        description: (json['description'] ?? '') as String,
        id         : json['id'] as int,
        longitude  : json['longitude'] as double,
        latitude   : json['latitude'] as double,
    );
  }
  final String title;
  final String description;
  final int id;
  final double longitude;
  final double latitude;

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'id': id,
      'longitude': longitude,
      'latitude': latitude
    };
  }
}