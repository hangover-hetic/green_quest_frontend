import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:green_quest_frontend/screens/feed/post_list/components/feed_post_create.dart';
import 'package:green_quest_frontend/screens/feed/post_list/posts_list.dart';

import 'package:green_quest_frontend/screens/index.dart';

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
    GoRoute(
      path: '/feed/create',
      builder: (BuildContext context, GoRouterState state) {
        return const FeedPostCreateScreen();
      },
    ),
    GoRoute(
      path: '/feed/:id',
      builder: (BuildContext context, GoRouterState state) {
        return const FeedPostListScreen();
      },
    ),
  ],
);
