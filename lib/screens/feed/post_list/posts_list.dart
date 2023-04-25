import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:green_quest_frontend/api/models/main.dart';
import 'package:green_quest_frontend/api/service.dart';

import 'package:green_quest_frontend/screens/feed/post_list/components/feed_post_item.dart';
import 'package:intl/intl.dart';

class FeedPostListScreen extends StatefulWidget {
  const FeedPostListScreen({super.key, required this.feedId});

  final int feedId;

  @override
  FeedPostListScreenState createState() => FeedPostListScreenState();
}

class FeedPostListScreenState extends State<FeedPostListScreen> {
  late Future<List<FeedPost>> posts;

  @override
  void initState() {
    super.initState();
    posts = ApiService.getFeedPost(widget.feedId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Feed Post List'),
      ),
      body: FutureBuilder<List<FeedPost>>(
        future: posts,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView(
              children: snapshot.data!
                  .map(
                    (post) => Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          FeedPostWidget(
                            title: post.title,
                            content: post.content,
                            coverUrl: post.coverUrl,
                            authorName:
                                '${post.author.firstname} ${post.author.lastname}',
                            createdAt: DateFormat.yMd().format(post.createdAt),
                          ),
                        ],
                      ),
                    ),
                  )
                  .toList(),
            );
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          }

          // By default, show a loading spinner.
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
      floatingActionButton: RawMaterialButton(
        onPressed: () {
          final feedId = widget.feedId;
          context
              .goNamed('feed_create_post', params: {'id': feedId.toString()});
        },
        fillColor: Colors.white,
        padding: const EdgeInsets.all(15),
        shape: const CircleBorder(),
        child: const Icon(
          Icons.add,
          size: 35,
        ),
      ),
    );
  }
}
