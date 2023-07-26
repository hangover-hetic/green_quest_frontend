import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:go_router/go_router.dart';
import 'package:green_quest_frontend/api/models/event.dart';
import 'package:latlong2/latlong.dart';

class MapWithEventMarkers extends StatefulWidget {
  const MapWithEventMarkers({
    required this.mapController,
    required this.currentLatLng,
    required this.events,
    super.key,
  });

  final MapController mapController;
  final LatLng currentLatLng;
  final Future<List<Event>> events;

  @override
  State<StatefulWidget> createState() => _MapWithEventMarkersState();
}

class _MapWithEventMarkersState extends State<MapWithEventMarkers> {
  var markers = <Marker>[];

  @override
  void initState() {
    super.initState();
    initWidgets();
  }

  Future<void> initWidgets() async {
    final events = await widget.events;
    for (final event in events) {
      print('event: ${event.title} ${event.latitude} ${event.longitude}');
      markers.add(
        Marker(
          width: 80,
          height: 80,
          point: LatLng(event.latitude, event.longitude),
          builder: (context) => IconButton(
            onPressed: () {
              context.push('/events/${event.id}');
            },
            icon: const Icon(
              Icons.location_pin,
              color: Colors.red,
              size: 25,
            ),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final tmpMarkers = [
      ...markers,
      Marker(
        width: 80,
        height: 80,
        point: widget.currentLatLng,
        builder: (context) => const Icon(
          Icons.person,
          color: Colors.blue,
          size: 25,
        ),
      )
    ];

    return FlutterMap(
      mapController: widget.mapController,
      options: MapOptions(
        center: widget.currentLatLng,
        zoom: 12,
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'dev.fleaflet.flutter_map.example',
        ),
        MarkerLayer(markers: tmpMarkers),
      ],
    );
  }
}
