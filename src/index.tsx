import { NativeModules, NativeEventEmitter } from 'react-native';
import * as base64 from 'base64-js';
import type * as $protobuf from 'protobufjs';

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
  sendCommand(method: string, payload: string): Promise<{ data: string }>;
  sendStreamCommand(method: string, payload: string, streamOnlyOnce: boolean): Promise<string>;
};

interface ISendRequestClass<IReq, Req> {
  create: (options: IReq) => Req;
  encode: (request: Req) => $protobuf.Writer;
}

interface ISendResponseClass<Res> {
  decode: (reader: $protobuf.Reader | Uint8Array) => Res;
  toObject(message: Res, options?: $protobuf.IConversionOptions): { [k: string]: any };
}

interface ISyncCommandOptions<IReq, Req, Res> {
  request: ISendRequestClass<IReq, Req>;
  response: ISendResponseClass<Res>;
  method: string;
  options: IReq;
}

interface IStreamCommandOptions<IReq, Req> {
  request: ISendRequestClass<IReq, Req>;
  method: string;
  options: IReq;
}

interface IStreamResultOptions<Res> {
  base64Result: string;
  response: ISendResponseClass<Res>;
}

const Native: NativeType = NativeModules.RnLnd;
global.Native = Native;

const RnLndEmitter = new NativeEventEmitter(NativeModules.RnLnd);
const subscription3 = RnLndEmitter.addListener('SubscribePeerEvents', (...a) => console.log('SubscribePeerEvents', ...a));

class RnLndImplementation {
  static jsonOrBoolean(str: string | boolean) {
    if (str === true || str === false) return str;

    try {
      return JSON.parse(str);
    } catch (_) {
      return false;
    }
  }

  async ping() {
    const res = await Native.ping('pong');
    return res;
  }

  async sendCommand<IReq, Req, Res>({ request, response, method, options }: ISyncCommandOptions<IReq, Req, Res>): Promise<Res> {
    const instance = request.create(options);
    const payload = base64.fromByteArray(request.encode(instance).finish());
    const b64 = await Native.sendCommand(method, payload);
    const dec = response.decode(base64.toByteArray(b64.data || ''));
    return dec;
  }

  async sendStreamCommand<IReq, Req>({ request, method, options }: IStreamCommandOptions<IReq, Req>, streamOnlyOnce: boolean = false): Promise<string> {
    const instance = request.create(options);
    const payload = base64.fromByteArray(request.encode(instance).finish());
    const response = await Native.sendStreamCommand(method, payload, streamOnlyOnce);
    return response;
  }

  decodeStreamResult<Res>({ base64Result, response }: IStreamResultOptions<Res>): Res {
    return response.decode(base64.toByteArray(base64Result));
  }

  async getInfo2() {
    const response = await this.sendCommand<lnrpc.IGetInfoRequest, lnrpc.GetInfoRequest, lnrpc.GetInfoResponse>({
      method: 'GetInfo',
      options: {},
      request: lnrpc.GetInfoRequest,
      response: lnrpc.GetInfoResponse,
    });
    return response;
  }

  async getTransactions(options: lnrpc.IGetTransactionsRequest) {
    const response = await this.sendCommand<lnrpc.IGetTransactionsRequest, lnrpc.GetTransactionsRequest, lnrpc.TransactionDetails>({
      method: 'GetTransactions',
      options,
      request: lnrpc.GetTransactionsRequest,
      response: lnrpc.TransactionDetails,
    });
    return response;
  }

  async newAddress() {
    const response = await this.sendCommand<lnrpc.INewAddressRequest, lnrpc.NewAddressRequest, lnrpc.NewAddressResponse>({
      method: 'NewAddress',
      options: {},
      request: lnrpc.NewAddressRequest,
      response: lnrpc.NewAddressResponse,
    });
    return response;
  }

  async subscribeTransactions(callback) {
    await this.sendStreamCommand<lnrpc.IGetTransactionsRequest, lnrpc.GetTransactionsRequest>(
      {
        method: 'SubscribeTransactions',
        options: {},
        request: lnrpc.GetTransactionsRequest,
      },
      true
    );

    const subscription = RnLndEmitter.addListener('SubscribeTransactions', (b64) => {
      const data = this.decodeStreamResult<lnrpc.Transaction>({
        response: lnrpc.Transaction,
        base64Result: b64,
      });
      callback(data);
    });

    return subscription;
  }

  async subscribePeerEvents(callback) {
    await this.sendStreamCommand<lnrpc.IPeerEventSubscription, lnrpc.PeerEventSubscription>(
      {
        method: 'SubscribePeerEvents',
        options: {},
        request: lnrpc.PeerEventSubscription,
      },
      true
    );

    const subscription = RnLndEmitter.addListener('SubscribeTransactions', (b64) => {
      const data = this.decodeStreamResult<lnrpc.PeerEvent>({
        response: lnrpc.PeerEvent,
        base64Result: b64,
      });
      callback(data);
    });

    return subscription;
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
