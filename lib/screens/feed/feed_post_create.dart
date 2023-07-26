import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:green_quest_frontend/api/service.dart';
import 'package:green_quest_frontend/utils/preferences.dart';
import 'package:green_quest_frontend/utils/toast.dart';
import 'package:green_quest_frontend/widgets/gq_button.dart';
import 'package:green_quest_frontend/widgets/gq_page_scaffold.dart';
import 'package:green_quest_frontend/widgets/img_picker.dart';

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

  Future<void> postPost(BuildContext context) async {
    final user = await getUser();
    if (user == null) {
      if (context.mounted) context.go('/login');
      return;
    }
    final coverFile = cover;
    if (coverFile == null) {
      showErrorToast('Veuillez ajouter une image');
      return;
    }
    await multipart('api/feed_posts', {
      'title': title,
      'content': content,
      'feed': '/api/feeds/${widget.feedId}',
      'author': '/api/users/${user.id}'
    }, {
      'imageFile': coverFile
    });
    showSuccessToast('Post créé avec succès');
    if (context.mounted) context.pop(true);
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
