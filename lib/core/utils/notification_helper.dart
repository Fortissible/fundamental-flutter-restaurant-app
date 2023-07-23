import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_restaurant_app/domain/entities/restaurant_entity.dart';
import 'package:rxdart/rxdart.dart';

import '../../domain/entities/notification_entity.dart';
import 'navigation.dart';

final selectNotificationSubject = BehaviorSubject<String>();

class NotificationHelper{
  static const _channelId = "99";
  static const _channelName = "channel_99";
  static const _channelDesc = "restaurant channel";
  static NotificationHelper? _instance;

  NotificationHelper._internal(){
    _instance = this;
  }

  factory NotificationHelper() => _instance ?? NotificationHelper._internal();

  Future<void> initNotif(
      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin
      ) async {
    var initAndroidSettings = const AndroidInitializationSettings('app_icon');
    var initSettings = InitializationSettings(
      android: initAndroidSettings
    );
    await flutterLocalNotificationsPlugin.initialize(initSettings,
      onDidReceiveNotificationResponse: (NotificationResponse data) async {
        final payload = data.payload;
        if (payload != null) {
          if (kDebugMode) {
            print('notification payload: $payload');
          }
        }
        selectNotificationSubject.add(payload ?? "empty_payload");
      }
    );
  }

  Future<void> showNotification(
      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin,
      RestaurantEntity restaurantEntity) async {
    var androidPlatformChannelSpecifics = const AndroidNotificationDetails(
        _channelId, _channelName,
        channelDescription: _channelDesc,
        importance: Importance.max,
        priority: Priority.high,
        ticker: 'ticker');

    var platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );

    await flutterLocalNotificationsPlugin.show(
      0,
      "Daily Recommended Resto\n",
      restaurantEntity.name,
      platformChannelSpecifics,
      payload: restaurantEntity.id,
    );
  }

  void configureSelectNotificationSubject(String route) {
    selectNotificationSubject.stream.listen(
            (String? payload) async {
              Navigation.intentWithData(route, payload ?? "0");
    });
  }
}