import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food/controller/ThemeController.dart';
import 'package:food/view/HomePage.dart';
import 'package:get/get.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  ThemeController themeController = Get.put(ThemeController());
  @override
  void initState() {
    super.initState();
    _navigateToHome();
  }

  void _navigateToHome() async {
    await Future.delayed(const Duration(seconds: 3));
    Get.offAll(
      () => const Homepage(),
      curve: Curves.easeIn,
      transition: Transition.fadeIn,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'بەرنامەی خۆراکی پێغەمبەر ﷺ',
              style: TextStyle(fontSize: 30.sp, fontFamily: 'ZainPeet'),
            ),
          ],
        ),
      ),
    );
  }
}
