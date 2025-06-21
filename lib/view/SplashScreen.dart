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
  final ThemeController themeController = Get.put(ThemeController());

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
    bool isDark = themeController.isDarkMode.value;

    return Scaffold(
      backgroundColor: isDark? const Color(0xFF323232) : Colors.white,
      body: Center(
        child: Image.asset(
          isDark
              ? 'assets/icon/icon-dark.png'
              : 'assets/icon/icon-light.png',
          width: 250.w,
          height: 250.w,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
