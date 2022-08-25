import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:cbnu_alrami_app/src/controller/notification_controller.dart';
import 'package:get/get.dart';
import 'dart:async';
import 'dart:io';

class CbnuAlramiWebview extends StatefulWidget {
  CbnuAlramiWebview({Key key}) : super(key: key);

  @override
  State<CbnuAlramiWebview> createState() => CbnuAlramiWebviewState();
}
class CbnuAlramiWebviewState extends State<CbnuAlramiWebview> {
  WebViewController _webViewController;

  @override
  void initState() {
    super.initState();
    // Enable virtual display.
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }
  @override
  Widget build(BuildContext context) {
    final Completer<WebViewController> _controller =
    Completer<WebViewController>();

    NotificationController nc = new NotificationController();

    return WebView(
      initialUrl: 'https://dev-mobile.cmi.kro.kr', // 'https://dev-mobile.cmi.kro.kr'
      javascriptMode: JavascriptMode.unrestricted,
      onWebViewCreated: (WebViewController webviewController)  {
        _controller.complete(webviewController);
        _webViewController = webviewController;
      },
      javascriptChannels: <JavascriptChannel>{
        _baseJavascript(context),
      },
      onPageFinished: (String url) async {
        dynamic token = await nc.getToken();
        _webViewController.evaluateJavascript('localStorage.setItem("token", "${token}");');
      },
    );
  }
  JavascriptChannel _baseJavascript(BuildContext context) {
    return JavascriptChannel(
        name: 'baseApp',
        onMessageReceived: (JavascriptMessage message) {
            print(message.message);
        });
  }
}
