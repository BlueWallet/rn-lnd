import * as React from 'react';
import { StyleSheet, ScrollView, TextInput, Text, Button, SafeAreaView } from 'react-native';
import RnLnd from 'rn-lnd';

export default function App() {
  const [chanIdHex, setChanIdHex] = React.useState<string>('');
  const [psbtHex, setPsbtHex] = React.useState<string>('');
  const [bolt11, setBolt11] = React.useState<string>('');

  React.useEffect(() => {}, []);

  return (
    <SafeAreaView style={styles.container}>
      <ScrollView>
        <Text>Hello LND</Text>
        <Button
          title="Start LND"
          onPress={() => {
            RnLnd.start('').then(console.warn);
          }}
        />
        <Button
          title="Start,unlock,wait"
          onPress={async () => {
            await RnLnd.startUnlockAndWait();
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
          title="getLndDir"
          onPress={() => {
            RnLnd.getLndDir().then(console.warn);
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
            // RnLnd.connectPeer('34.239.230.56:9735', '03864ef025fde8fb587d989186ce6a4a186895ee44a926bfc370e2c366597a3f8f').then(console.warn);
            RnLnd.connectPeer('165.227.95.104:9735', '02e89ca9e8da72b33d896bae51d20e7e6675aa971f7557500b6591b15429e717f1').then(console.warn);
          }}
        />

        <Button
          title="listPeers"
          onPress={() => {
            // RnLnd.connectPeer('34.239.230.56:9735', '03864ef025fde8fb587d989186ce6a4a186895ee44a926bfc370e2c366597a3f8f').then(console.warn);
            RnLnd.listPeers().then(console.warn);
          }}
        />

        <Button
          title="queryRoutes"
          onPress={() => {
            // RnLnd.connectPeer('34.239.230.56:9735', '03864ef025fde8fb587d989186ce6a4a186895ee44a926bfc370e2c366597a3f8f').then(console.warn);
            RnLnd.queryRoutes('02e89ca9e8da72b33d896bae51d20e7e6675aa971f7557500b6591b15429e717f1', '03864ef025fde8fb587d989186ce6a4a186895ee44a926bfc370e2c366597a3f8f', 10).then((rez) => {
              rez = RnLnd.camelCase2SnakeCase(rez);
              console.warn(JSON.stringify(rez));
            });
          }}
        />

        <TextInput placeholder={'chanIdHex'} onChangeText={(str: string) => setChanIdHex(str)} value={chanIdHex} />
        <TextInput placeholder={'psbtHex'} onChangeText={(str: string) => setPsbtHex(str)} value={psbtHex} />

        <Button
          title="openChannel"
          onPress={() => {
            // RnLnd.openChannelPsbt('03864ef025fde8fb587d989186ce6a4a186895ee44a926bfc370e2c366597a3f8f', 100000, true).then(console.warn);
            RnLnd.openChannelPsbt('02e89ca9e8da72b33d896bae51d20e7e6675aa971f7557500b6591b15429e717f1', 100000, true).then(console.warn);
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
            RnLnd.sendPaymentSync(bolt11, 12).then(console.warn);
          }}
        />
        <Button
          title="sendToRouteV2"
          onPress={async () => {
            await RnLnd.payInvoiceViaSendToRoute(bolt11);
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
        <Button
          title="listPayments"
          onPress={() => {
            RnLnd.listPayments().then(console.warn);
          }}
        />
        <Button
          title="listInvoices"
          onPress={() => {
            RnLnd.listInvoices().then(console.warn);
          }}
        />
        <Button
          title="getLogs"
          onPress={() => {
            RnLnd.getLogs().then(console.warn);
          }}
        />
        <Button
          title="getTransactions"
          onPress={() => {
            RnLnd.getTransactions().then(console.warn);
          }}
        />
        <Button
          title="wipeLndDir"
          onPress={() => {
            RnLnd.wipeLndDir().then(console.warn);
          }}
        />
      </ScrollView>
    </SafeAreaView>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    alignItems: 'center',
    justifyContent: 'center',
    width: 200,
  },
  box: {
    width: 60,
    height: 60,
    marginVertical: 20,
  },
});
