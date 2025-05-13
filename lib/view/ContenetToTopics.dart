import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food/controller/DataController.dart';
import 'package:food/controller/ThemeController.dart';
import 'package:food/view/widgets/ContentText.dart';
import 'package:get/get.dart';

class Contenettotopics extends StatelessWidget {
  final int topicId;
  Contenettotopics({super.key, required this.topicId});

  final FoodDataController dataController = Get.find();

  @override
  Widget build(BuildContext context) {
    final ThemeController _themeController = Get.find();

    final topic = dataController.topicsList.firstWhereOrNull((t) => t.id == topicId);

    if (topic == null) {
      return Scaffold(
        backgroundColor: _themeController.scaffold,
        body: Center(
          child: Text(
            'Topic not found',
            style: TextStyle(
              fontSize: 20.sp,
              fontFamily: 'ZainPeet',
              color: _themeController.textNumbers,
            ),
          ),
        ),
      );
    }

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: _themeController.scaffold,
        appBar: AppBar(
          backgroundColor: _themeController.scaffold,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: _themeController.textAppBar,
            ),
            onPressed: () => Get.back(),
          ),
          centerTitle: true,
          titleTextStyle: TextStyle(
            fontSize: 24.w,
            fontFamily: 'ZainPeet',
            color: _themeController.textAppBar,
          ),
          title: Text(topic.topic),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          child: SingleChildScrollView(
            padding: EdgeInsets.only(top: 16.h),
            child: ContentText(text: topic.content),
            // child: Text(
            //   topic.content,
            //   style: TextStyle(
            //     fontSize: 20.sp,
            //     fontFamily: 'ZainPeet',
            //     color: _themeController.textAppBar,
            //     height: 1.8,
            //   ),
            //   textAlign: TextAlign.justify,
            //   textDirection: TextDirection.rtl,
            // ),
          ),
        ),
      ),
    );
  }
}
