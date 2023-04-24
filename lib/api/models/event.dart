class Event {
  final String title;
  final String description;
  final Function(int)? id;
  final double longitude;
  final double latitude;

  Event(
      {
        required this.title,
        required this.description,
        this.id,
        required this.longitude,
        required this.latitude
      }
  );

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
        title      : (json['title'] ?? "") as String,
        description: (json['description'] ?? "") as String,
        longitude  : json['longitude'] as double,
        latitude   : json['latitude'] as double
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'longitude': longitude,
      'latitude': latitude
    };
  }
}