import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:green_quest_frontend/screens/error_screen.dart';
import 'package:green_quest_frontend/screens/event/create_event_screen.dart';
import 'package:green_quest_frontend/screens/event/edit_event_screen.dart';
import 'package:green_quest_frontend/screens/event_details_screen.dart';
import 'package:green_quest_frontend/screens/feed/feed_post_create.dart';
import 'package:green_quest_frontend/screens/feed/posts_list_screen.dart';
import 'package:green_quest_frontend/screens/guest/home_screen.dart';
import 'package:green_quest_frontend/screens/guest/login_screen.dart';
import 'package:green_quest_frontend/screens/guest/register_screen.dart';
import 'package:green_quest_frontend/screens/map/map_screen.dart';
import 'package:green_quest_frontend/screens/ranking_screen.dart';
import 'package:green_quest_frontend/screens/settings_screen.dart';
import 'package:green_quest_frontend/screens/shop_screen.dart';
import 'package:green_quest_frontend/utils/preferences.dart';

// GoRouter configuration
final GoRouter router = GoRouter(
  errorBuilder: (context, state) => ErrorScreen(error: state.error),
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      redirect: (BuildContext context, GoRouterState state) async {
        final token = await getToken();
        debugPrint('token: $token');
        if (token != null && token.isNotEmpty) {
          return '/map';
        }
        return null;
      },
      builder: (BuildContext context, GoRouterState state) {
        return const HomeScreen();
      },
    ),
    GoRoute(
      path: '/register',
      builder: (BuildContext context, GoRouterState state) {
        return const RegisterForm();
      },
    ),
    GoRoute(
      path: '/map',
      builder: (BuildContext context, GoRouterState state) {
        return const MapScreen();
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
        return const LoginForm();
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
      path: '/edit_events/:id/:eventName',
      name: '/edit_events',
      builder: (BuildContext context, GoRouterState state) {
        final eventId = state.params['id'];
        final eventName = state.params['eventName'];
        if (eventId == null || eventName == null) return const SizedBox();
        return EditEvent(
          eventId: int.parse(eventId),
          eventName: eventName,
        );
      },
    ),
    GoRoute(
      path: '/feed/:eventId/:feedId/create',
      name: 'feed_create_post',
      builder: (BuildContext context, GoRouterState state) {
        final feedId = state.params['feedId'];
        final eventId = state.params['eventId'];
        if (feedId == null || eventId == null) return const SizedBox();
        return FeedPostCreateScreen(
          feedId: int.parse(feedId),
          eventId: int.parse(eventId),
        );
      },
    ),
    GoRoute(
      path: '/feed/:eventId/:feedId/:eventName',
      name: 'feed_post_list',
      builder: (BuildContext context, GoRouterState state) {
        final feedId = state.params['feedId'];
        final eventId = state.params['eventId'];
        final eventName = state.params['eventName'];
        if (feedId == null || eventId == null || eventName == null) {
          return const SizedBox();
        }
        return FeedPostListScreen(
          feedId: int.parse(feedId),
          eventId: int.parse(eventId),
          eventName: eventName,
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
