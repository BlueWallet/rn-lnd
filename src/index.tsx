import { NativeModules } from 'react-native';

type NativeType = {
  start(lndArguments: string): Promise<boolean>;
  stopDaemon(): Promise<boolean>;
  unlockWallet(password: string): Promise<boolean>;
  initWallet(password: string, mnemonics: string): Promise<boolean>;
  getInfo(): Promise<boolean | string>;
  getLndDir(): Promise<boolean | string>;
  listChannels(): Promise<boolean | string>;
  listPeers(): Promise<boolean | string>;
  pendingChannels(): Promise<boolean | string>;
  walletBalance(): Promise<boolean | string>;
  channelBalance(): Promise<boolean | string>;
  connectPeer(host: string, pubkeyHex: string): Promise<boolean>;
  openChannelPsbt(pubkeyHex: string, amountSats: number, privateChannel: boolean): Promise<boolean | string>;
  fundingStateStepVerify(chanIdHex: string, psbtHex: string): Promise<boolean | string>;
  fundingStateStepFinalize(chanIdHex: string, psbtHex: string): Promise<boolean | string>;
  genSeed(): Promise<boolean | string>;
  sendPaymentSync(paymentRequest: string): Promise<boolean | string>;
  sendToRouteV2(paymentHashHex: string, paymentAddrHex: string, routesJsonString: string): Promise<boolean | string>;
  decodePayReq(paymentRequest: string): Promise<boolean | string>;
  addInvoice(sat: number, memo: string, expiry: number): Promise<boolean | string>;
  closeChannel(deliveryAddress: string, fundingTxidHex: string, outputIndex: number, force: boolean): Promise<boolean | string>;
  listPayments(): Promise<boolean | string>;
  listInvoices(): Promise<boolean | string>;
  getLogs(): Promise<boolean | string>;
};

const Native: NativeType = NativeModules.RnLnd;

class RnLndImplementation {
  static jsonOrBoolean(str: string | boolean) {
    if (str === true || str === false) return str;

    try {
      return JSON.parse(str);
    } catch (_) {
      return false;
    }
  }

  async channelBalance(): Promise<boolean | object> {
    return RnLndImplementation.jsonOrBoolean(await Native.channelBalance());
  }

  connectPeer(host: string, pubkeyHex: string): Promise<boolean> {
    return Native.connectPeer(host, pubkeyHex);
  }

  async fundingStateStepVerify(chanIdHex: string, psbtHex: string): Promise<boolean | object> {
    return RnLndImplementation.jsonOrBoolean(await Native.fundingStateStepVerify(chanIdHex, psbtHex));
  }

  async fundingStateStepFinalize(chanIdHex: string, psbtHex: string): Promise<boolean | object> {
    return RnLndImplementation.jsonOrBoolean(await Native.fundingStateStepFinalize(chanIdHex, psbtHex));
  }

  genSeed(): Promise<boolean | string> {
    return Native.genSeed();
  }

  async getInfo(): Promise<boolean | object> {
    return RnLndImplementation.jsonOrBoolean(await Native.getInfo());
  }

  initWallet(password: string, mnemonics: string): Promise<boolean> {
    return Native.initWallet(password, mnemonics);
  }

  async listChannels(): Promise<boolean | object> {
    return RnLndImplementation.jsonOrBoolean(await Native.listChannels());
  }

  async listPeers(): Promise<boolean | object> {
    return RnLndImplementation.jsonOrBoolean(await Native.listPeers());
  }

  async pendingChannels(): Promise<boolean | object> {
    return RnLndImplementation.jsonOrBoolean(await Native.pendingChannels());
  }

  async openChannelPsbt(pubkeyHex: string, amountSats: number, privateChannel: boolean): Promise<boolean | object> {
    return RnLndImplementation.jsonOrBoolean(await Native.openChannelPsbt(pubkeyHex, amountSats, privateChannel));
  }

  start(lndArguments: string): Promise<boolean> {
    const defaultArguments =
      '--sync-freelist --tlsdisableautofill  --maxpendingchannels=10 ' + // --debuglevel=debug
      '--minchansize=1000000 --ignore-historical-gossip-filters --rejecthtlc ' +
      '--bitcoin.active --bitcoin.mainnet --bitcoin.defaultchanconfs=1 --routing.assumechanvalid ' +
      '--protocol.wumbo-channels --rpclisten=127.0.0.1 --norest --nolisten ' +
      '--maxbackoff=5s --enable-upfront-shutdown --connectiontimeout=20s' +
      '--bitcoin.node=neutrino --neutrino.addpeer=btcd-mainnet.lightning.computer --neutrino.maxpeers=10 ' +
      '--neutrino.assertfilterheader=660000:08312375fabc082b17fa8ee88443feb350c19a34bb7483f94f7478fa4ad33032 ' +
      '--neutrino.feeurl=https://nodes.lightning.computer/fees/v1/btc-fee-estimates.json  --numgraphsyncpeers=1 ' +
      '--bitcoin.basefee=100000 --bitcoin.feerate=10000 ';

    return Native.start(lndArguments || defaultArguments);
  }

