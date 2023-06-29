import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:flutter_webview_pro/webview_flutter.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationController extends GetxController {
  static NotificationController get to => Get.find();
  FirebaseMessaging _messaging = FirebaseMessaging.instance;
  RxMap<String, dynamic> message = Map<String, dynamic>().obs;
  WebViewController controller;

  @override
  void onInit() async {
    _initNotification();
    getToken();
    super.onInit();
  }

  Future<String> getToken() async {
    try {
      String token = await _messaging.getToken();
      print('token ${token}');
      return token;
    } catch (e) {}
  }

  void foregroundNotification(String title, String body, String payload) async {
    FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@drawable/ic_stat_cmi');

    final InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    Future<void> handleNotificationClick(String payload) async {
      setUrl(payload);
    }

    await _flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: handleNotificationClick);

    // 알림 채널
    const String groupChannelId = 'cbnu_alrami';
    // 채널 이름
    const String groupChannelName = '충림이';

    const AndroidNotificationDetails notificationAndroidSpecifics =
        AndroidNotificationDetails(
      groupChannelId,
      groupChannelName,
      importance: Importance.max,
      priority: Priority.high,
    );

    const NotificationDetails notificationPlatformSpecifics =
        NotificationDetails(android: notificationAndroidSpecifics);

    await _flutterLocalNotificationsPlugin.show(
        1234, title, body, notificationPlatformSpecifics,
        payload: payload);
  }

  void _initNotification() async {
    NotificationSettings settings = await _messaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true);
    print("-- request 성공 -- ");

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print('User granted provisional permission');
    } else {
      print('User declined or has not accepted permission');
    }

    await _messaging.setForegroundNotificationPresentationOptions(
      alert: true, // Required to display a heads up notification
      badge: true,
      sound: true,
    );

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      dynamic payload = message.data['url'];

      foregroundNotification(
          message.notification.title, message.notification.body, payload);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      dynamic url = message.data['url'];

      this.setUrl(url);
    });

    _messaging
      ..getInitialMessage().then((RemoteMessage message) {
        dynamic url = message.data['url'];

        this.setUrl(url);
      });
  }

  void setUrl(url) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('url', url);
  }
}
