import React, {useRef, useState} from 'react';
import {Text, View} from 'react-native';
import WebView from 'react-native-webview';

// const Stack = createNativeStackNavigator();
const uri = 'https://dev-mobile.cmi.kro.kr/home';

const App = () => {
  let webviewRef = useRef();
  const [isLoading, setLoading] = useState(true);

  const handleSetRef = (_ref: React.MutableRefObject<undefined>) => {
    webviewRef = _ref;
  };

  const handleOnMessage = ({nativeEvent: {data}}) => {
    console.log(data);
  };

  const handleEndLoading = () => {
    setLoading(false);
    console.log('로딩 끝');
    webviewRef.postMessage('js 로딩 완료시 webview로 정보를 보내는 곳');
  };

  return (
    <>
      {isLoading && (
        <View
          style={{
            backgroundColor: 'black',
            height: '100%',
          }}>
          <Text>Home Screen</Text>
        </View>
      )}
      <WebView
        onLoadEnd={handleEndLoading}
        onMessage={handleOnMessage}
        ref={handleSetRef}
        source={{uri}}
      />
    </>
  );
};

export default App;
