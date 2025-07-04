import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food/controller/AudioController.dart';
import 'package:food/controller/AudioDownloaderController.dart';
import 'package:food/controller/DataController.dart';
import 'package:food/controller/FontSizeController.dart';
import 'package:food/controller/NotificationPreferenceController.dart';
import 'package:food/controller/ThemeController.dart';
import 'package:food/controller/tasbih_controller.dart';

import 'package:food/view/AudioPlayerPage.dart';

import 'package:get/get.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  // local notification
  //await NotificationService.init();
  // tz.initializeTimeZones();
  //await NotificationService.scheduleDailyNotificationsAt9AMAnd9PM();
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  FlutterNativeSplash.remove();
  //await Future.delayed(const Duration(seconds: 3));

  // OneSignal.Debug.setLogLevel(OSLogLevel.verbose);

  // OneSignal.initialize('4cb901f9-5de8-4c37-b88e-2c2ba4f55c57');

  // Request notification permission
  //OneSignal.Notifications.requestPermission(true);
  // OneSignal.Notifications.requestPermission(true);

  // Optional: Handle foreground notification display
  // OneSignal.Notifications.addForegroundWillDisplayListener((event) {
  //   print(
  //     "Notification received in foreground: ${event.notification.jsonRepresentation()}",
  //   );
  //   // Notifications will be displayed automatically
  // });

  // Optional: Handle when the user taps a notification
  // OneSignal.Notifications.addClickListener((event) {
  //   print("User clicked: ${event.notification.jsonRepresentation()}");
  // });

  Get.put(ThemeController());
  Get.put(FoodDataController());
  Get.put(FontSizeController());
  Get.put(TasbihController());
  // Get.put(StoryRawazController());
  Get.put(AudioRawazController());
  Get.put(AudioDownloaderController());
 // Get.put(NotificationPreferenceController());

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
        home: AudioPlayerPage(),
      ),
    );
  }
}
