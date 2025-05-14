import 'dart:async';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:web_socket_channel/web_socket_channel.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  final WebSocketChannel channel =
      WebSocketChannel.connect(Uri.parse('wss://ntfy.sh/stories'));

  void listenForNotifications() {
    channel.stream.listen((message) {
      print('New message: $message');
      // Show a local notification or navigate the user to the story page
      _showNotification(message);
    });
  }

  void _showNotification(String message) {
    FlutterLocalNotificationsPlugin().show(
      0,
      'New Story Added!',
      message,
      NotificationDetails(
        android: AndroidNotificationDetails('story_channel', 'Stories Channel'),
      ),
    );
  }

  static Future<void> init() async {
    // Initialize timezone database
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Asia/Baghdad'));
    print('Local timezone set to: ${tz.local.name}'); // Should

    const AndroidInitializationSettings androidInitializationSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const DarwinInitializationSettings iOSInitializationSettings =
        DarwinInitializationSettings();

    const InitializationSettings initializationSettings =
        InitializationSettings(
          android: androidInitializationSettings,
          iOS: iOSInitializationSettings,
        );

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(
          AndroidNotificationChannel(
            'daily_9am_channel',
            '9 AM Reminder',
            description: 'Reminder to check the app at 9 AM',
            importance: Importance.high,
          ),
        );

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(
          AndroidNotificationChannel(
            'daily_9pm_channel',
            '9 PM Reminder',
            description: 'Reminder to check the app at 9 PM',
            importance: Importance.high,
          ),
        );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: onDidReceiveNotification,
      onDidReceiveBackgroundNotificationResponse: onDidReceiveNotification,
    );

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.requestNotificationsPermission();
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin
        >()
        ?.requestPermissions(alert: true, badge: true, sound: true);
  }

  static Future<void> onDidReceiveNotification(
    NotificationResponse notificationResponse,
  ) async {
    print("Notification received");
    // You can log something or handle specific logic if needed, but no navigation here
  }

  /// Schedule daily notifications at 9 AM and 9 PM
  static Future<void> scheduleDailyNotificationsAt9AMAnd9PM() async {
    final now = tz.TZDateTime.now(tz.local);
    print("Scheduling 9 AM notification");
    await flutterLocalNotificationsPlugin.zonedSchedule(
      1,
      'سبحان الله',
      'بەشداربە بە زیکرکردن لەگەڵمان',
      _nextInstanceOfTime(now.day, 9, 0, now),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'daily_9am_channel',
          '9 AM Reminder',
          channelDescription: 'Reminder to check the app at 9 AM',
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(),
      ),
      matchDateTimeComponents: DateTimeComponents.time,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );

    print("Scheduling 9 PM notification");
    await flutterLocalNotificationsPlugin.zonedSchedule(
      2,
      'اللە أكبر',
      'بەشداربە بە زیکرکردن لەگەڵمان',

      _nextInstanceOfTime(now.day, 21, 0, now),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'daily_9pm_channel',
          '9 PM Reminder',
          channelDescription: 'Reminder to check the app at 9 PM',
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(),
      ),

      matchDateTimeComponents: DateTimeComponents.time,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }

  /// Helper function to get the next occurrence of a given hour and minute
  static tz.TZDateTime _nextInstanceOfTime(
    int day,
    int hour,
    int minute,
    tz.TZDateTime now,
  ) {
    tz.TZDateTime scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      day,
      hour,
      minute,
    );
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    print('Now (local): $now');
    print('Scheduled (local): $scheduledDate');
    print('Scheduled (UTC): ${scheduledDate.toUtc()}');
    return scheduledDate;
  }
}
