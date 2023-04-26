import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../api/models/event.dart';


class MapWithEventMarkers extends StatelessWidget {
  final MapController mapController;
  final LatLng currentLatLng;
  final Future<List<Event>> events;

  const MapWithEventMarkers({
    Key? key,
    required this.mapController,
    required this.currentLatLng,
    required this.events,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final markers = <Marker>[
      Marker(
        width: 80,
        height: 80,
        point: currentLatLng,
        builder: (context) => const Icon(
          Icons.location_pin,
          color: Colors.red,
          size: 45,
        ),
      ),
    ];

    events.then((value) => value.forEach((element) {
      markers.add(Marker(
        width: 80,
        height: 80,
        point: LatLng(element.latitude, element.longitude),
        builder: (context) => const Icon(
          Icons.location_pin,
          color: Colors.blue,
          size: 45,
        ),
      ));
    }));

    return FlutterMap(
      mapController: mapController,
      options: MapOptions(
        center: currentLatLng,
        zoom: 12,
      ),
      children: [
        TileLayer(
          urlTemplate:
          'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'dev.fleaflet.flutter_map.example',
        ),
        MarkerLayer(markers: markers),
      ],
    );
  }
}