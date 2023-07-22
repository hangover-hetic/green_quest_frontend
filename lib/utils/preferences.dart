import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../api/models/user.dart';

Future<void> setToken(String token) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('token', token);
}

Future<String?> getToken() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString('token');
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
