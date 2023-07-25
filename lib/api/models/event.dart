import 'package:green_quest_frontend/api/models/participation.dart';
import 'package:green_quest_frontend/api/models/user.dart';
import 'package:green_quest_frontend/api/utils.dart';

class Event {
  Event({
    required this.title,
    required this.description,
    required this.id,
    required this.longitude,
    required this.latitude,
    required this.feedId,
    required this.participantsNumber,
    required this.date,
    required this.author,
    required this.maxParticipationNumber,
    this.coverUrl,
    this.participations,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    try {
      List<Participation>? participations;
      if (json['participations'] != null) {
        participations = (json['participations'] as List<dynamic>)
            .map((e) => Participation.fromJson(e as Map<String, dynamic>))
            .toList();
      }
      final event = Event(
          title: (json['title'] ?? '') as String,
          description: (json['description'] ?? '') as String,
          id: json['id'] as int,
          longitude: toDouble(json['longitude']),
          latitude: toDouble(json['latitude']),
          feedId: json['feed'] as int,
          coverUrl: getMediaUrl(json['coverUrl'] as String?),
          participantsNumber: json['participantsNumber'] as int,
          date: DateTime.parse(json['date'] as String),
          author: User.fromJson(json['author'] as Map<String, dynamic>),
          maxParticipationNumber: json['maxParticipationNumber'] as int,
          participations: participations);
      return event;
    } catch (e) {
      print(e);
      throw Exception('Failed to load event');
    }
  }

  final String title;
  final String description;
  final int id;
  final double longitude;
  final double latitude;
  final int feedId;
  final DateTime date;
  final User author;
  final String? coverUrl;
  final int participantsNumber;
  final int maxParticipationNumber;
  final List<Participation>? participations;

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'longitude': longitude,
      'latitude': latitude
    };
  }
}
