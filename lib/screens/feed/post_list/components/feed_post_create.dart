import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class FeedPostCreateScreen extends StatefulWidget {
  const FeedPostCreateScreen({super.key});

  @override
  FeedPostCreateScreenState createState() => FeedPostCreateScreenState();
}

class FeedPostCreateScreenState extends State<FeedPostCreateScreen> {
  String title = '';
  String content = '';
  String coverUrl = '';
  XFile? cover;

  @override
  void initState() {
    super.initState();
  }

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      cover = image;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Post'),
      ),
      body: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              GestureDetector(
                onTap: pickImage,
                child: Container(
                  decoration:
                      BoxDecoration(border: Border.all(color: Colors.grey)),
                  height: 200,
                  width: 300,
                  child: const FittedBox(
                    fit: BoxFit.fitWidth,
                    child: Text(
                      "Ajouter une image",
                      style: TextStyle(fontSize: 10),
                    ),
                  ),
                ),
              ),
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
            ],
          )),
    );
  }
}
