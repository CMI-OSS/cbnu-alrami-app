import 'package:cbnu_alrami_app/src/page/cbnu_alrami.dart';
import 'package:flutter/material.dart';
import 'package:cbnu_alrami_app/src/controller/notification_controller.dart';
import 'package:cbnu_alrami_app/src/page/message_page.dart';
import 'package:get/get.dart';

class App extends StatelessWidget {
  const App({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("충림이"),
      ),
      body: Obx(() {
        return CbnuAlramiWebview();

        // if (NotificationController.to.message.isNotEmpty) {
        //   return MessageBox();
        // }
        // return Container();
      }),
    );
  }
}
