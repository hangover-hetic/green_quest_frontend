import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:green_quest_frontend/api/models/main.dart';
import 'package:green_quest_frontend/widgets/date_input.dart';
import 'package:green_quest_frontend/widgets/gq_page_scaffold.dart';
import 'package:green_quest_frontend/widgets/img_picker.dart';

import '../../api/service.dart';
import '../../widgets/gq_button.dart';

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
  File? cover;
  DateTime date = DateTime.now();
  int maxParticipationNumber = 10;

  Future<void> postEvent(
    String title,
    String description,
    double latitude,
    double longitude,
    DateTime date,
    int maxParticipationNumber,
    File cover,
  ) async {
    final data = <String, String>{
      'title': title,
      'description': description,
      'longitude': longitude.toString(),
      'latitude': latitude.toString(),
      'date': date.toIso8601String(),
      'maxParticipationNumber': maxParticipationNumber.toString(),
    };
    await ApiService.makeMultipartRequest(
        'api/events', data, {'coverFile': cover});
    if (context.mounted) context.go('/map');
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final coverFile = cover;
    Widget coverWidget = ImgPicker(
      width: width,
      text: 'Cliquer pour ajouter une image',
      onSelected: (imagePath) {
        setState(() {
          cover = File(imagePath);
        });
      },
    );
    if (coverFile != null) {
      coverWidget = Image.file(
        coverFile,
        height: 200,
        width: width,
        fit: BoxFit.cover,
      );
    }
    return GqPageScaffold(
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: Center(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                coverWidget,
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Titre',
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
                  minLines: 6,
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
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
                    labelText: 'Nombre maximum de participants',
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
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
                    }),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Latitude',
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
                const SizedBox(height: 20),
                GqButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        if (!cover!.existsSync()) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("L'image n'existe pas"),
                            ),
                          );
                          return;
                        }

                        final title = _titleTEC.text;
                        final description = _descriptionTEC.text;
                        final latitude = double.parse(_latitudeTEC.text);
                        final longitude = double.parse(_longitudeTEC.text);

                        postEvent(title, description, latitude, longitude, date,
                            maxParticipationNumber, cover!);
                      }
                    },
                    text: 'Créer'),
              ],
            ),
          ),
        ),
      ),
      title: 'Créer un évènement de nettoyage',
      onBack: () {
        context.go('/map');
      },
    );
  }
}
