import React, {useRef, useState, RefObject} from 'react';
import {Alert, Text, View} from 'react-native';
import WebView from 'react-native-webview';
import rnUuid from 'react-native-uuid';

const uri = 'http://localhost:3000/home';
export interface Message {
  type: string;
  payload: string | null;
}

export interface SendMessage extends Message {
  webViewRef: RefObject<WebView<{}>>;
}

const App = () => {
  let webviewRef = useRef<WebView>(null);
  const [isLoading, setLoading] = useState(true);
  const uuid = rnUuid.v4();

  const handleOnLoad = () => {
    if(webviewRef.current) {
      webviewRef?.current?.postMessage(JSON.stringify({
        data: uuid + ''
      }));
    }
  };

  const handleOnEnd = () => {
    setLoading(false);
  }
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
      {!isLoading && <Text style={{ color: 'red'}}>{uuid}</Text>}
      <WebView
        onLoadProgress={handleOnLoad}
        onLoadEnd={handleOnEnd}
        javaScriptEnabled={true}
        ref={webviewRef}
        source={{uri}}
      />
    </>
  );
};

export default App;
function postMessage(arg0: string): string {
  throw new Error('Function not implemented.');
}

