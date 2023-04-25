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
      path: '/ranking',
      builder: (BuildContext context, GoRouterState state) {
        return const HomeScreen();
      },
    ),
    GoRoute(
      path: '/shop',
      builder: (BuildContext context, GoRouterState state) {
        return const HomeScreen();
      },
    ),
    GoRoute(
      path: '/settings',
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
      path: '/feed/create/:id',
      name: 'feed_create_post',
      builder: (BuildContext context, GoRouterState state) {
        final feedId = state.params['id'];
        if (feedId == null) return const SizedBox();
        return FeedPostCreateScreen(
          feedId: int.parse(feedId),
        );
      },
    ),
    GoRoute(
      path: '/feed/:id',
      name: 'feed_post_list',
      builder: (BuildContext context, GoRouterState state) {
        final feedId = state.params['id'];
        if (feedId == null) return const SizedBox();
        return FeedPostListScreen(
          feedId: int.parse(feedId),
        );
      },
    ),
  ],
);
