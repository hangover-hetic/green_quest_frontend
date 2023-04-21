import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:green_quest_frontend/api/api_constants.dart';
import 'package:green_quest_frontend/api/models/main.dart';
import 'package:green_quest_frontend/api/models/post_test.dart';
import 'package:green_quest_frontend/api/models/event.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static Future<void> makeRequest(
    String url,
    void Function(dynamic) callback, [
    Map<String, String> headers = const {},
  ]) async {
    try {
      final response = await http.get(Uri.parse(url), headers: headers);
      if (response.statusCode == 200) {
        callback(json.decode(response.body));
      } else {
        throw Exception('Feed not found');
      }
    } catch (e) {
      log(e.toString());
      await Fluttertoast.showToast(
        msg: e.toString(),
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16,
      );
    }
  }

  static Future<List<Post>> getTestUsers() async {
    try {
      final url = Uri.parse(ApiConstants.testUrl);
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final l = json.decode(response.body) as List<dynamic>;
        final posts = List<Post>.from(
          l.map((m) => Post.fromJson(m as Map<String, dynamic>)),
        );
        return posts;
      }
    } catch (e) {
      log(e.toString());
    }
    return [];
  }

  static Future<List<FeedPost>> getFeedPost(int feedId) async {
    var posts = <FeedPost>[];
    await ApiService.makeRequest('http://localhost:8245/api/feeds/$feedId',
        (result) {
      final l = result['posts'] as List<dynamic>;
      posts = List<FeedPost>.from(
        l.map((m) => FeedPost.fromJson(m as Map<String, dynamic>)),
      );
    });
    return posts;
  }

  static Future<List<Event>> getListEvents() async {
    try {
      final url = Uri.parse("http://10.0.2.2:8245/api/events");
      final response = await http.get(
          url,
          headers: {'Accept': 'application/json'},
      );
      print('ma response $response');
      if (response.statusCode == 200) {
        print(response.body);
        final l = json.decode(response.body) as List<dynamic>;
        final events = List<Event>.from(
          l.map((m) => Event.fromJson(m as Map<String, dynamic>)));
        print('mon events $events');
        return events;
      }
    } catch(e) {print("coucou");
      log(e.toString());
    }
    return [];
  }
}
