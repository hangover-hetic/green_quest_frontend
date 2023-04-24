import 'package:flutter/material.dart';
import 'package:green_quest_frontend/api/models/event.dart';
import 'package:latlong2/latlong.dart';
import 'package:green_quest_frontend/widgets/event_item_slide.dart';

class EventListScrollWidget extends StatelessWidget {
  final ScrollController sc;
  final Future<List<Event>> events;
  final LatLng currentLatLng;

  const EventListScrollWidget({
    Key? key,
    required this.sc,
    required this.events,
    required this.currentLatLng,
  });

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
              child: SizedBox(
                height: 12.0,
              )
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,

          ),
          Container(
            color: const Color(0xFF0E756E),
            child: SizedBox(
              height: 18.0,
            )
          ),

          Container(
            color: const Color(0xFF0E756E),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  "Explore Pittsburgh",
                  style: TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: 24.0,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          Container(
              color: const Color(0xFF0E756E),
              child: SizedBox(
                height: 37.0,
              )
          ),
          Container(
            padding: const EdgeInsets.only(left: 24.0, right: 24.0),
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
            padding: const EdgeInsets.only(left: 24.0, right: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "Events around me",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(
                  height: 12.0,
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
          SizedBox(
            height: 24,
          ),
        ],
      ),
    );
  }
}