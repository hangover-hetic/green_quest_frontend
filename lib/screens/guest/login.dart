import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:green_quest_frontend/style/colors.dart';

//import appbar.dart
import 'package:green_quest_frontend/widgets/appbar.dart';
import 'package:green_quest_frontend/widgets/gq_button.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../map_screen.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  LoginScreen createState() => LoginScreen();
}

class LoginScreen extends State<LoginForm> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String _errorMessage = '';
  String _valid = '';

  Future<void> _login() async {
    final email = _emailController.text;
    final password = _passwordController.text;

    // Appel à l'API pour l'authentification
    final response = await http.post(
      Uri.parse(
        'https://api.greenquest.timotheedurand.fr/api/login_check',
      ), // Remplacez cette URL par l'URL de votre API de connexion
      body: jsonEncode({
        'username': email,
        'password': password,
      }),
      headers: {'Content-Type': 'application/json'},
    );

    print(response.body);

    if (response.statusCode == 200) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(
          'token', jsonDecode(response.body)['token'] as String);

      _valid = 'Connexion réussie';

      final userInfo = await http.get(
        Uri.parse(
          'https://api.greenquest.timotheedurand.fr/api/me',
        ), // Remplacez cette URL par l'URL de votre API de connexion
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${prefs.getString('token')}'
        },
      );

      if (userInfo.statusCode == 200) {
        await prefs.setString('user', userInfo.body);
        print('oui');
        print(prefs.getString('user'));
      }

      if (context.mounted) {
        await Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const MapScreen()),
        );
      }
      //mettre le token en storage
    } else {
      // Afficher un message d'erreur si la connexion échoue
      setState(() {
        print(email);
        _errorMessage = 'Email ou mot de passe incorrect';
        print(_errorMessage);
      });
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
                          _errorMessage == '' ? _valid : _errorMessage,
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
