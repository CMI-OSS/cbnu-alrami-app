import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:flutter_webview_pro/webview_flutter.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

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

  Future onBackgroundHandler(RemoteMessage message) async {
    print("onBackgroundMessage: ${message.data}");
    return Future.value();
  }

  void foregroundNotification(String title, String body) async {
     FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

     const AndroidInitializationSettings initializationSettingsAndroid =
     AndroidInitializationSettings('ic_launcher');

     final InitializationSettings initializationSettings =
     InitializationSettings(android: initializationSettingsAndroid);

     await _flutterLocalNotificationsPlugin.initialize(initializationSettings,
         onSelectNotification: (String payload) async {
           //onSelectNotification은 알림을 선택했을때 발생
           if (payload != null) {
             print('notification payload: $payload');
           }
        });
    const String groupKey = 'com.android.example.WORK_EMAIL';
    // 알림 채널
    const String groupChannelId = 'grouped channel id';
    // 채널 이름
    const String groupChannelName = 'grouped channel name';
    // 채널 설명
    const String groupChannelDescription = 'grouped channel description';


    const AndroidNotificationDetails notificationAndroidSpecifics =
     AndroidNotificationDetails(
         groupChannelId, groupChannelName,
         importance: Importance.max,
         priority: Priority.high,
         groupKey: groupKey);

     const NotificationDetails notificationPlatformSpecifics =
     NotificationDetails(android: notificationAndroidSpecifics);

     await _flutterLocalNotificationsPlugin.show(
         1234,
         title,
         body,
         notificationPlatformSpecifics);

  }
  void _initNotification() async {
    await _messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true
    );
    print("-- request 성공 -- ");

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      RemoteNotification notification = message.notification;
      print('foreground ${notification}');

      foregroundNotification(message.notification.title, message.notification.body);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print("onMessageOpenedApp: $message");
    });

     FirebaseMessaging.onBackgroundMessage(onBackgroundHandler);
  }

  void _actionOnNotification(Map<String, dynamic> messageMap) {
    message(messageMap);
  }
}
