import 'package:flutter/material.dart';
import 'package:flutter_webview_pro/webview_flutter.dart';
import 'package:cbnu_alrami_app/src/controller/notification_controller.dart';
import 'package:get/get.dart';
import 'dart:async';
import 'dart:io';
import 'package:flutter/services.dart';

class CbnuAlramiWebview extends StatefulWidget {
  CbnuAlramiWebview({Key key}) : super(key: key);

  @override
  State<CbnuAlramiWebview> createState() => CbnuAlramiWebviewState();
}

class CbnuAlramiWebviewState extends State<CbnuAlramiWebview> {
  WebViewController _webViewController;
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();

  @override
  void initState() {
    super.initState();
    // Enable virtual display.
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    NotificationController nc = new NotificationController();

    return WillPopScope(
      onWillPop: () => _goBack(context),
      child: Scaffold(
        body: WebView(
          onWebViewCreated: (WebViewController webviewController) {
            _controller.complete(webviewController);
            _webViewController = webviewController;
          },
          initialUrl: 'https://dev-mobile.cmi.kro.kr',
          javascriptMode: JavascriptMode.unrestricted,
          javascriptChannels: <JavascriptChannel>{
            _baseJavascript(context),
          },
          onPageFinished: (String url) async {
            dynamic token = await nc.getToken();
            _webViewController
                .runJavascript('localStorage.setItem("token", "${token}");');
          },
          geolocationEnabled: true,
        ),
      ),
    );
  }

  Future<bool> _goBack(BuildContext context) async {
    if (_webViewController == null) {
      return true;
    }
    if (await _webViewController.canGoBack()) {
      _webViewController.goBack();
      return Future.value(false);
    } else {
      return Future.value(true);
    }
  }

  JavascriptChannel _baseJavascript(BuildContext context) {
    return JavascriptChannel(
        name: 'baseApp',
        onMessageReceived: (JavascriptMessage message) {
            print(message.message);
            Clipboard.setData(ClipboardData(text: message.message));
        });
  }
}
