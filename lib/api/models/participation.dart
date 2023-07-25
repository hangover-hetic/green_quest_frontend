import 'package:green_quest_frontend/api/utils.dart';

import 'user.dart';

class Participation {
  Participation({
    required this.id,
    required this.roles,
    required this.eventId,
    required this.userId,
  });

  factory Participation.fromJson(Map<String, dynamic> json) {
    return Participation(
      id: json['id'] as int,
      roles: json['roles'] as List<dynamic>,
      eventId: extractIdFromUrl((json['event'] ?? '') as String),
      userId: User.fromJson(json['userId'] as Map<String, dynamic>),
    );
  }

  final int id;
  final List<dynamic> roles;
  final String eventId;
  final User userId;

  Map<String, dynamic> toJson() {
    return {
      'roles': roles,
      'event': eventId,
      'userId': userId,
    };
  }
}
