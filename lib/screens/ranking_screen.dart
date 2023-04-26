import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class Rankingscreen extends StatefulWidget {
  const Rankingscreen({super.key});

  @override
  _RankingscreenState createState() => _RankingscreenState();
}

class _RankingscreenState extends State<Rankingscreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Screen'),
        leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              context.go('/');
            },),
      ),
      body: const Center(
        child: Text(
          'Ranking',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
