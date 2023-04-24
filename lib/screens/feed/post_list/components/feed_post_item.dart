import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';

class FeedPostWidget extends StatelessWidget {
  const FeedPostWidget(
      {super.key,
      required this.title,
      required this.content,
      this.coverUrl,
      required this.authorName,
      required this.createdAt,});

  final String title;
  final String content;
  final String? coverUrl;
  final String authorName;
  final String createdAt;

  List<Widget> getWidgets() {
    final widgets = <Widget>[];
    final imageUrl = coverUrl;
    if (imageUrl != null && imageUrl.isNotEmpty) {
      widgets.add(ClipRRect(
        borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(10), topRight: Radius.circular(10),),
        child: FadeInImage.memoryNetwork(
          placeholder: kTransparentImage,
          image: imageUrl,
          fit: BoxFit.fitWidth,
        ),
      ),);
    }
    widgets.add(Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                authorName,
                style: const TextStyle(color: Colors.grey),
              ),
              Text(
                createdAt,
                style: const TextStyle(color: Colors.grey),
              )
            ],
          ),
          const SizedBox(height: 10),
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(content)
        ],
      ),
    ),);
    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 2,
              offset: const Offset(2, 3),
            ),
          ],
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: getWidgets(),
        ),);
  }
}
