import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:green_quest_frontend/api/api_constants.dart';
import 'package:green_quest_frontend/api/models/main.dart';
import 'package:green_quest_frontend/utils/preferences.dart';
import 'package:green_quest_frontend/utils/toast.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

void processError(String url, dynamic e) {
  debugPrint('url: $url | error: ${e.toString()}');
  showErrorToast(e.toString());
}

Uri getUrl(String url) {
  return Uri.parse(ApiConstants.greenQuest + url);
}

Future<Map<String, String>> getHeaders() async {
  final headers = <String, String>{
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };
  final token = await getToken();
  if (token != null) {
    headers['Authorization'] = 'Bearer $token';
  }
  print('headers: ${headers.toString()}');
  return headers;
}

T handleResponse<T>(Response response) {
  final body = json.decode(response.body);
  debugPrint(
      'response from : ${response.request?.url.toString() ?? ''} : $body');
  switch (response.statusCode) {
    case 200:
    case 201:
    case 204:
      return body as T;
    case 404:
      debugPrint(jsonEncode(body));
      throw Exception('Pas trouvé');
    case 401:
      debugPrint(jsonEncode(body));
      if (body['message'] == 'Expired JWT Token' ||
          body['message'] == 'JWT Token not found') {
        setToken('');
      }
      throw Exception(body['detail'] ?? 'Non autorisé');

    default:
      debugPrint(jsonEncode(body));
      throw Exception(
        'Error : ${response.statusCode} ${response.reasonPhrase}',
      );
  }
}

Future<Map<String, dynamic>?> post(
    String url, Map<String, dynamic> body) async {
  try {
    final uri = getUrl(url);
    print('post to $uri');
    final headers = await getHeaders();
    final response =
        await http.post(uri, headers: headers, body: json.encode(body));
    return handleResponse(response);
  } on Exception catch (e) {
    processError(url, e);
  }
  return null;
}

Future<T?> get<T>(String url) async {
  try {
    final uri = getUrl(url);
    print('get : $uri');
    final headers = await getHeaders();
    final response = await http.get(uri, headers: headers);
    return handleResponse(response);
  } catch (e) {
    processError(url, e);
  }
  return null;
}

Future<bool?> delete(String url) async {
  try {
    final uri = getUrl(url);
    print('delete : $uri');
    final headers = await getHeaders();
    final response = await http.delete(
      uri,
      headers: headers,
    );
    return response.statusCode == 204;
  } catch (e) {
    processError(url, e);
  }
  return null;
}

Future<void> multipart(
    String url, Map<String, String> body, Map<String, File> files) async {
  try {
    final uri = getUrl(url);
    print('post (multipart) to $uri');
    final headers = await getHeaders();
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
    if ([200, 201].contains(response.statusCode) == false) {
      throw Exception(
        'Error : ${response.statusCode} ${response.reasonPhrase}',
      );
    }
  } catch (e) {
    processError(url, e);
  }
}

Future<Map<String, dynamic>?> put(String url, Map<String, dynamic> body) async {
  try {
    final uri = getUrl(url);
    print('put to $uri');
    final headers = await getHeaders();
    final response =
        await http.put(uri, headers: headers, body: json.encode(body));
    return handleResponse(response);
  } on Exception catch (e) {
    processError(url, e);
  }
  return null;
}
