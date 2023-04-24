import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Screen'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'I am the home screen',
              style: TextStyle(fontSize: 24),
            ),
            ElevatedButton(
              onPressed: () => context.go('/provider'),
              child: const Text('Go to the exemple provider screen'),
            ),
            ElevatedButton(
              onPressed: () => context.go('/feed/32'),
              child: const Text('Go to the exemple api screen'),
            ),
          ],
        ),
      ),
    );
  }
}
