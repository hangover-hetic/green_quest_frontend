import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:green_quest_frontend/screens/map_screen.dart';
//import appbar.dart
import 'package:green_quest_frontend/widgets/appbar.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

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

    if (response.statusCode == 200) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(
          'token', jsonDecode(response.body)['token'] as String);

      _valid = 'Connexion réussie';

      await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const MapScreen()),
      );
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
    final screenHeight = MediaQuery.of(context).size.height;

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
                    'Welcome Back !',
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
                            prefix: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ImageIcon(
                                  AssetImage(
                                    'assets/images/icons/icon_mail.png',
                                  ),
                                  // Couleur de l'icône
                                  color: Colors.green,
                                ),
                                SizedBox(width: 8),
                                // Espacement entre l'icône et le texte
                              ],
                            ),
                            // Ajuster la hauteur de l'icône
                            contentPadding: EdgeInsets.fromLTRB(
                              0,
                              12,
                              8,
                              12,
                            ), // Ajustez les valeurs selon vos besoins
                          ),
                        ),
                        TextFormField(
                          controller: _passwordController,
                          decoration:
                              const InputDecoration(labelText: 'Mot de passe'),
                          obscureText: true,
                        ),
                        ElevatedButton(
                          onPressed: _login,
                          child: const Text('Se connecter'),
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
