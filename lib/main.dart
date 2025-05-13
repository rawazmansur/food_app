import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food/controller/DataController.dart';
import 'package:food/controller/FontSizeController.dart';
import 'package:food/controller/ThemeController.dart';
import 'package:food/controller/tasbih_controller.dart';
import 'package:food/firebase_options.dart';
import 'package:food/services/NotficasionServices.dart';
import 'package:food/view/SplashScreen.dart';
import 'package:get/get.dart';
import 'package:timezone/data/latest.dart' as tz;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  // local notification
  await NotificationService.init();
  tz.initializeTimeZones();
  await NotificationService.scheduleDailyNotificationsAt9AMAnd9PM();
  // Initialize Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // Controller
  Get.put(ThemeController());
  Get.put(FoodDataController());
  Get.put(FontSizeController());
  Get.put(TasbihController());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,

      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        home: const SplashScreen(),
      ),
    );
  }
}
