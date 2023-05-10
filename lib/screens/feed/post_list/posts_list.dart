import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:green_quest_frontend/api/models/main.dart';
import 'package:green_quest_frontend/api/service.dart';

import 'package:green_quest_frontend/screens/feed/post_list/components/feed_post_item.dart';
import 'package:green_quest_frontend/style/colors.dart';
import 'package:green_quest_frontend/widgets/gq_button.dart';
import 'package:green_quest_frontend/widgets/gq_page_scaffold.dart';
import 'package:intl/intl.dart';

import '../../../widgets/loading_view.dart';

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
    posts = ApiService.getFeedPost(widget.feedId);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<FeedPost>>(
      future: posts,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return GqPageScaffold(
            onBack: () {
              context.pop();
            },
            body: ListView(
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
            ),
            floatingActionButton: GqButton(
              onPressed: () {
                final feedId = widget.feedId;
                context.pushNamed(
                  'feed_create_post',
                  params: {
                    'feedId': feedId.toString(),
                    'eventId': widget.eventId.toString()
                  },
                );
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
