import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:green_quest_frontend/widgets/gq_page_scaffold.dart';

class ErrorScreen extends StatelessWidget {
  const ErrorScreen({this.error, super.key});

  final Exception? error;

  @override
  Widget build(BuildContext context) {
    return GqPageScaffold(
        title: "Erreur",
        onBack: () {
          context.go('/');
        },
        body: Center(
            child: Text(
                error != null ? 'Une erreur est survenue' : error.toString())));
  }
}
