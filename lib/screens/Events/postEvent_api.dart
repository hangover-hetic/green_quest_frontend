import 'package:flutter/material.dart';
import '../../api/models/main.dart';
import 'package:green_quest_frontend/api/eventsService.dart';

final _formKey = GlobalKey<FormState>();

class CreateEvent extends StatefulWidget {
  const CreateEvent({Key? key}) : super(key: key);

  @override
  CreateEventState createState() => CreateEventState();
}

class CreateEventState extends State<CreateEvent> {
  late Future<List<Event>> sendEventToApi;

  @override
  void initState() {
    super.initState();
  }

  final TextEditingController _titleTEC = TextEditingController();
  final TextEditingController _descriptionTEC = TextEditingController();
  final TextEditingController _latitudeTEC = TextEditingController();
  final TextEditingController _longitudeTEC = TextEditingController();

  Future<void> postEvent(
      String title,
      String description,
      double latitude,
      double longitude,
      ) async {
    final data = {
      'title': title,
      'description': description,
      'longitude': longitude,
      'latitude': latitude
    };
    await EventsServiceApi.postEvent(data);
  }

  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Title',
                    ),
                    controller: _titleTEC,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Enter Something";
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Description',
                    ),
                    controller: _descriptionTEC,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Enter Something";
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'latitude',
                    ),
                    controller: _latitudeTEC,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Enter Something";
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Longitude',
                    ),
                    controller: _longitudeTEC,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Enter Something";
                      }
                      return null;
                    },
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if(_formKey.currentState!.validate()) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Great'),
                          ),
                        );

                        final _title       = _titleTEC.text;
                        final _description = _descriptionTEC.text;
                        final _latitude    = double.parse(_latitudeTEC.text);
                        final _longitude   = double.parse(_longitudeTEC.text);

                        postEvent(_title, _description, _latitude, _longitude);
                      }
                    },
                    child: const Text('Validate'),
                  ),
                ],
              ),
            ),
          ),
        ),
    );
  }
}