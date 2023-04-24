import 'dart:convert';
import 'dart:developer';
import 'package:green_quest_frontend/api/api_constants.dart';
import 'package:green_quest_frontend/api/models/post_test.dart';
import 'package:green_quest_frontend/api/models/event.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static Future<List<Post>> getTestUsers() async {
    try {
      final url = Uri.parse(ApiConstants.testUrl);
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final l = json.decode(response.body) as List<dynamic>;
        final posts = List<Post>.from(
            l.map((m) => Post.fromJson(m as Map<String, dynamic>)));
        print(posts);
        return posts;
      }
    } catch (e) {
      log(e.toString());
    }
    return [];
  }
}
