function _defineProperty(obj, key, value) { if (key in obj) { Object.defineProperty(obj, key, { value: value, enumerable: true, configurable: true, writable: true }); } else { obj[key] = value; } return obj; }

import { NativeModules } from 'react-native';
const Native = NativeModules.RnLnd;

class RnLndImplementation {
  constructor() {
    _defineProperty(this, "_started", false);

    _defineProperty(this, "_inited", false);
  }

  static jsonOrBoolean(str) {
    if (str === true || str === false) return str;

    try {
      return JSON.parse(str);
    } catch (_) {
      return false;
    }
  }

  async channelBalance() {
    return RnLndImplementation.jsonOrBoolean(await Native.channelBalance());
  }

  connectPeer(host, pubkeyHex) {
    return Native.connectPeer(host, pubkeyHex);
  }

  async fundingStateStepVerify(chanIdHex, psbtHex) {
    return RnLndImplementation.jsonOrBoolean(await Native.fundingStateStepVerify(chanIdHex, psbtHex));
  }

  async fundingStateStepFinalize(chanIdHex, psbtHex) {
    return RnLndImplementation.jsonOrBoolean(await Native.fundingStateStepFinalize(chanIdHex, psbtHex));
  }

  genSeed() {
    return Native.genSeed();
  }

  async getInfo() {
    return RnLndImplementation.jsonOrBoolean(await Native.getInfo());
  }

  initWallet(password, mnemonics) {
    if (this._inited) {
      throw new Error('LND is already inited or unlocked');
    }

    this._inited = true;
    return Native.initWallet(password, mnemonics);
  }

  async listChannels() {
    return RnLndImplementation.jsonOrBoolean(await Native.listChannels());
  }

  async listPeers() {
    return RnLndImplementation.jsonOrBoolean(await Native.listPeers());
  }

  async pendingChannels() {
    return RnLndImplementation.jsonOrBoolean(await Native.pendingChannels());
  }

  async openChannelPsbt(pubkeyHex, amountSats, privateChannel) {
    return RnLndImplementation.jsonOrBoolean(await Native.openChannelPsbt(pubkeyHex, amountSats, privateChannel));
  }

  start(lndArguments) {
    if (this._started) {
      throw new Error('LND is already started');
    }

    this._started = true;
    const defaultArguments = '--sync-freelist --tlsdisableautofill  --maxpendingchannels=10 ' + // --debuglevel=debug
    '--minchansize=1000000 --ignore-historical-gossip-filters ' + // --rejecthtlc
    '--bitcoin.active --bitcoin.mainnet --bitcoin.defaultchanconfs=1 --routing.assumechanvalid ' + '--protocol.wumbo-channels --rpclisten=127.0.0.1 --norest --nolisten ' + '--maxbackoff=5s --enable-upfront-shutdown --connectiontimeout=20s' + '--bitcoin.node=neutrino --neutrino.addpeer=btcd-mainnet.lightning.computer --neutrino.maxpeers=10 ' + '--neutrino.assertfilterheader=660000:08312375fabc082b17fa8ee88443feb350c19a34bb7483f94f7478fa4ad33032 ' + '--neutrino.feeurl=https://nodes.lightning.computer/fees/v1/btc-fee-estimates.json  --numgraphsyncpeers=1 ' + '--bitcoin.basefee=100000 --bitcoin.feerate=10000 ';
    return Native.start(lndArguments || defaultArguments);
  }

  stop() {
    return Native.stopDaemon();
  }

  wipeLndDir() {
    return Native.wipeLndDir();
  }

  unlockWallet(password) {
    if (this._inited) {
      throw new Error('LND is already inited or unlocked');
    }

    this._inited = true;
    return Native.unlockWallet(password);
  }

  async walletBalance() {
    return RnLndImplementation.jsonOrBoolean(await Native.walletBalance());
  }

  async sendPaymentSync(paymentRequest) {
    return RnLndImplementation.jsonOrBoolean(await Native.sendPaymentSync(paymentRequest));
  }

  async sendToRouteV2(paymentHashHex, paymentAddrHex, routesJsonString) {
    return RnLndImplementation.jsonOrBoolean(await Native.sendToRouteV2(paymentHashHex, paymentAddrHex, routesJsonString));
  }

  async decodePayReq(paymentRequest) {
    return RnLndImplementation.jsonOrBoolean(await Native.decodePayReq(paymentRequest));
  }

  async addInvoice(sat, memo, expiry) {
    return RnLndImplementation.jsonOrBoolean(await Native.addInvoice(sat, memo, expiry));
  }

  async closeChannel(deliveryAddress, fundingTxidHex, outputIndex, force) {
    return RnLndImplementation.jsonOrBoolean(await Native.closeChannel(deliveryAddress, fundingTxidHex, outputIndex, force));
  }

  async listPayments() {
    return RnLndImplementation.jsonOrBoolean(await Native.listPayments());
  }

  async listInvoices() {
    return RnLndImplementation.jsonOrBoolean(await Native.listInvoices());
  }

  async getTransactions() {
    return RnLndImplementation.jsonOrBoolean(await Native.getTransactions());
  }

  async getLndDir() {
    return await Native.getLndDir();
  }

  async getLogs() {
    return await Native.getLogs();
  }

  async waitTillReady() {
    let c = 0;

    while (1) {
      const connected = await this.connectPeer('165.227.95.104:9735', '02e89ca9e8da72b33d896bae51d20e7e6675aa971f7557500b6591b15429e717f1');
      if (connected) break;
      const peers = await this.listPeers();

      if (peers && peers.peers && peers.peers.length) {
        break;
      } else {
        await new Promise(resolve => setTimeout(resolve, 1000));
      }

      if (c++ >= 30) throw new Error('waiting for LND timed out');
    }

    console.warn('ready');
  }

  async startUnlockAndWait(password = '') {
    console.warn('starting...');
    await this.start('');
    console.warn('started');
    await this.unlockWallet(password || 'gsomgsomgsom');
    console.warn('unlocked');
    await this.waitTillReady();
  }

  async payInvoiceViaSendToRoute(bolt11) {
    const decoded = await this.decodePayReq(bolt11);
    const info = await this.getInfo();
    const amtSat = decoded.numSatoshis ? parseInt(decoded.numSatoshis) : Math.round(decoded.numMsat / 1000);
    const from = info.identityPubkey;
    const to = decoded.destination;
    const hash = decoded.paymentHash;
    const paymentAddrHex = decoded.paymentAddr ? base64ToHex(decoded.paymentAddr) : '';
    let url = '';
    let response = await fetch(url = "http://lndhub-staging.herokuapp.com/queryroutes/".concat(from, "/").concat(to, "/").concat(amtSat));
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
  const values = [],
        output = []; // Main converter

  return function base64ToHex(txt, sep = '') {
    if (output.length <= 0) populateLookups();
    const result = [];
    let v1, v2, v3, v4;

    for (let i = 0, len = txt.length; i < len; i += 4) {
      // Map four chars to values.
      v1 = values[txt.charCodeAt(i)];
      v2 = values[txt.charCodeAt(i + 1)];
      v3 = values[txt.charCodeAt(i + 2)];
      v4 = values[txt.charCodeAt(i + 3)]; // Split and merge bits, then map and push to output.

      result.push(output[v1 << 2 | v2 >> 4], output[(v2 & 15) << 4 | v3 >> 2], output[(v3 & 3) << 6 | v4]);
    } // Trim result if the last values are '='.


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
//# sourceMappingURL=index.js.map