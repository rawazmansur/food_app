import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food/Model/DiscussionModel.dart';
import 'package:food/controller/ThemeController.dart';
import 'package:food/database/DatabaseHelper.dart';
import 'package:food/view/TopicsPage.dart';

import 'package:food/view/widgets/CustomBottomNavigationBar.dart';
import 'package:get/get.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  late Future<List<DiscussionModel>> _discussionsFuture;

  @override
  void initState() {
    super.initState();
    _discussionsFuture = DatabaseHelper().getAllDiscussions();
  }

  final ThemeController _themeController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          backgroundColor: _themeController.scaffold,
          appBar: AppBar(
            centerTitle: true,
            title: Text(
              'بەرنامەی خۆراکی پێغەمبەر ﷺ',
              style: TextStyle(
                fontSize: 20.sp,
                fontFamily: 'ZainPeet',
                color: _themeController.textAppBar,
              ),
            ),
            backgroundColor: _themeController.appBar,
          ),
          body: FutureBuilder<List<DiscussionModel>>(
            future: _discussionsFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('No discussions found.'));
              }

              final discussions = snapshot.data!;

              return ListView(
                children: [
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: discussions.length,
                    itemBuilder: (context, index) {
                      final discussion = discussions[index];
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
                                      const Color.fromARGB(255, 41, 41, 41),
                                      const Color.fromARGB(255, 67, 67, 67),
                                    ]
                                    : const [
                                      Color.fromARGB(255, 166, 196, 247),
                                      Color.fromARGB(255, 116, 166, 252),
                                    ],
                            stops: [0.0, 1.0],
                            begin: FractionalOffset.topRight,
                            end: FractionalOffset.bottomLeft,
                            tileMode: TileMode.clamp,
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: GestureDetector(
                          onTap: () {
                            Get.to(
                              () => TopicsPage(discussionId: discussion.id),
                            );
                          },

                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  discussion.title,
                                  style: TextStyle(
                                    fontSize: 17.sp,
                                    fontWeight: FontWeight.bold,
                                    color: _themeController.textContainer,
                                    fontFamily: 'ZainPeet',
                                  ),
                                ),
                              ),
                              Container(
                                width: 27.w,
                                height: 27.w,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(7),
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  discussion.id.toString(),
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
                  ),
                ],
              );
            },
          ),
          bottomNavigationBar: CustomBottomNavigationBar(currentIndex: 0),
        ),
      ),
    );
  }
}
