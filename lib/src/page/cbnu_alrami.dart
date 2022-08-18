import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class CbnuAlramiWebview extends StatelessWidget {
  const CbnuAlramiWebview({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const WebView(
      initialUrl: 'https://dev-mobile.cmi.kro.kr',
      javascriptMode: JavascriptMode.unrestricted,
    );
  }
}
