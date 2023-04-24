import 'package:green_quest_frontend/api/models/event.dart';
import 'dart:convert';
import 'dart:developer';
import 'package:green_quest_frontend/api/api_constants.dart';
import 'package:http/http.dart' as http;

class EventsServiceApi {
  static Future<List<Event>> getListEvents() async {
    try {
      final url = Uri.parse("https://api.greenquest.timotheedurand.fr/api/events");
      final response = await http.get(
        url,
        headers: {'Accept': 'application/json'},
      );

      if (response.statusCode == 200) {
        final l = json.decode(response.body) as List<dynamic>;
        final events = List<Event>.from(
            l.map((m) => Event.fromJson(m as Map<String, dynamic>)));
        return events;
      }
    } catch(e) {print("coucou");
    log(e.toString());
    }
    return [];
  }

  static Future<List<Event>> postEvent(data) async{
    try {
      final url = Uri.parse("https://api.greenquest.timotheedurand.fr/api/events");
      final response = await http.post(
        url,
        headers: {
          'Content-type': 'application/json'
        },
        body: jsonEncode(data)
      );
    } catch(e) {
      log(e.toString());
    }
    return[];
  }
}