import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:green_quest_frontend/screens/map_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
//import appbar.dart
import '../../widgets/appbar.dart';

import 'package:http/http.dart' as http;

class LoginForm extends StatefulWidget {
  @override
  LoginScreen createState() => LoginScreen();
}

class LoginScreen extends State<LoginForm> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String _errorMessage = '';
  String _valid = '';

  Future<void> _login() async {
    final String email = _emailController.text;
    final String password = _passwordController.text;

    // Appel à l'API pour l'authentification
    final response = await http.post(
      Uri.parse(
          'https://api.greenquest.timotheedurand.fr/api/login_check'), // Remplacez cette URL par l'URL de votre API de connexion
      body: jsonEncode({
        'username': email,
        'password': password,
      }),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', jsonDecode(response.body)['token']);

      _valid = 'Connexion réussie';

      Navigator.push(
          context, MaterialPageRoute(builder: (context) => MapScreen()));
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
        appBar: CustomAppBar(
          key: const Key('loginAppBar'),
        ),
        body: Column(
          children: [
            Container(
              height: 215,
              // Hauteur égale à la moitié de l'écran
              child: Image.asset(
                "assets/images/bg-log.png",
                fit: BoxFit.cover,
                alignment: Alignment.topCenter,
                height: double
                    .infinity, // Hauteur maximale pour remplir tout le container
                width: double.infinity,
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(
                // Ajout de la couleur d'arrière-plan
                padding: EdgeInsets.all(32),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      "Welcome Back !",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff0E756E),
                      ),
                    ),
                    SizedBox(height: 16),
                    Padding(
                      padding: EdgeInsets.all(0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          TextFormField(
                            controller: _emailController,
                            decoration: InputDecoration(
                              labelText: 'Email',
                              prefix: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  ImageIcon(
                                    AssetImage(
                                        'assets/images/icons/icon_mail.png'),
                                    // Couleur de l'icône
                                    color: Colors.green,
                                  ),
                                  SizedBox(width: 8),
                                  // Espacement entre l'icône et le texte
                                ],
                              ),
                              // Ajuster la hauteur de l'icône
                              contentPadding: EdgeInsets.fromLTRB(0, 12, 8,
                                  12), // Ajustez les valeurs selon vos besoins
                            ),
                          ),
                          TextFormField(
                            controller: _passwordController,
                            decoration:
                                InputDecoration(labelText: 'Mot de passe'),
                            obscureText: true,
                          ),
                          ElevatedButton(
                            onPressed: _login,
                            child: Text('Se connecter'),
                          ),
                          Text(
                            _errorMessage == '' ? _valid : _errorMessage,
                            //faire un terner pour afficher en rouge si erreur et en vert si valid
                            style: TextStyle(
                              color: _errorMessage == ''
                                  ? Colors.green
                                  : Colors.red,
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
        ));
  }
}
