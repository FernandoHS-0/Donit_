import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> initNotifiaction() async {
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('donita');

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

  tz.initializeTimeZones();

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);
}

Future<NotificationDetails> crearNotificacionDetails() async {
  const AndroidNotificationDetails androidNotificationDetails =
      AndroidNotificationDetails(
    'channelId',
    'channelName',
    importance: Importance.max,
    priority: Priority.high,
  );

  const DarwinNotificationDetails darwinNotificationDetails =
      DarwinNotificationDetails();

  const NotificationDetails notificationDetails = NotificationDetails(
    android: androidNotificationDetails,
    iOS: darwinNotificationDetails,
  );

  return notificationDetails;
}

Future<void> programarNotificacion({id, titulo, descripcion, fecha}) async {
  try {
    await flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      titulo,
      descripcion,
      tz.TZDateTime.from(fecha, tz.local),
      const NotificationDetails(
        android: const AndroidNotificationDetails(
          'channelId',
          'channelName',
          importance: Importance.max,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(),
      ),
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      androidAllowWhileIdle: true,
    );
  } catch (e) {
    print(e);
  }
}
