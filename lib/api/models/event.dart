import 'package:green_quest_frontend/api/utils.dart';

class Event {
  Event({
    required this.title,
    required this.description,
    required this.id,
    required this.longitude,
    required this.latitude,
    required this.feedId,
  });

  Event.empty()
      : this(
          title: '',
          description: '',
          id: 0,
          longitude: 0,
          latitude: 0,
          feedId: '',
        );

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      title: (json['title'] ?? '') as String,
      description: (json['description'] ?? '') as String,
      id: json['id'] as int,
      longitude: json['longitude'] as double,
      latitude: json['latitude'] as double,
      feedId: extractIdFromUrl((json['feed'] ?? '') as String),
    );
  }

  final String title;
  final String description;
  final int id;
  final double longitude;
  final double latitude;
  final String feedId;

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'longitude': longitude,
      'latitude': latitude
    };
  }
}
