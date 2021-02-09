function _defineProperty(obj, key, value) { if (key in obj) { Object.defineProperty(obj, key, { value: value, enumerable: true, configurable: true, writable: true }); } else { obj[key] = value; } return obj; }

import { NativeModules } from 'react-native';

const util = require('./util');

const Native = NativeModules.RnLnd;

class RnLndImplementation {
  constructor() {
    _defineProperty(this, "_started", false);

    _defineProperty(this, "_inited", false);

    _defineProperty(this, "_ready", false);
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

  initWallet(password = 'bluewallet', mnemonics) {
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
    const defaultArguments = '--sync-freelist --tlsdisableautofill  --maxpendingchannels=1000 ' + // --debuglevel=debug
    '--minchansize=1000000 --ignore-historical-gossip-filters ' + // --rejecthtlc
    '--bitcoin.active --bitcoin.mainnet --bitcoin.defaultchanconfs=1 --routing.assumechanvalid ' + '--protocol.wumbo-channels --rpclisten=127.0.0.1 --norest --nolisten ' + '--maxbackoff=5s --connectiontimeout=20s' + // --enable-upfront-shutdown
    '--bitcoin.node=neutrino --neutrino.addpeer=btcd-mainnet.lightning.computer --neutrino.maxpeers=10 ' + '--neutrino.assertfilterheader=660000:08312375fabc082b17fa8ee88443feb350c19a34bb7483f94f7478fa4ad33032 ' + '--neutrino.feeurl=https://nodes.lightning.computer/fees/v1/btc-fee-estimates.json  --numgraphsyncpeers=1 ' + '--bitcoin.basefee=100000 --bitcoin.feerate=10000 ';
    return Native.start(lndArguments || defaultArguments);
  }

  stop() {
    return Native.stopDaemon();
  }

  wipeLndDir() {
    return Native.wipeLndDir();
  }

  async unlockWallet(password = 'bluewallet') {
    if (this._inited) {
      throw new Error('LND is already inited or unlocked');
    }

    this._inited = true; // locking first

    this._inited = await Native.unlockWallet(password);
    return this._inited;
  }

  async walletBalance() {
    return RnLndImplementation.jsonOrBoolean(await Native.walletBalance());
  }

  async sendPaymentSync(paymentRequest, amtSat) {
    return RnLndImplementation.jsonOrBoolean(await Native.sendPaymentSync(paymentRequest, amtSat));
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

  async queryRoutes(sourceHex, destHex, amtSat) {
    return RnLndImplementation.jsonOrBoolean(await Native.queryRoutes(sourceHex, destHex, amtSat));
  }

  async sendAllCoins(address) {
    return RnLndImplementation.jsonOrBoolean(await Native.sendAllCoins(address));
  }

  async getLndDir() {
    return await Native.getLndDir();
  }

  async getLogs() {
    return await Native.getLogs();
  }

  async waitTillReady(timeout = 30) {
    let c = 0;

    while (1) {
      const connected = await this.connectPeer('165.227.95.104:9735', '02e89ca9e8da72b33d896bae51d20e7e6675aa971f7557500b6591b15429e717f1');
      if (connected) break;
      const peers = await this.listPeers();

      if (peers && peers.peers && peers.peers.length) {
        this._ready = true;
        break;
      } else {
        await new Promise(resolve => setTimeout(resolve, 1000));
      }

      if (c++ >= timeout) throw new Error('waiting for LND timed out');
    }

    console.warn('ready');
  }
  /**
   * Tells if LND can accept calls after it was unlocked and fully started
   * (i.e. wont throw "server is still in the process of starting" on our calls)
   */


  isReady() {
    return this._ready;
  }

  async startUnlockAndWait(password = 'bluewallet') {
    console.warn('starting...');
    await this.start('');
    console.warn('started');
    const unlocked = await this.unlockWallet(password);

    if (!unlocked) {
      throw new Error('Could not unlock LND. Is wallet created?');
    }

    console.warn('unlocked');
    await this.waitTillReady();
  }

  isObject(o) {
    return o === Object(o) && !Array.isArray(o) && typeof o !== 'function';
  }

  camelToSnakeCase(str) {
    return str.replace(/[A-Z]/g, letter => "_".concat(letter.toLowerCase()));
  }

  camelCase2SnakeCase(o) {
    if (this.isObject(o)) {
      const n = {};
      Object.keys(o).forEach(k => {
        n[this.camelToSnakeCase(k)] = this.camelCase2SnakeCase(o[k]);
      });
      return n;
    } else if (Array.isArray(o)) {
      return o.map(i => {
        return this.camelCase2SnakeCase(i);
      });
    }

    return o;
  }

  async payInvoiceViaSendToRoute(bolt11, freeAmount = false) {
    let amtSat = 0;
    const decoded = await this.decodePayReq(bolt11);

    if (freeAmount) {
      amtSat = +freeAmount;
    } else {
      amtSat = decoded.numSatoshis ? parseInt(decoded.numSatoshis, 10) : Math.round(decoded.numMsat / 1000);
    }

    const info = await this.getInfo();
    const from = info.identityPubkey;
    const to = decoded.destination;
    const hash = decoded.paymentHash;
    const paymentAddrHex = decoded.paymentAddr ? util.base64ToHex(decoded.paymentAddr) : '';
    let json; // lets try quering route internaly first:

    try {
      const routes = await this.queryRoutes(from, to, amtSat);
      json = this.camelCase2SnakeCase(routes);
    } catch (_) {}

    if (!json) {
      // fallback to external router:
      let url = '';

      try {
        let response = await fetch(url = "http://lndhub-staging.herokuapp.com/queryroutes/".concat(from, "/").concat(to, "/").concat(amtSat));
        console.warn(url);
        json = await response.json();
      } catch (_) {
        throw new Error('Could not find route');
      }
    }

    const rez = await this.sendToRouteV2(hash, paymentAddrHex, JSON.stringify(json));
    console.warn(rez);
    return rez;
  }

}

export default new RnLndImplementation();
//# sourceMappingURL=index.js.map