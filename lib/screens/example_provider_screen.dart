import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:green_quest_frontend/providers/index.dart';

class ProviderScreen extends ConsumerWidget {
  const ProviderScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final value = ref.watch(helloWorldProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Screen'),
      ),
      body: Center(
        child: Text(
          value ?? '',
          style: const TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
