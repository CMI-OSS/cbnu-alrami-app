import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';

class DynamicLink {
  Future<void> initDynamicLinks() async {

    final PendingDynamicLinkData data = await FirebaseDynamicLinks.instance.getInitialLink();
    final Uri deepLink = data?.link;

    print(deepLink);
  }
  Future<String> getShortLink() async {
    String dynamicLinkPrefix = 'https://cmiapp.page.link';
    final DynamicLinkParameters dynamicLinkParams = DynamicLinkParameters(
      uriPrefix: dynamicLinkPrefix,
      link: Uri.parse('https://cmiapp.page.link/home'),
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

    print(dynamicLink.shortUrl.toString());
    return dynamicLink.shortUrl.toString();
  }
}
