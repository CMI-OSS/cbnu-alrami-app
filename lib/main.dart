import 'package:cbnu_alrami_app/src/page/cbnu_alrami.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:cbnu_alrami_app/src/controller/notification_controller.dart';
import 'package:cbnu_alrami_app/src/page/message_page.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_webview_pro/webview_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<dynamic> onBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  final prefs = await SharedPreferences.getInstance();
  print("onBackgroundMessage: ${message.data}");
  await prefs.reload();
  prefs.setString('url',
      'https://dev-mobile.cmi.kro.kr/notice/' + message.data['articleId']);

  return Future.value();
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(onBackgroundHandler);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: '충림이',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialBinding: BindingsBuilder(
        () {
          Get.put(NotificationController());
        },
      ),
      home: Scaffold(
        body: Obx(() {
          if (NotificationController.to.message.isNotEmpty)
            return MessageBox(); // 원하는 페이지 or 이벤트 처리

          return CbnuAlramiWebview();
        }),
      ),
    );
  }
}
