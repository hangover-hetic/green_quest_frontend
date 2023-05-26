import 'dart:convert';
import 'dart:developer';

import 'package:green_quest_frontend/api/api_constants.dart';
import 'package:green_quest_frontend/api/models/event.dart';
import 'package:green_quest_frontend/api/service.dart';
import 'package:http/http.dart' as http;

class EventsServiceApi {
  static Future<List<Event>> getListEvents() async {
    var events = <Event>[];
    await ApiService.makeRequest('api/events', (result) {
      final l = result as List<dynamic>;
      events = List<Event>.from(
        l.map((m) => Event.fromJson(m as Map<String, dynamic>)),
      );
    });
    return events;
  }

  static Future<List<Event>> postEvent(data) async {
    try {
      final url = Uri.parse(ApiConstants.greenQuest);
      await http.post(
        url,
        headers: {'Content-type': 'application/json'},
        body: jsonEncode(data),
      );
    } catch (e) {
      log(e.toString());
    }
    return [];
  }

  static Future<List<Event>> updateEvent(data, id) async {
    try {
      final url = Uri.parse(ApiConstants.greenQuest + "api/events/${id}");
      await http.put(
        url,
        headers: {'Content-type': 'application/json'},
        body: jsonEncode(data),
      );
    } catch (e) {
      log(e.toString());
    }
    return [];
  }
}
