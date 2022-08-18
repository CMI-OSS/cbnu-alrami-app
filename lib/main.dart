import 'package:cbnu_alrami_app/src/page/cbnu_alrami.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:cbnu_alrami_app/src/app.dart';
import 'package:cbnu_alrami_app/src/controller/notification_controller.dart';
import 'package:cbnu_alrami_app/src/page/message_page.dart';
import 'package:get/get.dart';

void main() {
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
        appBar: AppBar(),
        body: Obx(() {
          if (NotificationController.to.message.isNotEmpty)
            return MessageBox(); // 원하는 페이지 or 이벤트 처리
          return CbnuAlramiWebview();
        }),
      ),
    );
  }
}
