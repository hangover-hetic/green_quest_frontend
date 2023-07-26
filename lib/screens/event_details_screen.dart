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
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../api/event_service.dart';
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
  bool isAuthor = false;
  late Future<void> loadingState;
  int participationId = 0;
  List<int> participantsIds = [];
  int currentUserId = 0;

  @override
  void initState() {
    super.initState();
    loadingState = loadState();
  }

  Future<void> loadState() async {
    event = await getEvent(widget.eventId);
    final user = await getUser();
    if (user == null) {
      throw Exception('User not found');
    }
    final participations = event.participations;

    setState(() {
      currentUserId = user.id;
      isAuthor = user.id == event.author.id;
    });

    if (participations != null) {
      setState(() {
        participantsIds = participations.map((e) => e.userId.id).toList();
      });

      if (event.participantsNumber == 0) {
        return;
      }

      for (final participation in participations) {
        if (participation.userId.id == currentUserId) {
          setState(() {
            participationId = participation.id;
            isParticipating = true;
          });
        }
      }
    }
  }

  Future<void> changeParticipationStatus(int currentUser) async {
    final e = event;
    if (!isParticipating) {
      final eventId = e.id;
      final result = await post('api/participations', {
        'event': '/api/events/$eventId',
        'userId': '/api/users/$currentUser'
      });
      if (result == null) {
        return;
      }
      setState(() {
        participationId = result['id'] as int;
        isParticipating = true;
        participantsIds = [...participantsIds, currentUser];
      });
      showSuccessToast('Vous participez à cet événement');
      return;
    }

    final result = await delete('api/participations/$participationId');
    if (result == null || result == false) {
      return;
    }
    final filteredParticipantsIds =
        participantsIds.where((element) => element != currentUserId).toList();
    setState(() {
      participationId = 0;
      isParticipating = false;
      participantsIds = filteredParticipantsIds;
    });
    showSuccessToast('Vous ne participez plus à cet événement');
  }

  bool showJoinButton() {
    if (isAuthor) {
      return false;
    }
    if (isParticipating) {
      return true;
    }
    if (participantsIds.length >= event.maxParticipationNumber) {
      return false;
    }
    return true;
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

        final actions = <Widget>[
          IconButton(
            icon: const Icon(Icons.rss_feed),
            onPressed: () {
              context.push('/feed/${event.id}/${event.feedId}/${event.title}');
            },
          )
        ];
        if (isAuthor) {
          actions.add(IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () async {
              final result = await context
                  .push<bool>('/edit_events/${event.id}/${event.title}');
              if (result != null) {
                await loadState();
              }
            },
          ));
        }

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
            actions: actions,
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                clipBehavior: Clip.none,
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
                  Positioned(
                    top: 183,
                    right: 20,
                    child: Container(
                      alignment: Alignment.bottomRight,
                      decoration: ShapeDecoration(
                        color: green,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      child: const Padding(
                          padding:
                              EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.water_drop, color: Colors.white),
                              Text(
                                "1500",
                                style: TextStyle(color: Colors.white),
                              )
                            ],
                          )),
                    ),
                  )
                ],
              ),
              Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Participants : ${participantsIds.length}/${event.maxParticipationNumber}',
                          style: const TextStyle(
                            fontWeight: FontWeight.w300,
                            fontSize: 15,
                          ),
                        ),
                        Text(
                          'Date : ${DateFormat.yMd().add_jm().format(event.date)}',
                          style: const TextStyle(
                            fontWeight: FontWeight.w300,
                            fontSize: 15,
                          ),
                        ),
                        Text(
                          'Auteur : ${event.author.lastname} ${event.author.firstname}',
                          style: const TextStyle(
                            fontWeight: FontWeight.w300,
                            fontSize: 15,
                          ),
                        )
                      ])),
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
              Padding(
                  padding: const EdgeInsets.all(20),
                  child: Container(
                      height: 200,
                      decoration: const BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Color(0x19000000),
                            blurRadius: 10,
                            offset: Offset(0, 4),
                            spreadRadius: 0,
                          )
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: FlutterMap(
                          options: MapOptions(
                            center: LatLng(event.latitude, event.longitude),
                          ),
                          children: [
                            TileLayer(
                              urlTemplate:
                                  'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                              userAgentPackageName:
                                  'dev.fleaflet.flutter_map.example',
                            ),
                            MarkerLayer(
                              markers: [
                                Marker(
                                  width: 80,
                                  height: 80,
                                  point:
                                      LatLng(event.latitude, event.longitude),
                                  builder: (ctx) =>
                                      const Icon(Icons.location_pin),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ))),
            ],
          ),
          floatingActionButton: showJoinButton()
              ? ElevatedButton(
                  onPressed: () async {
                    await changeParticipationStatus(currentUserId);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: const EdgeInsets.symmetric(
                        vertical: 16, horizontal: 20),
                  ),
                  child: Text(
                    isParticipating ? 'Leave' : 'Join',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                    ),
                  ))
              : null,
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
        );
      },
    );
  }
}
