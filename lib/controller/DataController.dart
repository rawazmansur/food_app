import 'package:food/Model/DiscussionModel.dart';
import 'package:food/Model/topicModel.dart';
import 'package:food/database/DatabaseHelper.dart';
import 'package:get/get.dart';

class FoodDataController extends GetxController {
  var discussionsList = <DiscussionModel>[].obs;
  var topicsList = <topicModel>[].obs;
  @override
  void onInit() {
    super.onInit();
    fetchDiscussions();
    fetchAllTopics();
  }

  void fetchDiscussions() async {
    try {
      List<DiscussionModel> discussions =
          await DatabaseHelper().getAllDiscussions();
      discussionsList.assignAll(discussions);
    } catch (e) {
      print('Error fetching discussions: $e');
    }
  } 
 

  void fetchAllTopics() async {
    try {
      List<topicModel> topics = await DatabaseHelper().getAllTopics();
      topicsList.assignAll(topics);
    } catch (e) {
      print('Error fetching discussions: $e');
    }
  }
   List<topicModel> getTopicsForDiscussion(int discussionId) {
    return topicsList.where((topic) => topic.discussionId == discussionId).toList();
  }
}
