import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:green_quest_frontend/api/models/event.dart';
import 'package:green_quest_frontend/style/colors.dart';
import 'package:latlong2/latlong.dart';

class EventItemSlideWidget extends StatefulWidget {
  const EventItemSlideWidget({
    required this.event,
    required this.currentPosition,
    super.key,
  });

  final Event event;
  final LatLng currentPosition;

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
        ? '${widget.event.description.substring(0, 50)}...'
        : widget.event.description;
    _calculateDistance();
  }

  Future<void> _calculateDistance() async {
    final distanceInMeters = const Distance().as(
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
    final width = MediaQuery
        .of(context)
        .size
        .width;
    final coverUrl = widget.event.coverUrl;
    return InkWell(
      onTap: () {
        context.push('/events/${widget.event.id}');
      },
      child: SizedBox(
        width: width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              child: coverUrl != null ? Image.network(
                coverUrl,
                fit: BoxFit.fitWidth,
              ) : ColoredBox(
                  color: Colors.grey.shade300,
                  child: const SizedBox(
                    width: double.infinity,
                    height: 200,
                  )),
            )
            ,
            const SizedBox(height: 10),
            Text(
              widget.event.title,
              style: const TextStyle(
                  fontWeight: FontWeight.bold, fontSize: 20, color: green),
            ),
            const SizedBox(height: 8),
            if (_distance != null)
              Text(
                'Distance: ${_distance.toStringAsFixed(2)} km',
                style: const TextStyle(
                  fontStyle: FontStyle.italic,
                  color: Colors.grey,
                ),
              )
            else
              const SizedBox(),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