  stop(): Promise<boolean> {
    return Native.stopDaemon();
  }

  unlockWallet(password: string): Promise<boolean> {
    return Native.unlockWallet(password);
  }

  async walletBalance(): Promise<boolean | object> {
    return RnLndImplementation.jsonOrBoolean(await Native.walletBalance());
  }

  async sendPaymentSync(paymentRequest: string): Promise<boolean | object> {
    return RnLndImplementation.jsonOrBoolean(await Native.sendPaymentSync(paymentRequest));
  }

  async sendToRouteV2(paymentHashHex: string, paymentAddrHex: string, routesJsonString: string): Promise<boolean | object> {
    return RnLndImplementation.jsonOrBoolean(await Native.sendToRouteV2(paymentHashHex, paymentAddrHex, routesJsonString));
  }

  async decodePayReq(paymentRequest: string): Promise<boolean | object> {
    return RnLndImplementation.jsonOrBoolean(await Native.decodePayReq(paymentRequest));
  }

  async addInvoice(sat: number, memo: string, expiry: number): Promise<boolean | object> {
    return RnLndImplementation.jsonOrBoolean(await Native.addInvoice(sat, memo, expiry));
  }

  async closeChannel(deliveryAddress: string, fundingTxidHex: string, outputIndex: number, force: boolean): Promise<boolean | object> {
    return RnLndImplementation.jsonOrBoolean(await Native.closeChannel(deliveryAddress, fundingTxidHex, outputIndex, force));
  }

  async listPayments(): Promise<boolean | object> {
    return RnLndImplementation.jsonOrBoolean(await Native.listPayments());
  }

  async listInvoices(): Promise<boolean | object> {
    return RnLndImplementation.jsonOrBoolean(await Native.listInvoices());
  }

  async getLndDir(): Promise<boolean | string> {
    return await Native.getLndDir();
  }

  async getLogs(): Promise<boolean | string> {
    return await Native.getLogs();
  }

  async startUnlockAndWait(password: string = '') {
    console.warn('starting...');
    await this.start('');
    console.warn('started');
    await this.unlockWallet(password || 'gsomgsomgsom');
    console.warn('unlocked');
    let c = 0;
    while (1) {
      const connected = await this.connectPeer('165.227.95.104:9735', '02e89ca9e8da72b33d896bae51d20e7e6675aa971f7557500b6591b15429e717f1');
      if (connected) break;
      const peers: any = await this.listPeers();
      if (peers && peers.peers && peers.peers.length) {
        break;
      } else {
        await new Promise((resolve) => setTimeout(resolve, 1000));
      }

      if (c++ >= 30) throw new Error('waiting for LND timed out');
    }
    console.warn('ready');
  }

  async payInvoiceViaSendToRoute(bolt11: string) {
    const decoded: any = await this.decodePayReq(bolt11);

    const info: any = await this.getInfo();
    const amtSat = decoded.numSatoshis ? parseInt(decoded.numSatoshis) : Math.round(decoded.numMsat / 1000);
    const from = info.identityPubkey;
    const to = decoded.destination;
    const hash = decoded.paymentHash;

    const paymentAddrHex = decoded.paymentAddr ? base64ToHex(decoded.paymentAddr) : '';

    let url = '';
    let response = await fetch((url = `http://lndhub-staging.herokuapp.com/queryroutes/${from}/${to}/${amtSat}`));
    console.warn(url);
    let json = await response.json();

    const rez = await this.sendToRouteV2(hash, paymentAddrHex, JSON.stringify(json));
    console.warn(rez);
    return rez;
  }
}

/* Convert base64 data to hex string.  https://stackoverflow.com/a/57909068/893578
 *   txt : Base64 string.
 *   sep : Hex separator, e.g. '-' for '1a-2b-3c'.  Default empty.
 */
const base64ToHex = (() => {
  // Lookup tables
  const values: any[] = [],
    output: any[] = [];

  // Main converter
  return function base64ToHex(txt: any, sep = '') {
    if (output.length <= 0) populateLookups();
    const result = [];
    let v1, v2, v3, v4;
    for (let i = 0, len = txt.length; i < len; i += 4) {
      // Map four chars to values.
      v1 = values[txt.charCodeAt(i)];
      v2 = values[txt.charCodeAt(i + 1)];
      v3 = values[txt.charCodeAt(i + 2)];
      v4 = values[txt.charCodeAt(i + 3)];
      // Split and merge bits, then map and push to output.
      result.push(output[(v1 << 2) | (v2 >> 4)], output[((v2 & 15) << 4) | (v3 >> 2)], output[((v3 & 3) << 6) | v4]);
    }
    // Trim result if the last values are '='.
    if (v4 === 64) result.splice(v3 === 64 ? -2 : -1);
    return result.join(sep);
  };

  function populateLookups() {
    const keys = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=';
    for (let i = 0; i < 256; i++) {
      output.push(('0' + i.toString(16)).slice(-2));
      values.push(0);
    }
    for (let i = 0; i < 65; i++) values[keys.charCodeAt(i)] = i;
  }
})();

export default new RnLndImplementation();
