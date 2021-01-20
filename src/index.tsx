import { NativeModules } from 'react-native';
import * as base64 from 'base64-js';
import { lnrpc } from './proto';

type NativeType = {
  start(lndArguments: string): Promise<boolean>;
  stopDaemon(): Promise<boolean>;
  unlockWallet(password: string): Promise<boolean>;
  initWallet(password: string, mnemonics: string): Promise<boolean>;
  getInfo(): Promise<boolean | string>;
  listChannels(): Promise<boolean | string>;
  pendingChannels(): Promise<boolean | string>;
  walletBalance(): Promise<boolean | string>;
  channelBalance(): Promise<boolean | string>;
  connectPeer(host: string, pubkeyHex: string): Promise<boolean>;
  openChannelPsbt(pubkeyHex: string, amountSats: number, privateChannel: boolean): Promise<boolean | string>;
  fundingStateStepVerify(chanIdHex: string, psbtHex: string): Promise<boolean | string>;
  fundingStateStepFinalize(chanIdHex: string, psbtHex: string): Promise<boolean | string>;
  genSeed(): Promise<boolean | string>;
  sendPaymentSync(paymentRequest: string): Promise<boolean | string>;
  addInvoice(sat: number, memo: string, expiry: number): Promise<boolean | string>;
  closeChannel(deliveryAddress: string, fundingTxidHex: string, outputIndex: number, force: boolean): Promise<boolean | string>;
};

const Native: NativeType = NativeModules.RnLnd;
global.Native = Native;

class RnLndImplementation {
  static jsonOrBoolean(str: string | boolean) {
    if (str === true || str === false) return str;

    try {
      return JSON.parse(str);
    } catch (_) {
      return false;
    }
  }

  async sendCommand({ request, response, method, options = {} }): Promise<object> {
    const instance = request.create(options);
    const payload = base64.fromByteArray(request.encode(instance).finish());
    const b64 = await Native.sendCommand(method, payload);
    const dec = response.decode(base64.toByteArray(b64.data || ''));
    return dec;
  }

  async getInfo2(): Promise<lnrpc.GetInfoResponse> {
    const response = await this.sendCommand<lnrpc.IGetInfoRequest, lnrpc.GetInfoRequest, lnrpc.GetInfoResponse>({
      method: 'GetInfo',
      request: lnrpc.GetInfoRequest,
      response: lnrpc.GetInfoResponse,
    });
    return response;
  }

  async getTransactions(options: lnrpc.IGetTransactionsRequest): Promise<lnrpc.GetInfoResponse> {
    const response = await this.sendCommand<lnrpc.IGetTransactionsRequest, lnrpc.GetTransactionsRequest, lnrpc.TransactionDetails>({
      method: 'GetTransactions',
      options,
      request: lnrpc.GetTransactionsRequest,
      response: lnrpc.TransactionDetails,
    });
    return response;
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

  async pendingChannels(): Promise<boolean | object> {
    return RnLndImplementation.jsonOrBoolean(await Native.pendingChannels());
  }

  async openChannelPsbt(pubkeyHex: string, amountSats: number, privateChannel: boolean): Promise<boolean | object> {
    return RnLndImplementation.jsonOrBoolean(await Native.openChannelPsbt(pubkeyHex, amountSats, privateChannel));
  }

  start(lndArguments: string): Promise<boolean> {
    return Native.start(lndArguments);
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

  async addInvoice(sat: number, memo: string, expiry: number): Promise<boolean | object> {
    return RnLndImplementation.jsonOrBoolean(await Native.addInvoice(sat, memo, expiry));
  }

  async closeChannel(deliveryAddress: string, fundingTxidHex: string, outputIndex: number, force: boolean): Promise<boolean | object> {
    return RnLndImplementation.jsonOrBoolean(await Native.closeChannel(deliveryAddress, fundingTxidHex, outputIndex, force));
  }
}

export default new RnLndImplementation();
