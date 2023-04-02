import 'package:cbnu_alrami_app/src/page/cbnu_alrami.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:cbnu_alrami_app/src/controller/notification_controller.dart';
import 'package:cbnu_alrami_app/src/page/message_page.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: '충림이',
      theme: ThemeData(
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialBinding: HomeBinding(),
      home: Scaffold(
        body: SafeArea(
          child: Obx(() {
            if (NotificationController.to.message.isNotEmpty)
              return MessageBox(); // 원하는 페이지 or 이벤트 처리

            return CbnuAlramiWebview();
          }),
        ),
      ),
    );
  }
}

class HomeBinding implements Bindings {
  @override
  void dependencies() {
    Get.put(NotificationController());
  }
}
