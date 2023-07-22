import 'dart:math';

import 'package:green_quest_frontend/api/utils.dart';
import '../utils.dart';

class Event {
  Event({
    required this.title,
    required this.description,
    required this.id,
    required this.longitude,
    required this.latitude,
    required this.feedId,
    required this.participants,
    this.coverUrl,
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
            coverUrl: '');

  factory Event.fromJson(Map<String, dynamic> json) {
    final event = Event(
      title: (json['title'] ?? '') as String,
      description: (json['description'] ?? '') as String,
      id: json['id'] as int,
      longitude: toDouble(json['longitude']),
      latitude: toDouble(json['latitude']),
      feedId: json['feed'] as int,
      coverUrl: getMediaUrl(json['coverUrl'] as String?),
      participants: json['participantIds'] as List<dynamic>,
    );
    return event;
  }

  final String title;
  final String description;
  final int id;
  final double longitude;
  final double latitude;
  final int feedId;
  final String? coverUrl;
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
