import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:green_quest_frontend/api/service.dart';
import 'package:green_quest_frontend/style/colors.dart';
import 'package:green_quest_frontend/utils/preferences.dart';
import 'package:green_quest_frontend/widgets/appbar.dart';
import 'package:green_quest_frontend/widgets/gq_button.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  LoginScreen createState() => LoginScreen();
}

class LoginScreen extends State<LoginForm> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String _errorMessage = '';

  Future<void> _login() async {
    final email = _emailController.text;
    final password = _passwordController.text;

    final tokenResponse = await ApiService.post('api/login_check', {
      'username': email,
      'password': password,
    });

    if (tokenResponse == null) {
      setState(() {
        _errorMessage = 'Identifiants incorrects';
      });
      return;
    }

    final token = tokenResponse['token'] as String;
    await setToken(token);

    final userInfo = await ApiService.get('api/me');
    if (userInfo == null) {
      setState(() {
        _errorMessage = 'Identifiants incorrects';
      });
      return;
    }
    await setUser(jsonEncode(userInfo));

    if (context.mounted) {
      context.go('/map');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        key: Key('loginAppBar'),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 215,
            // Hauteur égale à la moitié de l'écran
            child: Image.asset(
              'assets/images/bg-log.png',
              fit: BoxFit.cover,
              alignment: Alignment.topCenter,
              height: double
                  .infinity, // Hauteur maximale pour remplir tout le container
              width: double.infinity,
            ),
          ),
          Expanded(
            child: Container(
              // Ajout de la couleur d'arrière-plan
              padding: const EdgeInsets.all(32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Bienvenue !',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff0E756E),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.all(0),
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _emailController,
                          decoration: const InputDecoration(
                            labelText: 'Email',
                            prefixIcon:
                                Icon(Icons.email_outlined, color: green),
                          ),
                        ),
                        TextFormField(
                          controller: _passwordController,
                          decoration: const InputDecoration(
                              labelText: 'Mot de passe',
                              prefixIcon: Icon(
                                Icons.lock_outline,
                                color: green,
                              )),
                          obscureText: true,
                        ),
                        const SizedBox(height: 16),
                        GqButton(
                          onPressed: _login,
                          text: 'Se connecter',
                        ),
                        Text(
                          _errorMessage,
                          //faire un terner pour afficher en rouge si erreur et en vert si valid
                          style: TextStyle(
                            color:
                                _errorMessage == '' ? Colors.green : Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
