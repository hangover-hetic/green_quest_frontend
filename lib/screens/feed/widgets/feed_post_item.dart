import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';

class FeedPostWidget extends StatelessWidget {
  const FeedPostWidget({
    required this.title,
    required this.content,
    required this.authorName,
    required this.createdAt,
    super.key,
    this.coverUrl,
  });

  final String title;
  final String content;
  final String? coverUrl;
  final String authorName;
  final String createdAt;

  List<Widget> getWidgets() {
    final widgets = <Widget>[];
    final imageUrl = coverUrl;
    if (imageUrl != null && imageUrl.isNotEmpty) {
      widgets.add(
        ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          child: FadeInImage.memoryNetwork(
            height: 200,
            width: double.infinity,
            placeholder: kTransparentImage,
            image: imageUrl,
            fit: BoxFit.fitWidth,
          ),
        ),
      );
      widgets.add(const SizedBox(height: 10));
    }
    widgets.add(
      Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style:
                    const TextStyle(fontWeight: FontWeight.w500, fontSize: 16)),
            const SizedBox(height: 5),
            Text(content),
            const SizedBox(height: 10),
            Text(
              '$authorName, $createdAt',
              style: const TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.grey.shade300))),
      child: Column(
        children: [...getWidgets(), const SizedBox(height: 10)],
      ),
    );
  }
}
