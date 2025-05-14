import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:food/Model/StoryModel.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StoryRawazController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  var stories = <StoryModel>[].obs;
  late SharedPreferences _prefs;
  Set<String> viewedStories = {};
  @override
  void onInit() {
    super.onInit();
    _initialize();
  }

  void _initialize() async {
    _prefs = await SharedPreferences.getInstance();
    fetchStories();
  }

  // Realtime listener for stories
  void fetchStories() {
    _firestore
        .collection('stories')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .listen((event) {
          stories.value =
              event.docs
                  .map((doc) => StoryModel.fromMap(doc.id, doc.data()))
                  .toList();
        });
  }

  // Like/Unlike logic
  Future<void> likeStory(String id) async {
    final doc = _firestore.collection('stories').doc(id);
    await doc.update({'likes': FieldValue.increment(1)});
    markLikedStory(id);
  }

  Future<void> unlikeStory(String id) async {
    final doc = _firestore.collection('stories').doc(id);
    await doc.update({'likes': FieldValue.increment(-1)});
    unmarkLikedStory(id);
  }

  // Toggle Like
  Future<void> toggleLikeStory(String id) async {
    if (isLikedStory(id)) {
      await unlikeStory(id);
    } else {
      await likeStory(id);
    }
  }

  // Views (Track views if needed)

  // Local like/view tracking using SharedPreferences
  bool isLikedStory(String storyId) {
    return _prefs.getBool('liked_$storyId') ?? false;
  }

  void markLikedStory(String storyId) {
    _prefs.setBool('liked_$storyId', true);
  }

  void unmarkLikedStory(String storyId) {
    _prefs.setBool('liked_$storyId', false);
  }

  bool isViewedStory(String storyId) {
    return _prefs.getBool('viewed_$storyId') ?? false;
  }

  void markViewedStory(String storyId) {
    _prefs.setBool('viewed_$storyId', true);
  }

  void viewStory(String storyId) async {
  if (!viewedStories.contains(storyId)) {
    viewedStories.add(storyId); // Track locally

    // Update local object
    final storyIndex = stories.indexWhere((story) => story.id == storyId);
    if (storyIndex != -1) {
      stories[storyIndex].views++;

      // 🔥 Save new view count to Firestore
      final doc = _firestore.collection('stories').doc(storyId);
      await doc.update({'views': FieldValue.increment(1)});

      // Optional: mark as viewed in local storage
      markViewedStory(storyId);

      // Log analytics
      await FirebaseAnalytics.instance.logEvent(
        name: 'story_view',
        parameters: {
          'story_id': storyId,
          'timestamp': DateTime.now().toIso8601String(),
        },
      );
    }
  }
}

}
