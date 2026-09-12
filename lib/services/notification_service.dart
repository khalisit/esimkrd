import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;
import 'package:shared_preferences/shared_preferences.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();

  factory NotificationService() {
    return _instance;
  }

  NotificationService._internal();

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    tz_data.initializeTimeZones();

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@drawable/notifyicon');

    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await flutterLocalNotificationsPlugin.initialize(
      settings: initializationSettings,
    );
  }

  Future<void> showLowDataNotification(String packageName, String iccid) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'notified_low_data_$iccid';
    
    if (prefs.getBool(key) == true) {
      return; // Already notified
    }

    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'low_data_channel',
      'Low Data Alerts',
      channelDescription: 'Notifications for when your eSIM data is running low',
      importance: Importance.max,
      priority: Priority.high,
    );
    
    const DarwinNotificationDetails iOSPlatformChannelSpecifics =
        DarwinNotificationDetails();
    
    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );

    await flutterLocalNotificationsPlugin.show(
      id: iccid.hashCode,
      title: 'Low Data Alert',
      body: 'Your eSIM $packageName has less than 500MB remaining.',
      notificationDetails: platformChannelSpecifics,
    );

    await prefs.setBool(key, true);
  }

  Future<void> scheduleExpiryNotification(String packageName, DateTime expiresAt, String iccid) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'notified_expiry_$iccid';

    if (prefs.getBool(key) == true) {
      return; // Already notified or scheduled
    }

    final notifyDate = expiresAt.subtract(const Duration(days: 2));

    if (notifyDate.isBefore(DateTime.now())) {
      // If it's already within 2 days, show it immediately (once)
      const AndroidNotificationDetails androidPlatformChannelSpecifics =
          AndroidNotificationDetails(
        'expiry_channel',
        'Expiry Alerts',
        channelDescription: 'Notifications for when your eSIM is about to expire',
        importance: Importance.max,
        priority: Priority.high,
      );
      
      const DarwinNotificationDetails iOSPlatformChannelSpecifics =
          DarwinNotificationDetails();
      
      const NotificationDetails platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics,
      );

      await flutterLocalNotificationsPlugin.show(
        id: ('${iccid}expiry').hashCode,
        title: 'eSIM Expiring Soon',
        body: 'Your eSIM $packageName is expiring within 2 days.',
        notificationDetails: platformChannelSpecifics,
      );
    } else {
      // Schedule it
      const AndroidNotificationDetails androidPlatformChannelSpecifics =
          AndroidNotificationDetails(
        'expiry_channel',
        'Expiry Alerts',
        channelDescription: 'Notifications for when your eSIM is about to expire',
        importance: Importance.max,
        priority: Priority.high,
      );
      
      const DarwinNotificationDetails iOSPlatformChannelSpecifics =
          DarwinNotificationDetails();
      
      const NotificationDetails platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics,
      );

      await flutterLocalNotificationsPlugin.zonedSchedule(
        id: ('${iccid}expiry').hashCode,
        title: 'eSIM Expiring Soon',
        body: 'Your eSIM $packageName is expiring in 2 days.',
        scheduledDate: tz.TZDateTime.from(notifyDate, tz.local),
        notificationDetails: platformChannelSpecifics,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      );
    }

    await prefs.setBool(key, true);
  }
}
