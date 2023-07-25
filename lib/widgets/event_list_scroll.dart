import 'package:flutter/material.dart';
import 'package:green_quest_frontend/api/models/event.dart';
import 'package:green_quest_frontend/style/colors.dart';
import 'package:green_quest_frontend/widgets/event_item_slide.dart';
import 'package:latlong2/latlong.dart';

class EventListScrollWidget extends StatelessWidget {
  const EventListScrollWidget({
    super.key,
    required this.events,
    required this.currentLatLng,
    required this.canScroll,
    required this.scrollController,
  });

  final Future<List<Event>> events;
  final LatLng currentLatLng;
  final bool canScroll;
  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    return MediaQuery.removePadding(
      context: context,
      removeTop: true,
      child: ListView(
        controller: scrollController,
        physics: canScroll
            ? const ClampingScrollPhysics()
            : const NeverScrollableScrollPhysics(),
        children: <Widget>[
          const ColoredBox(
            color: green,
            child: SizedBox(
              height: 12,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
          ),
          const ColoredBox(
            color: green,
            child: SizedBox(
              height: 18,
            ),
          ),
          ColoredBox(
            color: green,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const <Widget>[
                Text(
                  'Événements',
                  style: TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: 24,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          const ColoredBox(
            color: green,
            child: SizedBox(
              height: 37,
            ),
          ),
          Container(
            padding: const EdgeInsets.only(left: 24, right: 24),
            child: Column(
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
                const SizedBox(
                  height: 24,
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
