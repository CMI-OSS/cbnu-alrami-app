import React, {useRef, useState} from 'react';
import {Text, View} from 'react-native';
import WebView from 'react-native-webview';
import rnUuid from 'react-native-uuid';

const uri = 'https://dev-mobile.cmi.kro.kr/home';

const App = () => {
  let webviewRef = useRef<WebView>();
  const [isLoading, setLoading] = useState(true);
  const uuid = rnUuid.v4();
  const handleSetRef = (_ref: React.MutableRefObject<WebView>) => {
    webviewRef = _ref;
  };

  const handleOnMessage = ({nativeEvent: {data}}) => {
    console.log(data);
  };

  const handleEndLoading = () => {
    setLoading(false);
    console.log(uuid);
    console.log('로딩 끝');
    webviewRef.postMessage(uuid + '');
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
      {!isLoading && <Text>{uuid}</Text>}
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
