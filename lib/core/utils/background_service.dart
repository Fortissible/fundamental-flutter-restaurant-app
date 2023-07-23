import 'dart:isolate';
import 'dart:math';
import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:flutter_restaurant_app/data/remote_data_source/remote_data_source.dart';

import '../../presentation/screen/main.dart';
import 'notification_helper.dart';

final ReceivePort port = ReceivePort();

class BackgroundService {
  static BackgroundService? _instance;
  static const String _isolateName = 'isolate';
  static SendPort? _uiSendPort;

  BackgroundService._internal() {
    _instance = this;
  }

  factory BackgroundService() => _instance ?? BackgroundService._internal();

  void initializeIsolate() {
    IsolateNameServer.registerPortWithName(
      port.sendPort,
      _isolateName,
    );
  }

  static Future<void> callback() async {
    print('Notification fired!');
    final NotificationHelper notificationHelper = NotificationHelper();
    var result = await RemoteDataSourceImpl(dio: Dio()).getRestaurantList();
    await notificationHelper.showNotification(
        flutterLocalNotificationsPlugin,
        result[Random().nextInt(10)].modelToEntity()
    );

    _uiSendPort ??= IsolateNameServer.lookupPortByName(_isolateName);
    _uiSendPort?.send(null);
  }
}