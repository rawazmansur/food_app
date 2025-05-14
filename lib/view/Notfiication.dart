import 'package:flutter/material.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food/controller/StoryController.dart';
import 'package:food/controller/ThemeController.dart';
import 'package:food/view/widgets/lib/view/widgets/CustomBottomNavigationBar.dart';
import 'package:get/get.dart';
import 'package:visibility_detector/visibility_detector.dart';

class Notfiication extends StatefulWidget {
  const Notfiication({super.key});

  @override
  State<Notfiication> createState() => _NotfiicationState();
}

class _NotfiicationState extends State<Notfiication> {
  final StoryRawazController controller = Get.find();
  final ThemeController _themeController = Get.find();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    
    // Track screen view when the screen is loaded
    FirebaseAnalytics.instance.setCurrentScreen(
      screenName: 'Notification', // Specify your screen name
      screenClassOverride: 'NotfiicationScreen', // Optional - For screen class
    );
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  void _onScroll() {
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;

    if (currentScroll == maxScroll) {
      // Reached the end of the list (could be used for pagination if needed)
    }
  }

  String timeAgo(DateTime dateTime) {
    String convertToEastern(int number) {
      final easternNumbers = [
        '٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩',
      ];
      return number
          .toString()
          .split('')
          .map((e) => easternNumbers[int.parse(e)]).join('');
    }

    final Duration diff = DateTime.now().difference(dateTime);

    if (diff.inSeconds < 60) return 'ئێستا';
    if (diff.inMinutes < 60) {
      return '${convertToEastern(diff.inMinutes)} خولەک پێش ئێستا';
    }
    if (diff.inHours < 24) {
      return '${convertToEastern(diff.inHours)} کاتژمێر پێش ئێستا';
    }
    if (diff.inDays < 7) {
      return '${convertToEastern(diff.inDays)} ڕۆژ پێش ئێستا';
    }
    if (diff.inDays < 30) {
      return '${convertToEastern((diff.inDays / 7).floor())} هەفتە پێش ئێستا';
    }
    if (diff.inDays < 365) {
      return '${convertToEastern((diff.inDays / 30).floor())} مانگ پێش ئێستا';
    }
    return '${convertToEastern((diff.inDays / 365).floor())} ساڵ پێش ئێستا';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _themeController.scaffold,
      appBar: AppBar(
        backgroundColor: _themeController.appBar,
        title: Text(
          'ئاگادارکەرەوەکان',
          style: TextStyle(
            fontSize: 20.sp,
            fontFamily: 'ZainPeet',
            color: _themeController.textAppBar,
          ),
        ),
        centerTitle: true,
      ),
      body: Obx(() {
        return ListView.builder(
          controller: _scrollController,
          padding: const EdgeInsets.all(10),
          itemCount: controller.stories.length,
          itemBuilder: (context, index) {
            final story = controller.stories[index];
            final isLiked = controller.isLikedStory(story.id);

            return VisibilityDetector(
              key: Key('story_${story.id}'), // Unique key for each story
              onVisibilityChanged: (visibilityInfo) {
                if (visibilityInfo.visibleFraction > 0.5) {
                  // Story is more than 50% visible, log the event
                  controller.viewStory(story.id);
                  FirebaseAnalytics.instance.logEvent(
                    name: 'story_view',
                    parameters: {
                      'story_id': story.id,
                      'story_title': story.text,
                      'timestamp': DateTime.now().toIso8601String(),
                    },
                  );
                }
              },
              child: Container(
                margin: const EdgeInsets.only(bottom: 15),
                decoration: BoxDecoration(
                  color: _themeController.storyContainer,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(15),
                  title: Text(
                    timeAgo(story.timestamp.toDate()),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15.sp,
                      fontFamily: 'ZainPeet',
                      color: _themeController.textAppBar,
                    ),
                    textAlign: TextAlign.right,
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (story.imageUrl.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.network(
                              story.imageUrl,
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: 200,
                              loadingBuilder: (context, child, loadingProgress) {
                                if (loadingProgress == null) {
                                  return child;
                                } else {
                                  return Center(
                                    child: CircularProgressIndicator(
                                      value:
                                          loadingProgress.expectedTotalBytes !=
                                                  null
                                              ? loadingProgress
                                                      .cumulativeBytesLoaded /
                                                  (loadingProgress
                                                          .expectedTotalBytes ??
                                                      1)
                                              : null,
                                    ),
                                  );
                                }
                              },
                            ),
                          ),
                        ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              IconButton(
                                icon: Icon(
                                  Icons.favorite,
                                  color: isLiked ? Colors.red : Colors.grey,
                                ),
                                onPressed: () async {
                                  await controller.toggleLikeStory(story.id);
                                  setState(() {});
                                },
                              ),
                              Text(
                                '${story.likes}',
                                style: TextStyle(
                                  fontSize: 20.sp,
                                  color: _themeController.textAppBar,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.visibility),
                                onPressed: ()  {
                                   controller.viewStory(story.id);
                                },
                              ),
                              Text(
                                '${story.views}',
                                style: TextStyle(
                                  fontSize: 20.sp,
                                  color: _themeController.textAppBar,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      }),
      bottomNavigationBar: CustomBottomNavigationBar(currentIndex: 2),
    );
  }
}
