import 'package:flutter/material.dart';
import 'package:green_quest_frontend/api/models/event.dart';
import 'package:green_quest_frontend/widgets/event_item_slide.dart';
import 'package:latlong2/latlong.dart';

class EventListScrollWidget extends StatelessWidget {
  const EventListScrollWidget({
    required this.sc,
    required this.events,
    required this.currentLatLng,
    super.key,
  });
  final ScrollController sc;
  final Future<List<Event>> events;
  final LatLng currentLatLng;

  @override
  Widget build(BuildContext context) {
    return MediaQuery.removePadding(
      context: context,
      removeTop: true,
      child: ListView(
        controller: sc,
        children: <Widget>[
          Container(
            color: const Color(0xFF0E756E),
            child: const SizedBox(
              height: 12,
            ),
          ),
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
          ),
          Container(
            color: const Color(0xFF0E756E),
            child: const SizedBox(
              height: 18,
            ),
          ),
          Container(
            color: const Color(0xFF0E756E),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Explore Pittsburgh',
                  style: TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: 24,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          Container(
            color: const Color(0xFF0E756E),
            child: const SizedBox(
              height: 37,
            ),
          ),
          Container(
            padding: const EdgeInsets.only(left: 24, right: 24),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.only(left: 24, right: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Text(
                  'Events around me',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),
                FutureBuilder<List<Event>>(
                  future: events,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Column(
                        children: snapshot.data!
                            .map(
                              (event) => EventItemSlideWidget(
                                event: event,
                                currentPosition: currentLatLng,
                              ),
                            )
                            .toList(),
                      );
                    } else if (snapshot.hasError) {
                      return Text('${snapshot.error}');
                    }

                    return const CircularProgressIndicator();
                  },
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 24,
          ),
        ],
      ),
    );
  }
}
