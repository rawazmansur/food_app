// import 'package:get/get.dart';
// import 'package:onesignal_flutter/onesignal_flutter.dart';

// class NotificationPreferenceController extends GetxController {
//   var isNotificationEnabled = true.obs;

//   void toggleNotification(bool value) {
//     isNotificationEnabled.value = value;
//     if (value) {
//       OneSignal.Notifications.requestPermission(true);
//     } else {
//       OneSignal.Notifications.removePermissionObserver((permission) {
//         print("Notification permission removed: $permission");
//       },);
//     }
//   }
// }
