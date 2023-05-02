import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:green_quest_frontend/api/api_constants.dart';
import 'package:green_quest_frontend/api/models/main.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static void processError(dynamic e) {
    debugPrint(e.toString());
    Fluttertoast.showToast(
      msg: e.toString(),
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16,
    );
  }

  static Future<void> makeRequest(
    String url,
    void Function(dynamic) callback, [
    Map<String, String> headers = const {'accept': 'application/json'},
  ]) async {
    try {
      final uri = Uri.parse(ApiConstants.greenQuest + url);
      final response = await http.get(uri, headers: headers);
      final body = json.decode(response.body);
      debugPrint(body.toString());
      switch (response.statusCode) {
        case 200:
          callback(body);
          break;
        case 404:
          throw Exception('Pas trouvé');
        default:
          throw Exception(
            'Error : ${response.statusCode} ${body?.details ?? ''}',
          );
      }
    } catch (e) {
      ApiService.processError(e);
    }
  }

  static Future<void> makeMultipartRequest(
    String url,
    Map<String, String> body,
    Map<String, File> files,
    void Function(dynamic) callback, [
    Map<String, String> headers = const {},
  ]) async {
    try {
      final uri = Uri.parse(ApiConstants.greenQuest + url);
      final request = http.MultipartRequest('POST', uri);

      for (final file in files.entries) {
        final stream = http.ByteStream(file.value.openRead());
        final length = await file.value.length();
        final multipartFile = http.MultipartFile(
          'coverFile',
          stream,
          length,
          filename: file.value.path.split('/').last,
        );
        request.files.add(multipartFile);
      }

      request.fields.addAll(body);
      request.headers.addAll(headers);

      final response = await request.send();

      if (response.statusCode == 200 || response.statusCode == 201) {
        final respStr = await response.stream.bytesToString();
        callback(json.decode(respStr));
      } else {
        throw Exception('Error');
      }
    } catch (e) {
      ApiService.processError(e);
    }
  }

  static Future<void> createPost({
    required String title,
    required String content,
    required int feedId,
    required int authorId,
    required Function callback,
    File? cover,
  }) async {
    var files = <String, File>{};
    if (cover != null) {
      files = {'imageFile': cover};
    }
    await ApiService.makeMultipartRequest(
        '/api/feed_posts',
        {
          'title': title,
          'content': content,
          'feed': '/api/feeds/$feedId',
          'author': '/api/users/$authorId'
        },
        files, (p0) {
      Fluttertoast.showToast(
        msg: 'Votre post a été créé avec succès',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16,
      );
      callback();
    });
  }

  static Future<List<FeedPost>> getFeedPost(int feedId) async {
    var posts = <FeedPost>[];
    await ApiService.makeRequest('api/feeds/$feedId', (result) {
      final l = result['posts'] as List<dynamic>;
      posts = List<FeedPost>.from(
        l.map((m) => FeedPost.fromJson(m as Map<String, dynamic>)),
      );
    });
    return posts;
  }

  static Future<Event> getEvent(int eventId) async {
    var event = Event.empty();
    await ApiService.makeRequest('api/events/$eventId', (result) {
      event = Event.fromJson(result as Map<String, dynamic>);
    });
    return event;
  }

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
}
