import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:green_quest_frontend/api/models/event.dart';
import 'package:green_quest_frontend/api/service.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class EventdetailsScreen extends StatefulWidget {
  const EventdetailsScreen({super.key, required this.eventId});

  final int eventId;

  @override
  _EventdetailsScreenState createState() => _EventdetailsScreenState();
}

class _EventdetailsScreenState extends State<EventdetailsScreen> {
  late Future<Event> event;

  @override
  void initState() {
    super.initState();
    event = ApiService.getEvent(widget.eventId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Screen'),
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              context.go('/');
            }),
      ),
      body: FutureBuilder<Event>(
        future: event,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Text('${snapshot.error}');
          }
          final event = snapshot.data!;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  event.title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  event.description,
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
              ),
              SizedBox(
                height: 200,
                child: FlutterMap(
                  options: MapOptions(
                    center: LatLng(event.latitude, event.longitude),
                    zoom: 13.0,
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
                            width: 80.0,
                            height: 80.0,
                            point: LatLng(event.latitude, event.longitude),
                            builder: (ctx) => Container(
                              child: Icon(Icons.location_pin),
                            ),
                          ),
                        ]),
                  ],
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: SizedBox(
        width: 140,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton(
            onPressed: () {},
            child: Text(
              'Sign Up',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
            ),
            style: ElevatedButton.styleFrom(
              primary: Color(0xFF0E756E),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
