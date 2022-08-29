import 'package:flutter/material.dart';
import 'package:flutter_webview_pro/webview_flutter.dart';
import 'package:cbnu_alrami_app/src/controller/notification_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';
import 'dart:async';
import 'dart:io';

class CbnuAlramiWebview extends StatefulWidget {
  CbnuAlramiWebview({Key key}) : super(key: key);

  @override
  State<CbnuAlramiWebview> createState() => CbnuAlramiWebviewState();
}

class CbnuAlramiWebviewState extends State<CbnuAlramiWebview>
    with WidgetsBindingObserver {
  WebViewController _webViewController;
  String initialUrl = '';

  @override
  void initState() {
    super.initState();
    // Enable virtual display.
    WidgetsBinding.instance.addObserver(this);
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    final Completer<WebViewController> _controller =
        Completer<WebViewController>();

    NotificationController nc = new NotificationController();

    return WebView(
      initialUrl: 'https://dev-mobile.cmi.kro.kr',
      javascriptMode: JavascriptMode.unrestricted,
      onWebViewCreated: (WebViewController webviewController) {
        _controller.complete(webviewController);
        _webViewController = webviewController;
      },
      javascriptChannels: <JavascriptChannel>{
        _baseJavascript(context),
      },
      onPageFinished: (String url) async {
        dynamic token = await nc.getToken();
        _webViewController
            .runJavascript('localStorage.setItem("token", "${token}");');
      },
      geolocationEnabled: true,
    );
  }

  JavascriptChannel _baseJavascript(BuildContext context) {
    return JavascriptChannel(
        name: 'baseApp',
        onMessageReceived: (JavascriptMessage message) {
          print(message.message);
        });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.resumed) {
      final prefs = await SharedPreferences.getInstance();

      await prefs.reload();
      String url = prefs.getString("url");
      prefs.remove('url');

      this._webViewController.loadUrl(url);
    }
    super.didChangeAppLifecycleState(state);
  }
}
