import 'package:green_quest_frontend/api/utils.dart';

class Participation {
  Participation({
    required this.id,
    required this.roles,
    required this.eventId,
    required this.userId,
  });

  Participation.empty()
      : this(
    id: 0,
    roles: [],
    eventId: '',
    userId: '',

  );

  factory Participation.fromJson(Map<String, dynamic> json) {
    return Participation(
      id: json['id'] as int,
      roles: json['roles'] as List<dynamic>,
      eventId: extractIdFromUrl((json['event'] ?? '') as String),
      userId: extractIdFromUrl((json['userId'] ?? '') as String),
    );
  }

  final int id;
  final List<dynamic> roles;
  final String eventId;
  final String userId;

  Map<String, dynamic> toJson() {
    return {
      'roles': roles,
      'event': eventId,
      'userId': userId,
    };
  }
}
