import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:green_quest_frontend/api/events_service.dart';
import 'package:green_quest_frontend/api/models/main.dart';
import 'package:green_quest_frontend/widgets/gq_button.dart';
import 'package:green_quest_frontend/widgets/gq_page_scaffold.dart';

final _formKey = GlobalKey<FormState>();

class EditEvent extends StatefulWidget {
  const EditEvent({
    required this.eventId,
    required this.eventName,
    super.key,
  });

  final String eventName;
  final int eventId;

  @override
  EditEventState createState() => EditEventState();
}

class EditEventState extends State<EditEvent> {
  late Future<List<Event>> sendEventToApi;
  late Future<Event> event;

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _longitudeController = TextEditingController();
  final TextEditingController _latitudeController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  Future<void> updateEvent() async {
    final title = _titleController.text;
    final description = _descriptionController.text;
    final longitude = double.parse(_longitudeController.text);
    final latitude = double.parse(_latitudeController.text);

    final data = {
      'title': title,
      'description': description,
      'longitude': longitude,
      'latitude': latitude
    };

    await EventsServiceApi.updateEvent(data, widget.eventId);
  }

  @override
  Widget build(BuildContext context) {
    return GqPageScaffold(
      title: 'Paramétrer votre évènement',
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: Center(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _titleController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Enter Something';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    labelText: 'Title',
                    hintText: 'Title',
                    contentPadding: EdgeInsets.only(bottom: 2),
                  ),
                ),
                TextFormField(
                  controller: _descriptionController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Enter Something';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    hintText: 'Description',
                    contentPadding: EdgeInsets.only(bottom: 2),
                  ),
                ),
                TextFormField(
                  controller: _longitudeController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Enter Something';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    labelText: 'longitude',
                    contentPadding: EdgeInsets.only(bottom: 2),
                  ),
                ),
                TextFormField(
                  controller: _latitudeController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Enter Something';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    labelText: 'latitude',
                    contentPadding: EdgeInsets.only(bottom: 2),
                  ),
                ),
                GqButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      updateEvent();
                    }
                  },
                  text: 'Mettre à jour',
                ),
              ],
            ),
          ),
        ),
      ),
      onBack: () {
        context.pop();
      },
    );
  }
}
