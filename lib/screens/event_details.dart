import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:go_router/go_router.dart';
import 'package:green_quest_frontend/api/models/event.dart';
import 'package:green_quest_frontend/api/models/user.dart';
import 'package:green_quest_frontend/api/service.dart';
import 'package:green_quest_frontend/api/utils.dart';
import 'package:green_quest_frontend/style/colors.dart';
import 'package:green_quest_frontend/widgets/gq_button.dart';
import 'package:green_quest_frontend/widgets/loading_view.dart';
import 'package:latlong2/latlong.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EventdetailsScreen extends StatefulWidget {
  const EventdetailsScreen({required this.eventId, super.key});

  final int eventId;

  @override
  _EventdetailsScreenState createState() => _EventdetailsScreenState();
}

class _EventdetailsScreenState extends State<EventdetailsScreen> {
  late Future<Event> event;

  late Future<bool> isParticipating;
  int participationId = 0;
  List<dynamic> participantsIds = [];
  int currentUserId = 0;


  @override
  void initState() {
    super.initState();


    event = ApiService.getEvent(widget.eventId);
    isParticipating = GetParticipationStatus(event);

  }

  Future<bool> GetParticipationStatus(Future<Event> event) async{
    Event eventEntity = await event;
    final prefs = await SharedPreferences.getInstance();
     currentUserId = jsonDecode(prefs.getString('user') ?? '')['id'] as int;

    participantsIds = eventEntity.participants
        .map((e) => extractIdFromUrl((e['userId'] ?? '') as String))
        .toList();
    if (eventEntity.participants.isEmpty) {
      return false;
    }
    for (final participation in eventEntity.participants) {
      if (extractIdFromUrl((participation['userId'] ?? '') as String) ==
          currentUserId.toString()) {
        participationId = participation['id'] as int;
        return true;
      }
    }
    return false;
  }

  Future<void> ChangeParticipationStatus(Event event, int currentUser) async {
    if (!(await isParticipating)) {

      await ApiService.createParticipation(
          eventId: event.id.toString(),
          userId: currentUser.toString(),
          callback: () => {
            setState(() {
              isParticipating = Future.value(true);
              participantsIds.add(currentUser.toString());
            })
          });
    } else {
      await ApiService.deleteParticipation(
          participationId: participationId.toString(),
          callback: () {
            setState(() {
              isParticipating = Future.value(false);
              participantsIds.remove(currentUser.toString());
            });
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Event>(
      future: event,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const LoadingViewWidget();
        }
        if (snapshot.hasError) {
          return Text('${snapshot.error}');
        }
        final event = snapshot.data!;
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
              ElevatedButton(
                onPressed: () {
                  context.go('/feed/${event.feedId}');
                },
                child: const Text('Go to feed'),
              ),
              Text('Participants: ${participantsIds}'),
              ElevatedButton(
                onPressed: () async {
                  await ChangeParticipationStatus(event, currentUserId);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0E756E),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: FutureBuilder<bool>(
                  future: isParticipating,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Text(
                        'Loading...',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                        ),
                      );
                    }
                    if (snapshot.hasData) {
                      return Text(
                        snapshot.data! ? 'Leave' : 'Join',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                        ),
                      );
                    }
                    return const SizedBox();
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
