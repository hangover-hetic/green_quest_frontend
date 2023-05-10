import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:green_quest_frontend/api/service.dart';
import 'package:green_quest_frontend/style/colors.dart';
import 'package:green_quest_frontend/widgets/gq_button.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../widgets/gq_page_scaffold.dart';

class FeedPostCreateScreen extends StatefulWidget {
  const FeedPostCreateScreen({
    super.key,
    required this.feedId,
    required this.eventId,
  });

  final int feedId;
  final int eventId;

  @override
  FeedPostCreateScreenState createState() => FeedPostCreateScreenState();
}

class FeedPostCreateScreenState extends State<FeedPostCreateScreen> {
  String title = '';
  String content = '';
  String coverUrl = '';
  File? cover;

  @override
  void initState() {
    super.initState();
  }

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      final imagePath = image?.path;
      if (imagePath == null) {
        log('No file selected');
        return;
      }
      cover = File(imagePath);
    });
  }

  Future<void> postPost(BuildContext context) async {
    await ApiService.createPost(
      title: title,
      content: content,
      feedId: widget.feedId,
      cover: cover,
      //TODO : change authorId
      authorId: 1,
      callback: () {
        context.go('/feed/${widget.eventId}/${widget.feedId}');
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final coverFile = cover;
    Widget coverWidget = GestureDetector(
      onTap: pickImage,
      child: Container(
        decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
        height: 200,
        width: width,
        child: const Center(
          child: Text(
            'Cliquer pour ajouter une image',
            style: TextStyle(fontSize: 20),
          ),
        ),
      ),
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
      title: 'Créer un post',
      onBack: () {
        context.pop();
      },
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Column(
            children: [
              coverWidget,
              const SizedBox(height: 10),
              TextField(
                onChanged: (value) {
                  title = value;
                },
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'On a trouvé des sacs poubelles !',
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                maxLines: 10,
                onChanged: (value) {
                  content = value;
                },
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Bonne nouvelle les sacs poubelles sont arrivés.',
                ),
              ),
              const SizedBox(height: 10),
              GqButton(
                onPressed: () => postPost(context),
                text: 'Créer',
              )
            ],
          ),
        ),
      ),
    );
  }
}
