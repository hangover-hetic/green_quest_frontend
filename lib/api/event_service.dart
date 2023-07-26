import 'package:green_quest_frontend/api/service.dart';

import 'models/event.dart';

Future<Event> getEvent(int eventId) async {
  final result = await get<Map<String, dynamic>?>('api/events/$eventId');
  if (result == null) {
    throw Exception('Pas trouvé');
  }
  return Event.fromJson(result);
}

Future<List<Event>> getEventList() async {
  final result = await get<List<dynamic>?>('api/events');
  if (result == null) return [];
  final l = result;
  return List<Event>.from(
    l.map((e) => Event.fromJson(e as Map<String, dynamic>)),
  );
}
