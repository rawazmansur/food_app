import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food/controller/DataController.dart';
import 'package:food/controller/FontSizeController.dart';
import 'package:food/controller/StoryController.dart';
import 'package:food/controller/ThemeController.dart';
import 'package:food/controller/tasbih_controller.dart';
import 'package:food/firebase_options.dart';
import 'package:food/services/NotficasionServices.dart';
import 'package:food/view/SplashScreen.dart';
import 'package:get/get.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:timezone/data/latest.dart' as tz;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // local notification
  await NotificationService.init();
  tz.initializeTimeZones();
  await NotificationService.scheduleDailyNotificationsAt9AMAnd9PM();

  OneSignal.Debug.setLogLevel(OSLogLevel.verbose);
  
  OneSignal.initialize('4cb901f9-5de8-4c37-b88e-2c2ba4f55c57');

  // Request notification permission
  //OneSignal.Notifications.requestPermission(true);
  OneSignal.Notifications.requestPermission(true);
  


  // Optional: Handle foreground notification display
  OneSignal.Notifications.addForegroundWillDisplayListener((event) {
    print(
      "Notification received in foreground: ${event.notification.jsonRepresentation()}",
    );
    // Notifications will be displayed automatically
  });

  // Optional: Handle when the user taps a notification
  OneSignal.Notifications.addClickListener((event) {
    print("User clicked: ${event.notification.jsonRepresentation()}");
  });

  // Controller

  Get.put(ThemeController());
  Get.put(FoodDataController());
  Get.put(FontSizeController());
  Get.put(TasbihController());
  Get.put(StoryRawazController());
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
