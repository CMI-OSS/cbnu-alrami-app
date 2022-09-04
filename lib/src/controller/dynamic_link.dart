import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';

class DynamicLink {
  String url = '';

  void addListener() {
    FirebaseDynamicLinks.instance.onLink.listen((
      PendingDynamicLinkData dynamicLinkData,
    ) {
      print('dynamicLinkData ${dynamicLinkData}');
    });
  }

  Future<String> getShortLink() async {
    String dynamicLinkPrefix = 'https://cmiapp.page.link';
    final DynamicLinkParameters dynamicLinkParams = DynamicLinkParameters(
      uriPrefix: dynamicLinkPrefix,
      link: Uri.parse('https://dev-mobile.cmi.kro.kr/home'),
      androidParameters: const AndroidParameters(
        packageName: 'com.cbnu_alrami.app',
        minimumVersion: 0,
      ),
      iosParameters: const IOSParameters(
        bundleId: 'com.cbnu-alrami.app',
        minimumVersion: '0',
      ),
    );
    final dynamicLink =
    await FirebaseDynamicLinks.instance.buildShortLink(dynamicLinkParams);

    this.url = dynamicLink.shortUrl.toString();
    return dynamicLink.shortUrl.toString();
  }

  Future<void> retrieveDynamicLink() async {
    final PendingDynamicLinkData data = await FirebaseDynamicLinks;

  }

}
