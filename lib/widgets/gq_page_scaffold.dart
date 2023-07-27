import 'package:flutter/material.dart';
import 'package:green_quest_frontend/style/colors.dart';

class GqPageScaffold extends StatelessWidget {
  const GqPageScaffold({
    required this.title,
    required this.onBack,
    required this.body,
    this.actions = const [],
    this.floatingActionButton,
    this.scrollContainer = true,
    super.key,
  });

  final String title;
  final void Function() onBack;
  final Widget body;
  final Widget? floatingActionButton;
  final bool scrollContainer;
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        actions: actions,
        title: Text(
          title,
          style: const TextStyle(color: green, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_outlined),
          color: green,
          onPressed: onBack,
        ),
        elevation: 0,
      ),
      body: scrollContainer ? SingleChildScrollView(child: body) : body,
      floatingActionButton: floatingActionButton,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
