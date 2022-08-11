import React, {useRef, useState, RefObject} from 'react';
import {Text, View} from 'react-native';
import WebView from 'react-native-webview';
import rnUuid from 'react-native-uuid';

// const uri = 'http://10.0.2.2:3000/home'; // android uri
const uri = 'http://localhost:3000/home';

const App = () => {
  let webviewRef = useRef<WebView>(null);
  const [isLoading, setLoading] = useState(true);
  const uuid = rnUuid.v4();

  const sendUuid = () => {
    if (webviewRef.current) {
      console.log(uuid);
      webviewRef?.current?.postMessage(
        JSON.stringify({
          data: uuid + '',
        }),
      );
    }
  };

  const handleOnEnd = () => {
    sendUuid();
    setLoading(false);
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
      {!isLoading && <Text style={{color: 'red'}}>{uuid}</Text>}
      <WebView
        onLoadEnd={handleOnEnd}
        javaScriptEnabled={true}
        ref={webviewRef}
        source={{uri}}
      />
    </>
  );
};

export default App;
