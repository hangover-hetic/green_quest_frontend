import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:green_quest_frontend/router.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'style/colors.dart';

Future<void> main() async {
  await dotenv.load();
  await initializeDateFormatting('fr_FR');
  runApp(const ProviderScope(child: MyApp()));
}

final theme = ThemeData(
    inputDecorationTheme: const InputDecorationTheme(
  labelStyle: TextStyle(color: green),
  border: UnderlineInputBorder(
    borderSide: BorderSide(color: grey, width: 2),
  ),
  enabledBorder: UnderlineInputBorder(
    borderSide: BorderSide(color: grey, width: 2),
  ),
  focusedBorder: UnderlineInputBorder(
    borderSide: BorderSide(color: green, width: 2),
  ),
));

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(routerConfig: router, theme: theme);
  }
}
