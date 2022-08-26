import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

class NotificationController extends GetxController {
  static NotificationController get to => Get.find();
  FirebaseMessaging _messaging = FirebaseMessaging();
  RxMap<String, dynamic> message = Map<String, dynamic>().obs;
  WebViewController controller;

  @override
  void onInit() {
    _initNotification();
    getToken();
    super.onInit();
  }

  Future<String> getToken() async {
    try {
      String token = await _messaging.getToken();
      return token;

    } catch (e) {}
  }

  void _initNotification() {
    _messaging.requestNotificationPermissions(const IosNotificationSettings(
        sound: true, badge: true, alert: true, provisional: true));

    _messaging.configure(
      onMessage: _onMessage,
      onLaunch: _onLaunch,
      onResume: _onResume,
    );
  }

  Future<void> _onResume(Map<String, dynamic> message) {
    print("_onResume : $message");
    return null;
  }

  Future<void> _onLaunch(Map<String, dynamic> message) {
    print("_onLaunch : $message");
    _actionOnNotification(message);
    return null;
  }

  void _actionOnNotification(Map<String, dynamic> messageMap) {
    message(messageMap);
  }

  Future<void> _onMessage(Map<String, dynamic> message) {
    print("_onMessage : $message");
    return null;
  }
}
