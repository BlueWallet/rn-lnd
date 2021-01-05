import * as React from 'react';

import { StyleSheet, View, ScrollView, TextInput, Text, Button } from 'react-native';
import RnLnd from 'rn-lnd';

export default function App() {
  const [result, setResult] = React.useState<number | undefined>();
  const [chanIdHex, setChanIdHex] = React.useState<string>('');
  const [psbtHex, setPsbtHex] = React.useState<string>('');
  const [bolt11, setBolt11] = React.useState<string>('');

  React.useEffect(() => {
  }, []);

  return (
    <ScrollView>
      <View style={styles.container}>
        <Text>Result: {result}</Text>

        <Button
          title="Start LND"
          onPress={() => {
            RnLnd.start('').then(console.warn);
          }}
        />

        <Button
          title="Stop LND"
          onPress={() => {
            RnLnd.stop().then(console.warn);
          }}
        />

        <Button
          title="unlockWallet"
          onPress={() => {
            RnLnd.unlockWallet('gsomgsomgsom').then(console.warn);
          }}
        />

        <Button
          title="initWallet"
          onPress={() => {
            RnLnd.initWallet('gsomgsomgsom', 'abstract rhythm weird food attract treat mosquito sight royal actor surround ride strike remove guilt catch filter summer mushroom protect poverty cruel chaos pattern').then(
              console.warn
            );
          }}
        />

        <Button
          title="getInfo"
          onPress={() => {
            RnLnd.getInfo().then(console.warn);
          }}
        />

        <Button
          title="listChannels"
          onPress={() => {
            RnLnd.listChannels().then(console.warn);
          }}
        />

        <Button
          title="pendingChannels"
          onPress={() => {
            RnLnd.pendingChannels().then(console.warn);
          }}
        />

        <Button
          title="connectPeer"
          onPress={() => {
            RnLnd.connectPeer('34.239.230.56:9735', '03864ef025fde8fb587d989186ce6a4a186895ee44a926bfc370e2c366597a3f8f').then(console.warn);
          }}
        />

        <TextInput placeholder={'chanIdHex'} onChangeText={(str: string) => setChanIdHex(str)} value={chanIdHex} />
        <TextInput placeholder={'psbtHex'} onChangeText={(str: string) => setPsbtHex(str)} value={psbtHex} />

        <Button
          title="openChannel"
          onPress={() => {
            RnLnd.openChannelPsbt('03864ef025fde8fb587d989186ce6a4a186895ee44a926bfc370e2c366597a3f8f', 100000, true).then(console.warn);
          }}
        />

        <Button
          title="fundingStateStep"
          onPress={async () => {
            await RnLnd.fundingStateStepVerify(chanIdHex, psbtHex);
            const res = await RnLnd.fundingStateStepFinalize(chanIdHex, psbtHex);
            console.warn({ res });
          }}
        />

        <Button
          title="walletBalance"
          onPress={() => {
            RnLnd.walletBalance().then(console.warn);
          }}
        />

        <Button
          title="channelBalance"
          onPress={() => {
            RnLnd.channelBalance().then(console.warn);
          }}
        />

        <Button
          title="genSeed"
          onPress={() => {
            RnLnd.genSeed().then(console.warn);
          }}
        />

        <TextInput placeholder={'bolt11 invoice'} onChangeText={(str: string) => setBolt11(str)} value={bolt11} />
        <Button
          title="sendPaymentSync"
          onPress={() => {
            RnLnd.sendPaymentSync(bolt11).then(console.warn);
          }}
        />
        <Button
          title="addInvoice"
          onPress={() => {
            RnLnd.addInvoice(1, 'test invoice', 86400).then(console.warn);
          }}
        />
        <Button
          title="closeChannel"
          onPress={() => {
            RnLnd.closeChannel('13HaCAB4jf7FYSZexJxoczyDDnutzZigjS', '9505944c68c879663650a1d7dcd4ae3888fcc3434a9ebf26bbcc4553426157d6', 0, false).then(console.warn);
          }}
        />
      </View>
    </ScrollView>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    alignItems: 'center',
    justifyContent: 'center',
  },
  box: {
    width: 60,
    height: 60,
    marginVertical: 20,
  },
});
