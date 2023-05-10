import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:green_quest_frontend/screens/Events/postEvent_api.dart';
import 'package:green_quest_frontend/screens/event_details.dart';
import 'package:green_quest_frontend/screens/feed/post_list/components/feed_post_create.dart';
import 'package:green_quest_frontend/screens/feed/post_list/posts_list.dart';
import 'package:green_quest_frontend/screens/index.dart';
import 'package:green_quest_frontend/screens/ranking_screen.dart';
import 'package:green_quest_frontend/screens/settings_screen.dart';
import 'package:green_quest_frontend/screens/shop_screen.dart';

import 'screens/guest/login.dart';
import 'screens/guest/home.dart';

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
        return const Rankingscreen();
      },
    ),
    GoRoute(
      path: '/shop',
      builder: (BuildContext context, GoRouterState state) {
        return const ShopScreen();
      },
    ),
    GoRoute(
      path: '/settings',
      builder: (BuildContext context, GoRouterState state) {
        return const SettingsScreen();
      },
    ),
    GoRoute(
      path: '/login',
      builder: (BuildContext context, GoRouterState state) {
        return LoginForm();
      },
    ),
    GoRoute(
      path: '/api',
      builder: (BuildContext context, GoRouterState state) {
        return const ApiScreen();
      },
    ),
    GoRoute(
      path: '/events/:id',
      name: 'event',
      builder: (BuildContext context, GoRouterState state) {
        final eventId = state.params['id'];
        if (eventId == null) return const SizedBox();
        return EventdetailsScreen(
          eventId: int.parse(eventId),
        );
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
    GoRoute(
      path: '/create_event',
      builder: (BuildContext context, GoRouterState state) {
        return const CreateEvent();
      },
    ),
  ],
);
