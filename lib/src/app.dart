import 'package:flutter/material.dart';
import 'package:flutter_chat_sample/src/page/message_page.dart';
import 'package:get/get.dart';

import 'controller/notification_controller.dart';

class App extends StatelessWidget {
  const App({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Obx(() {
        if (NotificationController.to.message.isNotEmpty) return MessagePage();
        return Container();
      }),
    );
  }
}
