import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:food/controller/ThemeController.dart';
import 'package:food/view/AudioPlayerPage.dart';
import 'package:food/view/HomePage.dart';
import 'package:food/view/Settings.dart';
import 'package:food/view/Tasbihat.dart';
import 'package:food/view/YoutubePage.dart';
import 'package:food/view/utils/images.dart';
import 'package:food/view/videoView.dart';
import 'package:get/get.dart';

class CustomBottomNavigationBar extends StatefulWidget {
  final int currentIndex;

  const CustomBottomNavigationBar({super.key, required this.currentIndex});

  @override
  _CustomBottomNavigationBarState createState() =>
      _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> {
  late int _currentIndex;
  final ThemeController themeController = Get.find();

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.currentIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        ),
        child: BottomNavigationBar(
          elevation: 0,
          iconSize: 25,
          backgroundColor: themeController.appBar,
          type: BottomNavigationBarType.fixed,
          selectedLabelStyle: TextStyle(
            fontFamily: 'ZainPeet',
            fontSize: 12.sp,
            fontWeight: FontWeight.bold,
            color: themeController.iconBottonNav,
          ),
          unselectedLabelStyle: TextStyle(
            fontFamily: 'ZainPeet',
            fontSize: 12.sp,
            fontWeight: FontWeight.bold,
            color: themeController.iconBottonNav,
          ),
          currentIndex: _currentIndex,
          selectedItemColor: themeController.iconBottonNav,
          unselectedItemColor: themeController.textAppBar.withOpacity(0.6),
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
            switch (index) {
              case 0:
                Get.off(
                  () => AudioPlayerPage(),
                  transition: Transition.noTransition,
                );
                break;
              case 1:
                Get.off(
                  () => const Youtubepage(),
                  transition: Transition.noTransition,
                );
                break;
              case 2:
                Get.off(() => Homepage(), transition: Transition.noTransition);
                break;
              case 3:
                Get.off(
                  () => const Settings(),
                  transition: Transition.noTransition,
                );
                break;

              default:
                break;
            }
          },
          items: [
            BottomNavigationBarItem(
              icon: SizedBox(
                height: 30.sp,
                child: SvgPicture.asset(
                  audio,
                  color:
                      _currentIndex == 0
                          ? themeController.iconBottonNav
                          : themeController.textAppBar.withOpacity(0.6),
                ),
              ),
              label: 'وتاری دەنگی',
            ),
            BottomNavigationBarItem(
              icon: SizedBox(
                height: 30.sp,
                child: SvgPicture.asset(
                  video,
                  color:
                      _currentIndex == 1
                          ? themeController.iconBottonNav
                          : themeController.textAppBar.withOpacity(0.6),
                ),
              ),
              label: 'ڤیدیۆ',
            ),

            BottomNavigationBarItem(
              icon: SizedBox(
                height: 30.sp,
                child: SvgPicture.asset(
                  write,
                  color:
                      _currentIndex == 2
                          ? themeController.iconBottonNav
                          : themeController.textAppBar.withOpacity(0.6),
                ),
              ),
              label: 'نووسین',
            ),
            BottomNavigationBarItem(
              icon: SizedBox(
                height: 30.sp,
                child: SvgPicture.asset(
                  settings,
                  color:
                      _currentIndex == 3
                          ? themeController.iconBottonNav
                          : themeController.textAppBar.withOpacity(0.6),
                ),
              ),
              label: 'ڕێکخستن',
            ),
          ],
        ),
      ),
    );
  }
}
