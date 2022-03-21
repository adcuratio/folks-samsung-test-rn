/**
 * Sample React Native App
 * https://github.com/facebook/react-native
 *
 * @format
 * @flow strict-local
 */

import React from 'react';
import type {Node} from 'react';
import {NetworkInfo} from 'react-native-network-info';

import {
  Button,
  NativeModules,
  SafeAreaView,
  ScrollView,
  StatusBar,
  StyleSheet,
  Text,
  useColorScheme,
  View,
  TextInput,
} from 'react-native';

import {
  Colors,
  DebugInstructions,
  Header,
  LearnMoreLinks,
  ReloadInstructions,
} from 'react-native/Libraries/NewAppScreen';

const axios = require('axios');

const Section = ({children, title}): Node => {
  const isDarkMode = useColorScheme() === 'dark';
  return (
    <View style={styles.sectionContainer}>
      <Text
        style={[
          styles.sectionTitle,
          {
            color: isDarkMode ? Colors.white : Colors.black,
          },
        ]}>
        {title}
      </Text>
      <Text
        style={[
          styles.sectionDescription,
          {
            color: isDarkMode ? Colors.light : Colors.dark,
          },
        ]}>
        {children}
      </Text>
    </View>
  );
};

const App: () => Node = () => {
  const isDarkMode = useColorScheme() === 'dark';

  const [text, onChangeText] = React.useState('ENTER SAMSUNG IP');

  const backgroundStyle = {
    backgroundColor: isDarkMode ? Colors.darker : Colors.lighter,
  };


  return (
    <SafeAreaView style={backgroundStyle}>
      <StatusBar barStyle={isDarkMode ? 'light-content' : 'dark-content'} />

      <TextInput
        onChangeText={onChangeText}
        style={styles.input}
        value={text}
      />

      <Button
        onPress={async () => {
        let wsApi  = "wss://"+text+":8002/api/v2/channels/samsung.remote.control?name=U2Ftc3VuZyBUZXN0IFJlbW90ZQ===&token=12345678"
          alert(wsApi);
          var NativeControllerModule =
            require('react-native').NativeModules.NativeControllerModule;
          NativeControllerModule.socketConnect(wsApi.toString(), (err, result) => {
            alert(err);
            console.log(result);
            alert(JSON.stringify(result));
          });
        }}
        title="SAMSUNG CONNECT"
        color="#841584"></Button>

      <Button
        onPress={async () => {
          var NativeControllerModule =
            require('react-native').NativeModules.NativeControllerModule;
          var deviceIP = await NetworkInfo.getIPAddress();
          console.log(deviceIP);

          NativeControllerModule.localDevices(
            'SEARCH LOCAL DEVICES',
            (err, result) => {
              console.log(result);
              alert(result);
            },
          );
        }}
        title="VIZIO SEARCH"
        color="#841584"></Button>
    </SafeAreaView>
  );
};

const styles = StyleSheet.create({
  sectionContainer: {
    marginTop: 32,
    paddingHorizontal: 24,
  },
  sectionTitle: {
    fontSize: 24,
    fontWeight: '600',
  },
  sectionDescription: {
    marginTop: 8,
    fontSize: 18,
    fontWeight: '400',
  },
  highlight: {
    fontWeight: '700',
  },
});

export default App;
