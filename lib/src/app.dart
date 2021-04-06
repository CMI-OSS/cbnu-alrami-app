import 'package:flutter/material.dart';
import 'package:flutter_chat_sample/src/controller/notification_controller.dart';
import 'package:flutter_chat_sample/src/page/message_page.dart';
import 'package:get/get.dart';

class App extends StatelessWidget {
  const App({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Firebase cloud Message"),
      ),
      body: Obx(() {
        if (NotificationController.to.message.isNotEmpty) {
          return MessageBox();
        }
        return Container();
      }),
    );
  }
}
