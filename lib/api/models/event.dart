import 'package:green_quest_frontend/api/utils.dart';

class Event {
  Event({
    required this.title,
    required this.description,
    required this.id,
    required this.longitude,
    required this.latitude,
    required this.feedId,
    required this.participants,
  });

  Event.empty()
      : this(
          title: '',
          description: '',
          id: 0,
          longitude: 0,
          latitude: 0,
          feedId: 0,
          participants: [],
        );

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      title: (json['title'] ?? '') as String,
      description: (json['description'] ?? '') as String,
      id: json['id'] as int,
      longitude: double.parse((json['longitude'] ?? 0).toString()),
      latitude: double.parse((json['latitude'] ?? 0).toString()),
      feedId: json['feed'] as int,
      participants: json['participantIds'] as List<dynamic>,
    );
  }

  final String title;
  final String description;
  final int id;
  final double longitude;
  final double latitude;
  final int feedId;
  final List<dynamic> participants;

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'longitude': longitude,
      'latitude': latitude
    };
  }
}
