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
  Function moveUrl = () => {};

  NotificationController(Function moveUrl) {
    // See initializing formal parameters for a better way
    // to initialize instance variables.
    this.moveUrl = moveUrl;
  }

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
        AndroidInitializationSettings('ic_launcher');

    final InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    await _flutterLocalNotificationsPlugin.initialize(initializationSettings);
    // 알림 채널
    const String groupChannelId = 'grouped channel id';
    // 채널 이름
    const String groupChannelName = 'grouped channel name';

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
    await _messaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true);
    print("-- request 성공 -- ");

    await _messaging.setForegroundNotificationPresentationOptions(
      alert: true, // Required to display a heads up notification
      badge: true,
      sound: true,
    );

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      dynamic payload = message.data['articleId'];

      foregroundNotification(
          message.notification.title, message.notification.body, payload);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      dynamic payload = message.data['articleId'];
      final prefs = await SharedPreferences.getInstance();
      final url = 'https://dev-mobile.cmiteam.kr/article/detail/' + payload;
      prefs.setString('url', url);

      moveUrl(url);
    });
  }
}
