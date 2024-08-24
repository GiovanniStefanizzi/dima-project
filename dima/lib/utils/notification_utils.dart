import 'dart:ffi';

import 'package:dima/api/open_meteo/open_meteo_utils.dart';
import 'package:dima/firestore/firestore.dart';
import 'package:dima/models/field_model.dart';
import 'package:dima/models/user_model.dart';
import 'package:dima/utils/field_utils.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  final FlutterLocalNotificationsPlugin notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> initNotification() async {
    AndroidInitializationSettings initializationSettingsAndroid =
        const AndroidInitializationSettings('@mipmap/ic_launcher');

    var initializationSettingsIOS = DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
        onDidReceiveLocalNotification:
            (int id, String? title, String? body, String? payload) async {});

    var initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
    await notificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse:
            (NotificationResponse notificationResponse) async {});
  }

  notificationDetails() {
    return const NotificationDetails(
        android: AndroidNotificationDetails('channelId', 'channelName',
        
            importance: Importance.max),
        iOS: DarwinNotificationDetails());
  }

  Future showNotification(
      {int id = 0, String? title, String? body, String? payLoad}) async {
    return notificationsPlugin.show(
        id, title, body, await notificationDetails());
  }

  Future<void> notifyUser() async {
    User_model? currentUser = await Firestore().getCurrentUser();

    if (currentUser == null) return;
    else{
        List<Field_model> fields = currentUser.getFields();

        final notification = StringBuffer();
        
        for(Field_model field in fields){
            if(field.hailAlert){
                //get meteo data
                int? maxCode = await getMaxWeatherCode3days(Field_utils.getCentroid(field.points));
                //
                if(maxCode == 96 || maxCode == 99){
                    notification.write("HAIL ALERT at ${field.name}!\n");
                }
            }
            if(field.frostAlert){
                double? minTemp = await getMinTemperature3days(Field_utils.getCentroid(field.points));
                if(minTemp <= 0){
                    notification.write("FROST ALERT at ${field.name}!\n");
                }
            }
        }
        if (notification.toString()!=''){
            await showNotification(title: "METEO UPDATE", body:notification.toString());
        }
    }
    
  }

  Future<bool> hailAlert(Field_model field) async {
    int? maxCode = await getMaxWeatherCode3days(Field_utils.getCentroid(field.points));
                //
    if(maxCode == 96 || maxCode == 99){
        return true;
    }
    else{
        return false;
    }
  }

Future<bool> frostAlert(Field_model field) async {
    double? minTemp = await getMinTemperature3days(Field_utils.getCentroid(field.points));
    if(minTemp <= 0){
        return true;
    }
    else{
        return false;
    }
  }

  
}


