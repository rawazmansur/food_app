// import 'package:firebase_messaging/firebase_messaging.dart';

// class FCMService {
//   static Future<void> backgroundMessageHandler(RemoteMessage message) async {
//     print("Handling a background message: ${message.notification?.title}");
//   }

//   static void initialize() {
//     FirebaseMessaging.onBackgroundMessage(backgroundMessageHandler);
//     FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//       print("Message received: ${message.notification?.title}");
//       // Show a notification or handle the message as per your app's needs
//     });
//   }
// }
