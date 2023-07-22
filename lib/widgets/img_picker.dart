import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../utils/toast.dart';

class ImgPicker extends StatelessWidget {
  const ImgPicker({
    super.key,
    required this.text,
    required this.onSelected,
    this.width = 200,
    this.maxImageKo = 1500,
  });

  final double width;
  final String text;
  final int maxImageKo; // in ko
  final void Function(String imagePath) onSelected;

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);
    final imagePath = image?.path;
    if (imagePath == null) {
      log('No file selected');
      return;
    }
    final file = File(imagePath);
    final size = await file.length();
    if (size > maxImageKo * 1000) {
      final sizeInMo = (size / 1000).round();
      log('Image trop grosse: $sizeInMo ko (max: $maxImageKo ko)');
      showErrorToast('Image trop grosse: $sizeInMo ko (max: $maxImageKo ko)');
      return;
    }
    onSelected(imagePath);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
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
  }
}
