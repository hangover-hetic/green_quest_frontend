import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import './screens/index.dart';

// GoRouter configuration
final GoRouter router = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return const HomeScreen();
      },
    ),
    GoRoute(
      path: '/provider',
      builder: (BuildContext context, GoRouterState state) {
        return const ProviderScreen();
      },
    ),
    GoRoute(
      path: '/api',
      builder: (BuildContext context, GoRouterState state) {
        return const ApiScreen();
      },
    ),
  ],
);
