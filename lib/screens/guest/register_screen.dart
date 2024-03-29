import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:green_quest_frontend/api/service.dart';
import 'package:green_quest_frontend/screens/guest/login_screen.dart';

//import appbar.dart
import 'package:green_quest_frontend/screens/guest/widget/appbar.dart';
import 'package:green_quest_frontend/utils/toast.dart';
import 'package:green_quest_frontend/widgets/gq_button.dart';
import 'package:green_quest_frontend/widgets/gq_page_scaffold.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({super.key});

  @override
  RegisterScreen createState() => RegisterScreen();
}

class RegisterScreen extends State<RegisterForm> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _firstnameController = TextEditingController();
  final TextEditingController _lastnameController = TextEditingController();
  String _errorMessage = '';
  String _valid = '';

  Future<void> _register() async {
    final email = _emailController.text;
    final password = _passwordController.text;
    final firstname = _firstnameController.text;
    final lastname = _lastnameController.text;

    await post('api/users', {
      'email': email,
      'password': password,
      'firstname': firstname,
      'lastname': lastname,
      'exp': 0,
      'blobs': 0,
      'userIdentifier': email
    });
    showSuccessToast('Votre inscription a été effectuée avec succès');
    if (context.mounted) context.go('/login');
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return GqPageScaffold(
      title: "S'inscrire",
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
          Container(
            // Ajout de la couleur d'arrière-plan
            padding: const EdgeInsets.all(32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Créer un compte',
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
                        controller: _firstnameController,
                        decoration: const InputDecoration(labelText: 'Prénom'),
                      ),
                      TextFormField(
                        controller: _lastnameController,
                        decoration: const InputDecoration(labelText: 'Nom'),
                      ),
                      TextFormField(
                        controller: _emailController,
                        decoration: const InputDecoration(
                          labelText: 'Email',
                        ),
                      ),
                      TextFormField(
                        controller: _passwordController,
                        decoration:
                            const InputDecoration(labelText: 'Mot de passe'),
                        obscureText: true,
                      ),
                      const SizedBox(height: 16),
                      GqButton(
                        onPressed: _register,
                        text: "S'inscrire",
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
        ],
      ),
      onBack: () {
        context.pop();
      },
    );
  }
}
