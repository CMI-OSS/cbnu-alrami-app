# 충림이 flutter 앱
충북대학교 공지사항 알림이 flutter 앱입니다.

## tech stack
- `flutter`
- `flutter_webview_pro`(3.0.1+2)
- `flutter_local_notifications`(9.2.0)
- `firebase_core`(1.21.0)
- `firebase_core_platform_interface`(4.5.0)
- `firebase_messaging`(12.0.3)

## Android start
[안드로이드 세팅 문서](https://github.com/CMI-OSS/cbnu-alrami-app/issues/43)를 확인하세요.

```bash
flutter clean
flutter pub get
```

## iOS start
```bash
flutter clean
flutter pub get
cd ios
pod install
```

## FCM 테스트
1. **FCM Server Key**: Mattermost 채널 확인
2. **FCM Registration Token(Device Token)**: 플러터 앱 실행 후 xcode 혹은 android studio 콘솔에 나타나는 토큰 복사
3. **Data 필드**
```json
{
  "url": "webview에서 실행할 URL"
}
```
