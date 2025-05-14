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

  Map<String, bool> _expandedStories = {};
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
      final easternNumbers = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];
      return number
          .toString()
          .split('')
          .map((e) => easternNumbers[int.parse(e)])
          .join('');
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
                            child: Stack(
                              children: [
                                Image.network(
                                  story.imageUrl,
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  height: 300.sp,

                                  loadingBuilder: (
                                    context,
                                    child,
                                    loadingProgress,
                                  ) {
                                    if (loadingProgress == null) {
                                      return child;
                                    } else {
                                      return SizedBox(
                                        height: 200.sp,
                                        child: Center(
                                          child: CircularProgressIndicator(
                                            value:
                                                loadingProgress
                                                            .expectedTotalBytes !=
                                                        null
                                                    ? loadingProgress
                                                            .cumulativeBytesLoaded /
                                                        (loadingProgress
                                                                .expectedTotalBytes ??
                                                            1)
                                                    : null,
                                          ),
                                        ),
                                      );
                                    }
                                  },
                                ),
                                Positioned(
                                  top: 8,
                                  left: 8,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(0.6),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Row(
                                      children: [
                                        const Icon(
                                          Icons.visibility,
                                          color: Colors.white,
                                          size: 16,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          '${story.views}',
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),

                                // Bottom-right: Likes
                                Positioned(
                                  bottom: 8,
                                  right: 8,
                                  child: GestureDetector(
                                    onTap: () async {
                                      await controller.toggleLikeStory(
                                        story.id,
                                      );
                                      setState(() {});
                                    },
                                    child: Container(
                                      height: 30.sp,

                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.black.withOpacity(0.6),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.favorite,
                                            color:
                                                isLiked
                                                    ? Colors.red
                                                    : Colors.white,
                                            size: 16,
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            '${story.likes}',
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      if (story.text.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                story.text,
                                maxLines:
                                    _expandedStories[story.id] == true
                                        ? null
                                        : 2, // Toggle between 2 lines and unlimited lines
                                overflow: TextOverflow.fade,
                                style: TextStyle(
                                  fontSize: 15.sp,
                                  fontFamily: 'ZainPeet',
                                  color: _themeController.textAppBar,
                                ),
                                textAlign: TextAlign.right,
                              ),
                              if (story.text.length >
                                  100) // Show the "see more" button only for long texts
                                TextButton(
                                  onPressed: () {
                                    setState(() {
                                      _expandedStories[story.id] =
                                          !(_expandedStories[story.id] ??
                                              false); // Toggle the expansion
                                    });
                                  },
                                  child: Text(
                                    _expandedStories[story.id] == true
                                        ? 'کەمتر ببینە' // Show "See Less" when expanded
                                        : 'زیاتر ببینە', // Show "See More" when collapsed
                                    style: TextStyle(
                                      fontFamily: 'ZainPeet',
                                      fontSize: 15.sp,
                                      fontWeight: FontWeight.bold,
                                      color:
                                          _themeController.isDarkMode.value
                                              ? Colors.amber
                                              : Colors.red,
                                    ),
                                    textAlign: TextAlign.left,
                                  ),
                                ),
                            ],
                          ),
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
