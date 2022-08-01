/**
 * Sample React Native App
 * https://github.com/facebook/react-native
 *
 * Generated with the TypeScript template
 * https://github.com/react-native-community/react-native-template-typescript
 *
 * @format
 */

import React from 'react';
import { WebView } from 'react-native-webview';

const App = () => {
  return (
       <WebView
        source={{uri: 'https://dev-mobile.cmi.kro.kr/map'}}
        style={{marginTop: 30}}
      />
  );
};

export default App;
