import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:green_quest_frontend/api/api_constants.dart';
import 'package:green_quest_frontend/api/models/main.dart';
import 'package:green_quest_frontend/utils/preferences.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

import '../screens/guest/login.dart';
import '../utils/toast.dart';

class ApiService {
  static void processError(dynamic e) {
    debugPrint(e.toString());
    showErrorToast(e.toString());
  }

  static Uri getUrl(String url) {
    return Uri.parse(ApiConstants.greenQuest + url);
  }

  static Future<Map<String, String>> getHeaders() async {
    final headers = <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    final token = await getToken();
    if (token != null) {
      print('token: $token');
      headers['Authorization'] = 'Bearer $token';
    }
    return headers;
  }

  static Future<void> makeRequest(
    String url,
    void Function(dynamic) callback, [
    Map<String, String> headers = const {'accept': 'application/json'},
  ]) async {
    try {
      final uri = ApiService.getUrl(url);
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

  static Future<void> makePostRequest(
    String url,
    Map<String, dynamic> body,
    void Function(dynamic) callback, [
    Map<String, String> headers = const {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    },
  ]) async {
    try {
      final uri = ApiService.getUrl(url);
      final response =
          await http.post(uri, headers: headers, body: json.encode(body));
      final bodyResp = json.decode(response.body);
      print(response.statusCode);
      ApiService.handleResponse(response);
    } catch (e) {
      ApiService.processError(e);
    }
  }

  static Map<String, dynamic> handleResponse(Response response) {
    final body = json.decode(response.body);
    debugPrint('url : ${response.request?.url.toString() ?? ''}');
    switch (response.statusCode) {
      case 200:
      case 201:
      case 204:
        return body as Map<String, dynamic>;
      case 404:
        debugPrint(jsonEncode(body));
        throw Exception('Pas trouvé');
      case 401:
        setToken('');
        debugPrint(jsonEncode(body));
        throw Exception('Non autorisé');
      default:
        debugPrint(jsonEncode(body));
        throw Exception(
          'Error : ${response.statusCode} ${response.reasonPhrase}',
        );
    }
  }

  static Future<Map<String, dynamic>?> post(
      String url, Map<String, dynamic> body) async {
    try {
      final uri = ApiService.getUrl(url);
      print('post to $uri');
      final headers = await ApiService.getHeaders();
      final response =
          await http.post(uri, headers: headers, body: json.encode(body));
      return ApiService.handleResponse(response);
    } on Exception catch (e) {
      ApiService.processError(e);
    }
    return null;
  }

  static Future<Map<String, dynamic>?> get(String url) async {
    try {
      final uri = ApiService.getUrl(url);
      final headers = await ApiService.getHeaders();
      final response = await http.get(uri, headers: headers);
      return ApiService.handleResponse(response);
    } catch (e) {
      ApiService.processError(e);
    }
    return null;
  }

  static Future<void> makeDeleteRequest(
    String url,
    void Function(dynamic) callback, [
    Map<String, String> headers = const {'accept': 'application/json'},
  ]) async {
    try {
      final uri = ApiService.getUrl(url);
      final response = await http.delete(
        uri,
        headers: headers,
      );
      ApiService.handleResponse(response);
    } catch (e) {
      ApiService.processError(e);
    }
  }

  static Future<bool?> delete(String url) async {
    try {
      final uri = ApiService.getUrl(url);
      final headers = await ApiService.getHeaders();
      final response = await http.delete(
        uri,
        headers: headers,
      );
      return response.statusCode == 204;
    } catch (e) {
      ApiService.processError(e);
    }
    return null;
  }

  static Future<void> makeMultipartRequest(
    String url,
    Map<String, String> body,
    Map<String, File> files,
    void Function(dynamic) callback, [
    Map<String, String> headers = const {},
  ]) async {
    try {
      final uri = ApiService.getUrl(url);
      final request = http.MultipartRequest('POST', uri);
      if (files.isNotEmpty) {
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
      }

      request.fields.addAll(body);
      request.headers.addAll(headers);
      request.headers.addAll({'Accept': 'application/json'});

      final response = await request.send();
      print(response.statusCode);

      final respStr = await response.stream.bytesToString();
      final jsonResp = json.decode(respStr);
      if (response.statusCode == 200 || response.statusCode == 201) {
        callback(jsonResp);
      } else {
        throw Exception(
          'Error : ${response.statusCode} ${response.reasonPhrase}',
        );
      }
    } catch (e) {
      ApiService.processError(e);
    }
  }

  static Future<Map<String, dynamic>?> multipart(
      String url, Map<String, String> body, Map<String, File> files) async {
    try {
      final uri = ApiService.getUrl(url);
      final headers = await ApiService.getHeaders();
      final request = http.MultipartRequest('POST', uri);
      if (files.isNotEmpty) {
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
      }

      request.fields.addAll(body);
      request.headers.addAll(headers);

      final response = await request.send();
      final respStr = await response.stream.bytesToString();
      final jsonResp = json.decode(respStr);
      if (response.statusCode == 200 || response.statusCode == 201) {
        return jsonResp as Map<String, dynamic>;
      } else {
        throw Exception(
          'Error : ${response.statusCode} ${response.reasonPhrase}',
        );
      }
    } catch (e) {
      ApiService.processError(e);
    }
    return null;
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
    final result = await ApiService.get('api/events/$eventId');
    if (result == null) {
      throw Exception('Pas trouvé');
    }
    return Event.fromJson(result);
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

  static Future<void> createParticipation({
    required String eventId,
    required String userId,
    required Function callback,
    File? cover,
  }) async {
    await ApiService.makePostRequest(
      'api/participations',
      {"event": "\/api\/events\/$eventId", "userId": "\/api\/users\/$userId"},
      (p0) {
        Fluttertoast.showToast(
          msg: 'Vous êtes inscrit à l\'évènement',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16,
        );
        callback();
      },
    );
  }

  static Future<void> RegisterUser({
    required BuildContext context,
    required String email,
    required String password,
    required String firstname,
    required String lastname,
    required int exp,
    required int blobs,
    required Function callback,
    File? cover,
    required String userIdentifier,
  }) async {
    await ApiService.makePostRequest(
      'api/users',
      {
        'email': email,
        'password': password,
        'firstname': firstname,
        'lastname': lastname,
        'exp': 0,
        'blobs': 0,
        'userIdentifier': email
      },
      (p0) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => LoginForm(),
          ),
        );

        Fluttertoast.showToast(
          msg: 'Votre inscription a été effectuée avec succès',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16,
        );
        callback();
      },
    );
  }

  static Future<void> deleteParticipation({
    required String participationId,
    required Function callback,
  }) async {
    debugPrint('participationId: $participationId');

    await ApiService.makeDeleteRequest(
      'api/participations/$participationId',
      (p0) {
        Fluttertoast.showToast(
          msg: 'Vous êtes désinscrit',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16,
        );
        callback();
      },
    );
  }

  static Future<void> login({
    required String email,
    required String password,
    required Function callback,
  }) async {
    await ApiService.makePostRequest(
      'api/login_check',
      {'username': email, 'password': password},
      (p0) async {
        await Fluttertoast.showToast(
          msg: 'Vous êtes connecté',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16,
        );
      },
    );
  }
}
