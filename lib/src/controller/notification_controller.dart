import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';

class NotificationController extends GetxController {
  static NotificationController get to => Get.find();
  FirebaseMessaging _messaging = FirebaseMessaging();
  FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  RxMap<String, dynamic> message = Map<String, dynamic>().obs;

  @override
  void onInit() {
    _initNotification();
    _getToken();
    super.onInit();
  }

  void _initNotification() {
    _registerNotification();
    _initlocalNotification();
  }

  void _initlocalNotification() {
    _flutterLocalNotificationsPlugin.initialize(
      InitializationSettings(
        android: AndroidInitializationSettings("@mipmap/ic_launcher"),
        iOS: IOSInitializationSettings(),
      ),
      onSelectNotification: _onSelectLocalNotification,
    );
  }

  Future _onSelectLocalNotification(String payload) {
    Map data = json.decode(payload);
    Map<String, dynamic> message = {"data": data};
    _actionOnNotification(message);
    return null;
  }

  void _registerNotification() {
    _messaging.requestNotificationPermissions(const IosNotificationSettings(
        sound: true, badge: true, alert: true, provisional: true));

    _messaging.configure(
      onMessage: _onMessage,
      onLaunch: _onLaunch,
      onResume: _onResume,
    );
    _messaging.onTokenRefresh
        .listen(_refreshToken, onError: _tokenRefreshFailure);
  }

  void _actionOnNotification(Map<String, dynamic> messageMap) {
    message(messageMap);
  }

  void _showNotification(Map<String, dynamic> message) async {
    NotificationDetails notificationDetails = NotificationDetails(
        android: AndroidNotificationDetails(
            "sample_channel_id", "Notification Test", ""),
        iOS: IOSNotificationDetails());
    await _flutterLocalNotificationsPlugin.show(
      0,
      message["title"],
      message["body"],
      notificationDetails,
      payload: json.encode(message["data"]),
    );
  }

  Map _modifyNoificationJson(Map<String, dynamic> message) {
    message["data"] = Map.from(message ?? {});
    message["notification"] = message["aps"]["alert"];
    return message;
  }

  Future<void> _onMessage(Map<String, dynamic> message) {
    print("_onMessage : $message");
    if (GetPlatform.isIOS) {
      message = _modifyNoificationJson(message);
    }
    _showNotification({
      "title": message['notification']['title'],
      "body": message["notification"]['body'],
      "data": message["data"],
    });
    _actionOnNotification(message);
    return null;
  }

  Future<void> _onLaunch(Map<String, dynamic> message) {
    print("_onLaunch : $message");
    if (GetPlatform.isIOS) {
      message = _modifyNoificationJson(message);
    }
    _showNotification({
      "title": message['notification']['title'],
      "body": message["notification"]['body'],
      "data": message["data"],
    });
    _actionOnNotification(message);
    return null;
  }

  Future<void> _onResume(Map<String, dynamic> message) {
    print("_onResume : $message");
    if (GetPlatform.isIOS) {
      message = _modifyNoificationJson(message);
    }
    _showNotification({
      "title": message['notification']['title'],
      "body": message["notification"]['body'],
      "data": message["data"],
    });
    _actionOnNotification(message);
    return null;
  }

  void _getToken() async {
    try {
      String token = await _messaging.getToken();
      print(token);
    } catch (e) {
      _tokenRefreshFailure(e);
    }
  }

  void _refreshToken(String token) {
    print(token);
  }

  void _tokenRefreshFailure(e) {
    print("token failed! $e");
  }
}
