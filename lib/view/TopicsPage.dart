import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food/controller/DataController.dart';
import 'package:food/controller/ThemeController.dart';
import 'package:food/view/ContenetToTopics.dart';
import 'package:food/view/widgets/ContentText.dart';
import 'package:get/get.dart';
import 'package:food/Model/DiscussionModel.dart';
import 'package:food/Model/topicModel.dart';

class TopicsPage extends StatelessWidget {
  final int discussionId;
  TopicsPage({super.key, required this.discussionId});

  final FoodDataController dataController = Get.find();

  @override
  Widget build(BuildContext context) {
    final ThemeController _themeController = Get.find();


    final DiscussionModel? discussion = dataController.discussionsList
        .firstWhereOrNull((d) => d.id == discussionId);
    List<topicModel> relatedTopics = dataController.getTopicsForDiscussion(
      discussionId,
    );

    int conuter = 0;

    return Scaffold(
      backgroundColor: _themeController.scaffold,
      appBar: AppBar(
        backgroundColor: _themeController.scaffold,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: _themeController.textAppBar),
          onPressed: () => Get.back(),
        ),
        title: Row(
          mainAxisAlignment:
              MainAxisAlignment.end, 
          children: [
            Expanded(
              child: Text(
                discussion?.title ?? 'topics',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.right, 
                style: TextStyle(
                 fontSize: 20.sp,
                  fontFamily: 'ZainPeet',
                  color: _themeController.textAppBar,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),

      body:
          discussion == null
              ? Center(
                child: Text(
                  'بوونی نیە',
                  style: TextStyle(
                    fontSize: 20.w,
                    fontFamily: 'ZainPeet',
                    color: _themeController.textNumbers,
                  ),
                ),
              )
              : (discussion.content != null && discussion.content!.isNotEmpty)
              ? Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.w),
                child: SingleChildScrollView(
                  padding: EdgeInsets.only(top: 16.h),
                  // child: Text(
                  //   discussion.content!,
                  //   style: TextStyle(
                  //     fontSize: 20.sp,
                  //     fontFamily: 'ZainPeet',
                  //     color: _themeController.textAppBar,
                  //     height: 1.8,
                  //   ),
                  //   textAlign: TextAlign.justify,
                  //   textDirection: TextDirection.rtl,
                  // ),
                  child: ContentText(text: discussion.content!),
                ),
              )
              : GetBuilder<FoodDataController>(
                builder: (controller) {
                  if (controller.topicsList.isEmpty) {
                    return Center(child: CircularProgressIndicator());
                  }

                  if (relatedTopics.isEmpty) {
                    return Center(
                      child: Text(
                        'بابەتەکان بۆ ئەم وتارە بوونیان نیە',
                        style: TextStyle(
                          fontSize: 20.sp,
                          fontFamily: 'ZainPeet',
                          color: _themeController.textNumbers,
                        ),
                      ),
                    );
                  }

                  return ListView.builder(
                    itemCount: relatedTopics.length,
                    itemBuilder: (context, index) {
                      final topic = relatedTopics[index];
                      conuter++;
                      return Container(
                        margin: EdgeInsets.symmetric(
                          horizontal: 22.w,
                          vertical: 7.h,
                        ),
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors:
                                _themeController.isDarkMode.value
                                    ? [
                                      const Color.fromARGB(
                                        255,
                                        67,
                                        67,
                                        67,
                                      ), // darker gray
                                      const Color.fromARGB(
                                        255,
                                        41,
                                        41,
                                        41,
                                      ), // darker gray
                                    ]
                                    : const [
                                      Color.fromARGB(
                                        255,
                                        56,
                                        121,
                                        200,
                                      ), // light blue
                                      Color.fromARGB(
                                        255,
                                        39,
                                        84,
                                        138,
                                      ), // darker blue
                                    ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: GestureDetector(
                          onTap: () {
                            Get.to(() => Contenettotopics(topicId: topic.id));
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  topic.topic,
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.bold,
                                    color: _themeController.textContainer,
                                    fontFamily: 'ZainPeet',
                                  ),
                                ),
                              ),
                              Container(
                                width: 35.w,
                                height: 35.w,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  conuter.toString(),
                                  style: TextStyle(
                                    fontSize: 20.sp,
                                    fontWeight: FontWeight.bold,
                                    color: _themeController.textNumbers,
                                    fontFamily: 'ZainPeet',
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
    );
  }
}
