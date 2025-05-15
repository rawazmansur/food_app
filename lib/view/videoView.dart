import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food/controller/ThemeController.dart';
import 'package:food/view/AudioPlayerPage.dart';
import 'package:food/view/YoutubePage.dart';
import 'package:food/view/widgets/CustomBottomNavigationBar.dart';
import 'package:get/get.dart';

class Videoview extends StatefulWidget {
  const Videoview({super.key});

  @override
  State<Videoview> createState() => _VideoviewState();
}

class _VideoviewState extends State<Videoview> {
  ThemeController themeController = Get.find();
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: themeController.scaffold,
        appBar: AppBar(
          backgroundColor: themeController.appBar,
          title: Text(
            'وتاری ڤیدیۆی و دەنگی ',
            style: TextStyle(
              fontSize: 20.sp,
              fontFamily: 'ZainPeet',
              color: themeController.textAppBar,
            ),
          ),
        ),

        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(20.w), // Use ScreenUtil to scale padding
            child: Column(
              children: [
                // YouTube Option Container
                GestureDetector(
                  onTap: () {
                    Get.to(()=>Youtubepage());
                  },
                  child: Container(
                    padding: EdgeInsets.all(
                      15.w,
                    ), // Use ScreenUtil to scale padding
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors:
                            themeController.isDarkMode.value
                                ? [
                                  const Color.fromARGB(255, 67, 67, 67),
                                  const Color.fromARGB(255, 41, 41, 41),
                                ]
                                : const [
                                  Color.fromARGB(255, 116, 166, 252),
                                  Color.fromARGB(255, 166, 196, 247),
                                ],
                        stops: [0.0, 1.0],
                        begin: FractionalOffset.topRight,
                        end: FractionalOffset.bottomLeft,
                        tileMode: TileMode.clamp,
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.video_library,
                          color: Colors.white,
                          size: 30.sp,
                        ), // Responsive icon size
                        SizedBox(width: 10.w), // Responsive spacing
                        Text(
                          'وتاری ڤیدیۆی لە یوتوب',
                          style: TextStyle(
                            fontSize: 18.sp,
                            color: themeController.textContainer,
                            fontFamily: 'ZainPeet',
                          ), // Responsive text size
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20.h), // Responsive vertical space
                // Audio Option Container
                GestureDetector(
                  onTap: () {
                  
                   Get.to(() => AudioPlayerPage());
                  },
                  child: Container(
                    padding: EdgeInsets.all(
                      15.w,
                    ), // Use ScreenUtil to scale padding
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors:
                            themeController.isDarkMode.value
                                ? [
                                  const Color.fromARGB(255, 67, 67, 67),
                                  const Color.fromARGB(255, 41, 41, 41),
                                ]
                                : const [
                                  Color.fromARGB(255, 116, 166, 252),
                                  Color.fromARGB(255, 166, 196, 247),
                                ],
                        stops: [0.0, 1.0],
                        begin: FractionalOffset.topRight,
                        end: FractionalOffset.bottomLeft,
                        tileMode: TileMode.clamp,
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.audiotrack,
                          color: Colors.white,
                          size: 30.sp,
                        ), // Responsive icon size
                        SizedBox(width: 10.w), // Responsive spacing
                        Text(
                          'وتاری دەنگی',
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontFamily: 'ZainPeet',
                            color: themeController.textContainer,
                          ), // Responsive text size
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: CustomBottomNavigationBar(currentIndex: 1),
      ),
    );
  }
}
