# 충림이 앱 개발

## 안드로이드 실행
1. `Java` 및 `Android Studio` 설치
2. `local.properties.help` 파일을 참고하여 `local.properties` 파일 작성
3. `Android SDK`에서 `Android 12.0(API Level 31)` 설치
4. `vi ~/.zshrc` 혹은 `vi ~/.bash_profile`에서 아래 코드 입력 후 `source ~/.zshrc` 혹은 `source ~/.bash_profile`
``` bash
export JAVA_HOME=/Library/Java/JavaVirtualMachines/jdk-18.0.1.jdk/Contents/Home
export ANDROID_HOME=/Users/사용자 이름/Library/Android/sdk
export PATH=$ANDROID_HOME/platform-tools:$PATH
export PATH=$ANDROID_HOME/emulator:$PATH
export PATH=$ANDROID_HOME/tools:$PATH
export PATH=$ANDROID_HOME/tools/bin:$PATH
```
5. 안드로이드 에뮬레이터 실행
6. `adb devices`명령어를 통해 에뮬레이터가 실행되고 있는지 확인
7. 아래 명령어를 입력하여 실행
``` bash
yarn install
yarn android
```
