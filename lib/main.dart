import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:onesignal_flutter/onesignal_flutter.dart'; // Keep if you uncomment OneSignal
// import 'package:timezone/timezone.dart' as tz; // Keep if you uncomment NotificationService

// GetX Controllers
import 'package:food/controller/AudioController.dart';
import 'package:food/controller/AudioDownloaderController.dart';
import 'package:food/controller/DataController.dart';
import 'package:food/controller/FontSizeController.dart';
import 'package:food/controller/NotificationPreferenceController.dart';
import 'package:food/controller/ThemeController.dart';
import 'package:food/controller/tasbih_controller.dart';

// Views/Pages
import 'package:food/view/AudioPlayerPage.dart'; // This is your initial home page

import 'package:get/get.dart';

// A custom binding class to put all your global controllers
class InitialBindings implements Bindings {
  @override
  void dependencies() {
    Get.put(ThemeController());
    Get.put(FoodDataController());
    Get.put(FontSizeController());
   // Get.put(TasbihController());
    // Get.put(StoryRawazController()); // Uncomment if needed
    Get.put(AudioRawazController());
    Get.put(AudioDownloaderController());
    // Get.put(NotificationPreferenceController()); // Uncomment if needed
  }
}

void main() async { // Made main async because of potential async operations like NotificationService init
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  // Handle native splash screen
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  // It's usually good to remove the splash after your app has loaded its initial data
  // For now, it's removed immediately as in your original code.
  FlutterNativeSplash.remove(); 

  // --- LOCAL NOTIFICATION SETUP (Commented out in original, keeping as is) ---
  // await NotificationService.init();
  // tz.initializeTimeZones();
  // await NotificationService.scheduleDailyNotificationsAt9AMAnd9PM();

  // --- OneSignal SETUP (Commented out in original, keeping as is) ---
  // await Future.delayed(const Duration(seconds: 3)); // If you need a delay for splash before OneSignal init
  // OneSignal.Debug.setLogLevel(OSLogLevel.verbose);
  // OneSignal.initialize('4cb901f9-5de8-4c37-b88e-2c2ba4f55c57');
  // OneSignal.Notifications.requestPermission(true);
  // OneSignal.Notifications.addForegroundWillDisplayListener((event) {
  //   print(
  //     "Notification received in foreground: ${event.notification.jsonRepresentation()}",
  //   );
  // });
  // OneSignal.Notifications.addClickListener((event) {
  //   print("User clicked: ${event.notification.jsonRepresentation()}");
  // });

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812), // Ensure this matches your design's base resolution
      minTextAdapt: true,
      splitScreenMode: true,
      // The builder is crucial here to ensure MediaQuery.of(context)
      // reflects the ScreenUtilInit and allows global text scaling control
      builder: (context, child) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          home: AudioPlayerPage(), // Your initial route
          initialBinding: InitialBindings(), // All global controllers injected here
          // This ensures that all text sizes in your app ignore the device's font scaling factor
          builder: (context, materialAppChild) {
            return MediaQuery(
              data: MediaQuery.of(context).copyWith(textScaler: TextScaler.noScaling),
              child: materialAppChild!,
            );
          },
        );
      },
    );
  }
}