import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz;

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    tz.initializeTimeZones();

    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const settings = InitializationSettings(android: androidInit);

    await _notificationsPlugin.initialize(settings);
  }

  static Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDate,
  }) async {
    final tzDateTime = tz.TZDateTime.from(scheduledDate, tz.local);

    await _notificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      tzDateTime,
      NotificationDetails(
        android: AndroidNotificationDetails(
          'tugas_channel',
          'Tugas Reminder',
          channelDescription: 'Notifikasi pengingat tugas',
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
      payload: 'payload_tugas_$id',
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: null, // opsional: harian/mingguan/dll
    );
  }
}
