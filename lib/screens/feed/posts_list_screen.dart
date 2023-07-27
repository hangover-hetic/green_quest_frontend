import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:green_quest_frontend/api/models/main.dart';
import 'package:green_quest_frontend/api/service.dart';
import 'package:green_quest_frontend/screens/feed/widgets/feed_post_item.dart';
import 'package:green_quest_frontend/widgets/gq_button.dart';
import 'package:green_quest_frontend/widgets/gq_page_scaffold.dart';
import 'package:green_quest_frontend/widgets/loading_view.dart';
import 'package:intl/intl.dart';

class FeedPostListScreen extends StatefulWidget {
  const FeedPostListScreen({
    super.key,
    required this.feedId,
    required this.eventId,
    required this.eventName,
  });

  final int feedId;
  final int eventId;
  final String eventName;

  @override
  FeedPostListScreenState createState() => FeedPostListScreenState();
}

class FeedPostListScreenState extends State<FeedPostListScreen> {
  late Future<List<FeedPost>> posts;

  @override
  void initState() {
    super.initState();
    loadPosts();
  }

  Future<List<FeedPost>> getFeedPost() async {
    final result =
        await get<Map<String, dynamic>>('api/feeds/${widget.feedId}');
    if (result == null) return [];
    final l = result['posts'] as List<dynamic>;
    return List<FeedPost>.from(
      l.map((m) => FeedPost.fromJson(m as Map<String, dynamic>)),
    );
  }

  void loadPosts() {
    setState(() {
      posts = getFeedPost();
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<FeedPost>>(
      future: posts,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return GqPageScaffold(
            scrollContainer: false,
            onBack: () {
              context.pop();
            },
            body: RefreshIndicator(
              child: ListView(children: [
                ...snapshot.data!.map(
                  (post) => Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        FeedPostWidget(
                          title: post.title,
                          content: post.content,
                          coverUrl: post.coverUrl,
                          authorName:
                              '@${post.author.firstname} ${post.author.lastname}',
                          createdAt: DateFormat.yMd().format(post.createdAt),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 100)
              ]),
              onRefresh: () async {
                loadPosts();
              },
            ),
            floatingActionButton: GqButton(
              onPressed: () async {
                final feedId = widget.feedId;
                final result = await context.pushNamed<bool>(
                  'feed_create_post',
                  params: {
                    'feedId': feedId.toString(),
                    'eventId': widget.eventId.toString()
                  },
                );
                if (result == true) loadPosts();
              },
              text: 'Ajouter un post',
            ),
            title: widget.eventName,
          );
        } else if (snapshot.hasError) {
          return Text('${snapshot.error}');
        }

        // By default, show a loading spinner.
        return const LoadingViewWidget();
      },
    );
  }
}
