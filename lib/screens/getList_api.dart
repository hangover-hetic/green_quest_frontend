import 'package:flutter/material.dart';
import 'package:green_quest_frontend/api/models/main.dart';
import 'package:green_quest_frontend/api/service.dart';

class  GetListEvents extends StatefulWidget {
  const GetListEvents({super.key});

  @override
  GetListEventsState createState() => GetListEventsState();
}

class GetListEventsState extends State<GetListEvents> {
  late Future<List<Event>> events;

  @override
  void initState() {
    super.initState();
    events = ApiService.getListEvents();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('List Events'),
      ),
      body: FutureBuilder<List<Event>>(
        future: events,
        builder: (context, snapshot) {
          print(' la data $snapshot');
          if (snapshot.hasData) {
            print(snapshot.data);

          return ListView(
              children: snapshot.data!
                  .map((events) => Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(events.title, style: const TextStyle(fontWeight: FontWeight.bold),),
                      Text(events.description),
                    ],
                  ),),)
                  .toList(),);
        } else if (snapshot.hasError) {
          return Text('${snapshot.error}');
        }

        // By default, show a loading spinner.
        return const CircularProgressIndicator();
        },
      ),);

  }
}
