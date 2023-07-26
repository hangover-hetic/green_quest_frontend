import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:green_quest_frontend/api/service.dart';
import 'package:green_quest_frontend/widgets/date_input.dart';
import 'package:green_quest_frontend/widgets/gq_button.dart';
import 'package:green_quest_frontend/widgets/gq_page_scaffold.dart';

import '../../api/event_service.dart';
import '../../widgets/loading_view.dart';

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
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _longitudeController = TextEditingController();
  final TextEditingController _latitudeController = TextEditingController();
  int maxParticipationNumber = 0;
  bool isLoading = true;
  DateTime date = DateTime.now();

  @override
  void initState() {
    super.initState();
    loadEvent();
  }

  Future<void> loadEvent() async {
    var event = await getEvent(widget.eventId);
    _titleController.value = TextEditingValue(text: event.title);
    _descriptionController.value = TextEditingValue(text: event.description);
    _longitudeController.value =
        TextEditingValue(text: event.longitude.toString());
    _latitudeController.value =
        TextEditingValue(text: event.latitude.toString());
    setState(() {
      maxParticipationNumber = event.maxParticipationNumber;
      date = event.date;
      isLoading = false;
    });
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
      'latitude': latitude,
      'date': date.toIso8601String(),
      'maxParticipationNumber': maxParticipationNumber,
    };

    await put('api/events/${widget.eventId}', data);
    if (context.mounted) context.pop(true);
  }

  @override
  Widget build(BuildContext context) {
    return GqPageScaffold(
      title: 'Modifier ${widget.eventName}',
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: Center(
          child: Form(
            key: _formKey,
            child: isLoading
                ? const LoadingViewWidget()
                : Column(
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
                          labelText: 'Titre',
                        ),
                      ),
                      TextFormField(
                        controller: _descriptionController,
                        minLines: 6,
                        maxLines: null,
                        keyboardType: TextInputType.multiline,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Enter Something';
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                          labelText: 'Description',
                          hintText: 'Description',
                        ),
                      ),
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Nombre maximum de participants',
                        ),
                        initialValue: maxParticipationNumber.toString(),
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        onChanged: (v) {
                          setState(() {
                            maxParticipationNumber = int.parse(v);
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Enter Something';
                          }
                          return null;
                        },
                      ),
                      DateInput(
                        date: date,
                        onChanged: (date) {
                          setState(() {
                            this.date = date;
                          });
                        },
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
                          labelText: 'Longitude',
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
                          labelText: 'Latitude',
                        ),
                      ),
                      const SizedBox(height: 20),
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
