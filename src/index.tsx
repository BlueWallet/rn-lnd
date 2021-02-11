import { NativeModules } from 'react-native';
const util = require('./util');

const Native = NativeModules.RnLnd;

class RnLndImplementation {
  /**
   * Flag that prevents calling LND start twice, as it leads to app crash
   * @private
   */
  private _started: boolean = false;

  /**
   * Flag that shows whether we already Inited or Unlocked LND. It wont crash
   * if called again, but rather idicates theres a bug in logic on upper level
   * @private
   */
  private _inited: boolean = false;

  /**
   * Tells if LND can accept calls after it was unlocked and fully started
   * (i.e. wont throw "server is still in the process of starting" on our calls)
   * @private
   */
  private _ready: boolean = false;

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

  async fundingStateStepCancel(chanIdHex: string): Promise<boolean | object> {
    return RnLndImplementation.jsonOrBoolean(await Native.fundingStateStepCancel(chanIdHex));
  }

  genSeed(): Promise<boolean | string> {
    return Native.genSeed();
  }

  async getInfo(): Promise<boolean | object> {
    return RnLndImplementation.jsonOrBoolean(await Native.getInfo());
  }

  initWallet(password: string = 'bluewallet', mnemonics: string): Promise<boolean> {
    if (this._inited) {
      throw new Error('LND is already inited or unlocked');
    }
    this._inited = true;
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
    if (this._started) {
      throw new Error('LND is already started');
    }
    this._started = true;
    const defaultArguments =
      '--sync-freelist --tlsdisableautofill  --maxpendingchannels=1000 ' + // --debuglevel=debug
      '--minchansize=1000000 --ignore-historical-gossip-filters ' + // --rejecthtlc
      '--bitcoin.active --bitcoin.mainnet --bitcoin.defaultchanconfs=1 --routing.assumechanvalid ' +
      '--protocol.wumbo-channels --rpclisten=127.0.0.1 --norest --nolisten ' +
      '--maxbackoff=5s --connectiontimeout=20s' + // --enable-upfront-shutdown
      '--bitcoin.node=neutrino --neutrino.addpeer=btcd-mainnet.lightning.computer --neutrino.maxpeers=10 ' +
      '--neutrino.assertfilterheader=660000:08312375fabc082b17fa8ee88443feb350c19a34bb7483f94f7478fa4ad33032 ' +
      '--neutrino.feeurl=https://nodes.lightning.computer/fees/v1/btc-fee-estimates.json  --numgraphsyncpeers=3 ' +
      '--bitcoin.basefee=100000 --bitcoin.feerate=10000 ';

    return Native.start(lndArguments || defaultArguments);
  }

  stop(): Promise<boolean> {
    return Native.stopDaemon();
  }

  wipeLndDir(): Promise<boolean> {
    return Native.wipeLndDir();
  }

  async unlockWallet(password: string = 'bluewallet'): Promise<boolean> {
    if (this._inited) {
      throw new Error('LND is already inited or unlocked');
    }
    this._inited = true; // locking first
    this._inited = await Native.unlockWallet(password);
    return this._inited;
  }

  async walletBalance(): Promise<boolean | object> {
    return RnLndImplementation.jsonOrBoolean(await Native.walletBalance());
  }

  async sendPaymentSync(paymentRequest: string, amtSat: number): Promise<boolean | object> {
    return RnLndImplementation.jsonOrBoolean(await Native.sendPaymentSync(paymentRequest, amtSat));
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

  async getTransactions(): Promise<boolean | object> {
    return RnLndImplementation.jsonOrBoolean(await Native.getTransactions());
  }

  async queryRoutes(sourceHex: string, destHex: string, amtSat: number): Promise<boolean | object> {
    return RnLndImplementation.jsonOrBoolean(await Native.queryRoutes(sourceHex, destHex, amtSat));
  }

  async sendAllCoins(address: string) {
    return RnLndImplementation.jsonOrBoolean(await Native.sendAllCoins(address));
  }

  async getLndDir(): Promise<boolean | string> {
    return await Native.getLndDir();
  }

  async getLogs(): Promise<boolean | string> {
    return await Native.getLogs();
  }

  async waitTillReady(timeout = 30) {
    let c = 0;
    while (1) {
      const connected = await this.connectPeer('34.239.230.56:9735', '03864ef025fde8fb587d989186ce6a4a186895ee44a926bfc370e2c366597a3f8f'); // ACINQ
      if (connected) {
        this._ready = true;
        this._inited = true;
        this._started = true;
        break;
      }
      const peers: any = await this.listPeers();
      if (peers && peers.peers && peers.peers.length) {
        this._ready = true;
        break;
      } else {
        await new Promise((resolve) => setTimeout(resolve, 1000));
      }

      if (c++ >= timeout) throw new Error('waiting for LND timed out');
    }
    console.warn('ready');
    setTimeout(async () => {
      await this.connectPeer('165.227.95.104:9735', '02e89ca9e8da72b33d896bae51d20e7e6675aa971f7557500b6591b15429e717f1'); // lnd1.bluewallet.io
      await this.connectPeer('52.50.244.44:9735', '030c3f19d742ca294a55c00376b3b355c3c90d61c6b6b39554dbc7ac19b141c14f'); // bitrefill
    }, 1);
  }

  /**
   * Tells if LND can accept calls after it was unlocked and fully started
   * (i.e. wont throw "server is still in the process of starting" on our calls)
   */
  isReady() {
    return this._ready;
  }

  isInited() {
    return this._inited;
  }

  isStarted() {
    return this._started;
  }

  async startUnlockAndWait(password: string = 'bluewallet') {
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

  private isObject(o: any) {
    return o === Object(o) && !Array.isArray(o) && typeof o !== 'function';
  }

  private camelToSnakeCase(str: string): string {
    return str.replace(/[A-Z]/g, (letter) => `_${letter.toLowerCase()}`);
  }

  camelCase2SnakeCase(o: any): any {
    if (this.isObject(o)) {
      const n = {};

      Object.keys(o).forEach((k) => {
        (n as any)[this.camelToSnakeCase(k)] = this.camelCase2SnakeCase(o[k]);
      });

      return n;
    } else if (Array.isArray(o)) {
      return o.map((i) => {
        return this.camelCase2SnakeCase(i);
      });
    }

    return o;
  }

  async payInvoiceViaSendToRoute(bolt11: string, freeAmount = false) {
    let amtSat = 0;
    const decoded: any = await this.decodePayReq(bolt11);

    if (freeAmount) {
      amtSat = +freeAmount;
    } else {
      amtSat = decoded.numSatoshis ? parseInt(decoded.numSatoshis, 10) : Math.round(decoded.numMsat / 1000);
    }

    const info: any = await this.getInfo();
    const from = info.identityPubkey;
    const to = decoded.destination;
    const hash = decoded.paymentHash;

    const paymentAddrHex = decoded.paymentAddr ? util.base64ToHex(decoded.paymentAddr) : '';

    let json;

    // lets try quering route internaly first:
    try {
      const routes = await this.queryRoutes(from, to, amtSat);
      json = this.camelCase2SnakeCase(routes);
    } catch (_) {}

    if (!json) {
      // fallback to external router:
      let url = '';
      try {
        let response = await fetch((url = `http://lndhub-staging.herokuapp.com/queryroutes/${from}/${to}/${amtSat}`));
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
