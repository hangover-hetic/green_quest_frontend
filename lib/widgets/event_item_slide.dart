import 'dart:math' show cos, sqrt, asin;

import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:green_quest_frontend/api/models/event.dart';


class EventItemSlideWidget extends StatefulWidget {
  final Event event;
  final LatLng currentPosition;

  const EventItemSlideWidget({
    Key? key,
    required this.event,
    required this.currentPosition,
  }) : super(key: key);

  @override
  _EventItemSlideWidgetState createState() => _EventItemSlideWidgetState();
}

class _EventItemSlideWidgetState extends State<EventItemSlideWidget> {
  late String _shortDescription;
  late double _distance;

  @override
  void initState() {
    super.initState();
    _shortDescription = widget.event.description.length > 50
        ? widget.event.description.substring(0, 50) + "..."
        : widget.event.description;
    _calculateDistance();
  }

  void _calculateDistance() async {
    double distanceInMeters = await Distance().as(
      LengthUnit.Meter,
      widget.currentPosition,
      LatLng(widget.event.latitude, widget.event.longitude),
    );
    setState(() {
      _distance = distanceInMeters / 1000;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.event.title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        SizedBox(height: 8),
        Text(_shortDescription),
        SizedBox(height: 8),
        _distance != null
            ? Text(
          "Distance: ${_distance.toStringAsFixed(2)} km",
          style: TextStyle(
            fontStyle: FontStyle.italic,
            color: Colors.grey,
          ),
        )
            : SizedBox(),
      ],
    );
  }
}