import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:go_router/go_router.dart';
import 'package:green_quest_frontend/api/models/event.dart';
import 'package:green_quest_frontend/api/models/user.dart';
import 'package:green_quest_frontend/api/service.dart';
import 'package:green_quest_frontend/style/colors.dart';
import 'package:green_quest_frontend/widgets/gq_button.dart';
import 'package:green_quest_frontend/widgets/loading_view.dart';
import 'package:latlong2/latlong.dart';

class EventdetailsScreen extends StatefulWidget {
  const EventdetailsScreen({required this.eventId, super.key});

  final int eventId;


  @override
  _EventdetailsScreenState createState() => _EventdetailsScreenState();
}

class _EventdetailsScreenState extends State<EventdetailsScreen> {
  late Future<Event> event;

  late Future<bool> isParticipating;
  int currentUserId = 30;

  @override
  void initState() {
    super.initState();
    event = ApiService.getEvent(widget.eventId);
    isParticipating = GetParticipationStatus(event);
  }

  Future<bool> GetParticipationStatus(Future<Event> event) async {
    Event eventEntity = await event;
    if (eventEntity.participants.isEmpty) {
      return false;
    }
    for (final participation in eventEntity.participants) {
      if (participation == currentUserId) {
        return true;
      }
    }
    return false;

  }

  Future<void> ChangeParticipationStatus(Event event, int currentUser) async {
    if (!(await isParticipating)) {
      ApiService.createParticipation(eventId: event.id.toString(), userId: currentUser.toString(), callback: () {});
    } else {
      ApiService.deleteParticipation(eventId: event.id.toString(), userId: currentUser.toString(), callback: () {});
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
              Text('Participants: ${event.participants}'),
            ],
          );
        },
      ),
      floatingActionButton: SizedBox(
        width: 140,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: ElevatedButton(
            onPressed: () async {
              ChangeParticipationStatus(await event, currentUserId as int);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0E756E),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
        );
      },
    );
  }
}
