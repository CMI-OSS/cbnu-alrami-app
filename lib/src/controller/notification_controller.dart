import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:flutter_webview_pro/webview_flutter.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

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

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification notification = message.notification;
      print(notification);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print("onMessageOpenedApp: $message");
    });

    /* FirebaseMessaging.onBackgroundMessage((RemoteMessage message) {
      _actionOnNotification(message);
    }); */
  }

  void _actionOnNotification(Map<String, dynamic> messageMap) {
    message(messageMap);
  }
}
