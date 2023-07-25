import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../api/models/user.dart';

Future<void> setToken(String token) async {
  print('settoken: $token');
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('gttoken', token);
}

Future<String?> getToken() async {
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('gttoken');
  print('gettoken: $token');
  return token;
}

Future<void> setUser(String user) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('user', user);
}

Future<User?> getUser() async {
  final prefs = await SharedPreferences.getInstance();
  final stringUser = prefs.getString('user');
  if (stringUser == null) {
    return null;
  }
  final jsonUser = jsonDecode(stringUser) as Map<String, dynamic>;
  return User.fromJson(jsonUser);
}
