import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
//import appbar.dart
import '../../widgets/appbar.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

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
                  ],
                ),
              ),
            ),
            Expanded(
                child: Column(children: [
              TextFormField(
                controller: emailController,
              )
            ]))
          ],
        ));
  }
}
