declare class RnLndImplementation {
    /**
     * Flag that prevents calling LND start twice, as it leads to app crash
     * @private
     */
    private _started;
    /**
     * Flag that shows whether we already Inited or Unlocked LND. It wont crash
     * if called again, but rather idicates theres a bug in logic on upper level
     * @private
     */
    private _inited;
    static jsonOrBoolean(str: string | boolean): any;
    channelBalance(): Promise<boolean | object>;
    connectPeer(host: string, pubkeyHex: string): Promise<boolean>;
    fundingStateStepVerify(chanIdHex: string, psbtHex: string): Promise<boolean | object>;
    fundingStateStepFinalize(chanIdHex: string, psbtHex: string): Promise<boolean | object>;
    genSeed(): Promise<boolean | string>;
    getInfo(): Promise<boolean | object>;
    initWallet(password: string, mnemonics: string): Promise<boolean>;
    listChannels(): Promise<boolean | object>;
    listPeers(): Promise<boolean | object>;
    pendingChannels(): Promise<boolean | object>;
    openChannelPsbt(pubkeyHex: string, amountSats: number, privateChannel: boolean): Promise<boolean | object>;
    start(lndArguments: string): Promise<boolean>;
    stop(): Promise<boolean>;
    wipeLndDir(): Promise<boolean>;
    unlockWallet(password: string): Promise<boolean>;
    walletBalance(): Promise<boolean | object>;
    sendPaymentSync(paymentRequest: string): Promise<boolean | object>;
    sendToRouteV2(paymentHashHex: string, paymentAddrHex: string, routesJsonString: string): Promise<boolean | object>;
    decodePayReq(paymentRequest: string): Promise<boolean | object>;
    addInvoice(sat: number, memo: string, expiry: number): Promise<boolean | object>;
    closeChannel(deliveryAddress: string, fundingTxidHex: string, outputIndex: number, force: boolean): Promise<boolean | object>;
    listPayments(): Promise<boolean | object>;
    listInvoices(): Promise<boolean | object>;
    getTransactions(): Promise<boolean | object>;
    getLndDir(): Promise<boolean | string>;
    getLogs(): Promise<boolean | string>;
    waitTillReady(): Promise<void>;
    startUnlockAndWait(password?: string): Promise<void>;
    payInvoiceViaSendToRoute(bolt11: string): Promise<boolean | object>;
}
declare const _default: RnLndImplementation;
export default _default;
