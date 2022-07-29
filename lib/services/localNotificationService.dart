
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:turtle_ninja/models/payload.dart';
import '../routes/routes.dart';

import '../pages/details/details.dart';
class LocalNotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
  FlutterLocalNotificationsPlugin();

  static void initialize(BuildContext context) async {
    final InitializationSettings initializationSettings =
    InitializationSettings(
        android: AndroidInitializationSettings("@mipmap/ic_launcher"));


    final details = await _notificationsPlugin.getNotificationAppLaunchDetails();
      if (details != null && details.didNotificationLaunchApp) {
        PayLoad payLoad2 = PayLoad.decode(details.payload!);

        ///for terminated
        if (payLoad2.value == '/details') {
          Navigator.push(context,routes.createRoute(Details(docID:payLoad2.data)));
        }
      }



    _notificationsPlugin.initialize(initializationSettings,onSelectNotification: (String? payload) async{
      if(payload != null){
        PayLoad payLoad2 = PayLoad.decode(payload);
        ///for foreground and background
        Navigator.push(context,routes.createRoute(Details(docID:payLoad2.data)));
      }
    });
  }



  static void display(RemoteMessage message) async {

    try {
      final id = DateTime.now().millisecondsSinceEpoch ~/1000;

      final NotificationDetails notificationDetails = NotificationDetails(
          android: AndroidNotificationDetails(
            "ninjaturtle",
            "ninjaturtle channel",
            importance: Importance.max,
            priority: Priority.high,
          )
      );


      await _notificationsPlugin.show(
        id,
        message.notification!.title,
        message.notification!.body,
        notificationDetails,
        payload: message.data["route"],
      );
    } on Exception catch (e) {
      print(e);
    }
  }


  static void showNotification(String? title, String? body, String? payload,DateTime scheduledData) async {

    try {

      final id = DateTime.now().millisecondsSinceEpoch ~/1000;

      final NotificationDetails notificationDetails = NotificationDetails(
          android: AndroidNotificationDetails(
            "ninjaturtle",
            "ninjaturtle channel",
            importance: Importance.max,
            priority: Priority.high,
          )
      );

      await _notificationsPlugin.zonedSchedule(
        id,
        title,
        body,
        tz.TZDateTime.from(scheduledData, tz.local),
        notificationDetails,
        payload:payload,
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      );
    } on Exception catch (e) {
      print(e);
    }
  }



}