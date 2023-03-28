import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_webview_pro/webview_flutter.dart';
import 'package:cbnu_alrami_app/src/controller/notification_controller.dart';
import 'package:image_downloader/image_downloader.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

class CbnuAlramiWebview extends StatefulWidget {
  CbnuAlramiWebview({Key key}) : super(key: key);

  @override
  State<CbnuAlramiWebview> createState() => CbnuAlramiWebviewState();
}

class CbnuAlramiWebviewState extends State<CbnuAlramiWebview>
    with WidgetsBindingObserver {
  WebViewController _webViewController;
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();

  @override
  void initState() {
    super.initState();
    // Enable virtual display.
    WidgetsBinding.instance.addObserver(this);
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
          initialUrl: 'http://192.168.219.166:3000',
          userAgent: Platform.isIOS ? 'cbnu_alrami_ios' : 'cbnu_alrami_android',
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
        onMessageReceived: (JavascriptMessage message) async {
          Map<String, dynamic> event = jsonDecode(message.message);

          if (event['action'] == 'copy') {
            Clipboard.setData(ClipboardData(text: event['url']));
          }

          if (event['action'] == 'image') {
            var imageId = await ImageDownloader.downloadImage(event['url']);

            if (event['preview'] == true) {
              var path = await ImageDownloader.findPath(imageId);
              await ImageDownloader.open(path);
            }
          }

          if (event['action'] == 'navigate') {
            var url = event['url'];

            final uri = Uri.parse(url);

            if (await canLaunchUrl(uri)) {
              await launchUrl(uri);
            }
          }
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
