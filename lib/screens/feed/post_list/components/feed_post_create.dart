import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:green_quest_frontend/api/service.dart';
import 'package:image_picker/image_picker.dart';

class FeedPostCreateScreen extends StatefulWidget {
  const FeedPostCreateScreen({super.key, required this.feedId});

  final int feedId;

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
      authorId: 41,
      callback: () {
        context.go('/feed/${widget.feedId}');
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final coverFile = cover;
    Widget coverWidget = GestureDetector(
      onTap: pickImage,
      child: Container(
        decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
        height: 200,
        width: 300,
        child: const FittedBox(
          fit: BoxFit.fitWidth,
          child: Text(
            'Ajouter une image',
            style: TextStyle(fontSize: 10),
          ),
        ),
      ),
    );
    if (coverFile != null) {
      coverWidget = Image.file(coverFile);
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Post'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Column(
            children: [
              coverWidget,
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
              ElevatedButton(
                  onPressed: () => postPost(context),
                  child: const Text('Créer'),)
            ],
          ),
        ),
      ),
    );
  }
}
