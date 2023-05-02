import 'package:flutter/material.dart';
import 'package:green_quest_frontend/api/eventsService.dart';
import 'package:green_quest_frontend/api/models/main.dart';

final _formKey = GlobalKey<FormState>();

class CreateEvent extends StatefulWidget {
  const CreateEvent({super.key});

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8),
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
                      return 'Enter Something';
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
                      return 'Enter Something';
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
                      return 'Enter Something';
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
                      return 'Enter Something';
                    }
                    return null;
                  },
                ),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Great'),
                        ),
                      );

                      final title = _titleTEC.text;
                      final description = _descriptionTEC.text;
                      final latitude = double.parse(_latitudeTEC.text);
                      final longitude = double.parse(_longitudeTEC.text);

                      postEvent(title, description, latitude, longitude);
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
