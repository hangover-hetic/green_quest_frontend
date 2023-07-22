import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:green_quest_frontend/api/models/event.dart';
import 'package:green_quest_frontend/api/service.dart';
import 'package:green_quest_frontend/api/utils.dart';
import 'package:green_quest_frontend/style/colors.dart';
import 'package:green_quest_frontend/utils/preferences.dart';
import 'package:green_quest_frontend/widgets/loading_view.dart';
import 'package:latlong2/latlong.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/toast.dart';

class EventdetailsScreen extends StatefulWidget {
  const EventdetailsScreen({required this.eventId, super.key});

  final int eventId;

  @override
  _EventdetailsScreenState createState() => _EventdetailsScreenState();
}

class _EventdetailsScreenState extends State<EventdetailsScreen> {
  late Event event;
  bool isParticipating = false;
  late Future<void> loadingState;
  int participationId = 0;
  List<dynamic> participantsIds = [];
  int currentUserId = 0;

  @override
  void initState() {
    super.initState();
    loadingState = loadState();
  }

  Future<void> loadState() async {
    event = await ApiService.getEvent(widget.eventId);
    final user = await getUser();
    if (user == null) {
      throw Exception('User not found');
    }

    setState(() {
      currentUserId = user.id;

      participantsIds = event.participants
          .map((e) => extractIdFromUrl((e['userId'] ?? '') as String))
          .toList();
    });

    if (event.participants.isEmpty) {
      return;
    }
    for (final participation in event.participants) {
      if (extractIdFromUrl((participation['userId'] ?? '') as String) ==
          currentUserId.toString()) {
        setState(() {
          participationId = participation['id'] as int;
          isParticipating = true;
        });
      }
    }
  }

  Future<void> changeParticipationStatus(int currentUser) async {
    final e = event;
    if (!isParticipating) {
      final eventId = e.id;
      final result = await ApiService.post('api/participations', {
        'event': '/api/events/$eventId',
        'userId': '/api/users/$currentUser'
      });
      if (result == null) {
        return;
      }
      setState(() {
        participationId = result['id'] as int;
        isParticipating = true;
        participantsIds.add('$currentUser');
      });
      showSuccessToast('Vous participez à cet événement');
      return;
    }
    final result =
        await ApiService.delete('api/participations/$participationId');
    if (result == null || result == false) {
      return;
    }
    final filteredParticipantsIds = participantsIds
        .where((element) => element != currentUserId.toString())
        .toList();
    setState(() {
      participationId = 0;
      isParticipating = false;
      participantsIds = filteredParticipantsIds;
    });
    showSuccessToast('Vous ne participez plus à cet événement');
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: loadingState,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const LoadingViewWidget();
        }
        if (snapshot.hasError) {
          return Text('${snapshot.error}');
        }
        final coverUrl = event.coverUrl;

        return Scaffold(
          appBar: AppBar(
            title: Text(event.title),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                context.go('/');
              },
            ),
            backgroundColor: green,
            actions: [
              IconButton(
                icon: const Icon(Icons.rss_feed),
                onPressed: () {
                  context
                      .push('/feed/${event.id}/${event.feedId}/${event.title}');
                },
              ),
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () {
                  context.push('/edit_events/${event.id}/${event.title}');
                },
              ),
            ],
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (coverUrl != null)
                Image.network(
                  coverUrl,
                  width: double.infinity,
                  height: 200,
                  fit: BoxFit.cover,
                )
              else
                ColoredBox(
                    color: Colors.grey.shade300,
                    child: const SizedBox(
                      width: double.infinity,
                      height: 200,
                    )),
              Padding(
                padding: const EdgeInsets.all(8),
                child: Text(
                  event.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: Text(
                  event.description,
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
              ),
              SizedBox(
                height: 200,
                child: FlutterMap(
                  options: MapOptions(
                    center: LatLng(event.latitude, event.longitude),
                  ),
                  children: [
                    TileLayer(
                      urlTemplate:
                          'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      userAgentPackageName: 'dev.fleaflet.flutter_map.example',
                    ),
                    MarkerLayer(
                      markers: [
                        Marker(
                          width: 80,
                          height: 80,
                          point: LatLng(event.latitude, event.longitude),
                          builder: (ctx) => const Icon(Icons.location_pin),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          floatingActionButton: ElevatedButton(
              onPressed: () async {
                await changeParticipationStatus(currentUserId);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: green,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                padding:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
              ),
              child: Text(
                isParticipating ? 'Leave' : 'Join',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                ),
              )),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
        );
      },
    );
  }
}
