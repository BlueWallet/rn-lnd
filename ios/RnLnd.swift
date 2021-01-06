import Lndmobile

@objc(RnLnd)
class RnLnd: NSObject {

    @objc
    func start(_ lndArguments: String, resolve: @escaping RCTPromiseResolveBlock, reject: RCTPromiseRejectBlock) -> Void {
        print("ReactNativeLND", "start");
        var argumentsToUse = "--sync-freelist --tlsdisableautofill  --maxpendingchannels=10 " + // --nobootstrap
              "--chan-status-sample-interval=5s --minchansize=1000000 --ignore-historical-gossip-filters --rejecthtlc " +
              "--bitcoin.active --bitcoin.mainnet --bitcoin.defaultchanconfs=0 --routing.assumechanvalid " +
              "--protocol.wumbo-channels --rpclisten=127.0.0.1 --norest --nolisten " +
              "--maxbackoff=2s --enable-upfront-shutdown " + // --chan-enable-timeout=10s  --connectiontimeout=15s
              "--bitcoin.node=neutrino --neutrino.addpeer=btcd-mainnet.lightning.computer --neutrino.maxpeers=100 " +
              "--neutrino.assertfilterheader=660000:08312375fabc082b17fa8ee88443feb350c19a34bb7483f94f7478fa4ad33032 " +
              "--neutrino.feeurl=https://nodes.lightning.computer/fees/v1/btc-fee-estimates.json  --numgraphsyncpeers=0 " +
              "--bitcoin.basefee=100000 --bitcoin.feerate=10000 "; // --chan-disable-timeout=60s

        if (!lndArguments.isEmpty) {
            argumentsToUse = lndArguments;
        }
        let rpcReadyCallback = StartCallback2()
        LndmobileStart(argumentsToUse, StartCallback(resolve: resolve), rpcReadyCallback);
    }
    
    @objc
    func unlockWallet(_ password: String, resolve: @escaping RCTPromiseResolveBlock, reject: RCTPromiseRejectBlock) -> Void {
        print("ReactNativeLND", "unlocking wallet with password -->" + password + "<--");
        /*.
         val pw: ByteString = ByteString.copyFromUtf8(password);
            val reqUnlock: lnrpc.Walletunlocker.UnlockWalletRequest = lnrpc.Walletunlocker
              .UnlockWalletRequest
              .newBuilder()
              .setWalletPassword(pw)
              .build();
            Lndmobile.unlockWallet(reqUnlock.toByteArray(), UnlockWalletCallback(promise));
         */
        var unlockRequest = Lnrpc_UnlockWalletRequest()
        guard let passwordData = password.data(using: .utf8) else {
            return resolve(false)
        }
        unlockRequest.walletPassword = passwordData
        guard let serializedData = try? unlockRequest.serializedData() else {
            return resolve(false)
        }
        LndmobileUnlockWallet(serializedData, StartCallback(resolve: resolve))
    }
    
    @objc
    func initWallet(_ password: String, mnemonics: String, resolve: RCTPromiseResolveBlock, reject: RCTPromiseRejectBlock) -> Void {
        print("ReactNativeLND", "initWallet");
        resolve("")
    }
    
    @objc
    func getInfo(_ resolve: RCTPromiseResolveBlock, reject: RCTPromiseRejectBlock) -> Void {
        print("ReactNativeLND", "getInfo");
        resolve("")
    }
    
    @objc
    func listChannels(_ resolve: RCTPromiseResolveBlock, reject: RCTPromiseRejectBlock) -> Void {
        print("ReactNativeLND", "listChannels");
        resolve("")
    }
    
    @objc
    func pendingChannels(_ resolve: RCTPromiseResolveBlock, reject: RCTPromiseRejectBlock) -> Void {
        print("ReactNativeLND", "pendingChannels");
        resolve("")
    }
    
    @objc
    func fundingStateStepVerify(_ chanIdHex: String, psbtHex: String, resolve: RCTPromiseResolveBlock, reject: RCTPromiseRejectBlock) {
        print("ReactNativeLND", "fundingStateStepVerify");
        resolve("")
    }
    
    @objc
    func fundingStateStepFinalize(_ chanIdHex: String, psbtHex: String,  resolve: RCTPromiseResolveBlock, reject: RCTPromiseRejectBlock) {
        print("ReactNativeLND", "fundingStateStepFinalize");
        resolve("")
    }
    
    @objc
    func openChannelPsbt(_ pubkeyHex: String, amountSats: Int, privateChannel: Bool, resolve: RCTPromiseResolveBlock, reject: RCTPromiseRejectBlock) {
        print("ReactNativeLND", "openChannelPsbt");
        resolve("")
    }
    
    @objc
    func connectPeer(_ host: String, pubkeyHex: String, resolve: RCTPromiseResolveBlock, reject: RCTPromiseRejectBlock) {
        print("ReactNativeLND", "connectPeer");
        resolve("")
    }
    
    @objc
    func walletBalance(_ resolve: RCTPromiseResolveBlock, reject: RCTPromiseRejectBlock) -> Void {
        print("ReactNativeLND", "walletBalance");
        resolve("")
    }
    
    @objc
    func channelBalance(_ resolve: RCTPromiseResolveBlock, reject: RCTPromiseRejectBlock) -> Void {
        print("ReactNativeLND", "channelBalance");
        resolve("")
    }
    
    @objc
    func sendPaymentSync(_ paymentRequest: String, resolve: RCTPromiseResolveBlock, reject: RCTPromiseRejectBlock) {
    }
    
    @objc
    func sendToRouteSync(_ paymentHashHex: String, route: Any, resolve: RCTPromiseResolveBlock, reject: RCTPromiseRejectBlock) {
        print("ReactNativeLND", "sendToRouteSync");
        resolve("")
    }
    
    @objc
    func genSeed(_ resolve: @escaping RCTPromiseResolveBlock, reject: RCTPromiseRejectBlock) -> Void {
        print("ReactNativeLND", "genSeed");
        let request = Lnrpc_GenSeedRequest()
        LndmobileGenSeed(try? request.serializedData()
                         , GenSeedCallback(resolve: resolve))
    }
    
    @objc
    func addInvoice(_ sat: Int, memo: String, expiry: Int, resolve: RCTPromiseResolveBlock, reject: RCTPromiseRejectBlock) {
        print("ReactNativeLND", "addInvoice");
        resolve("")
    }
    
    @objc
    func closeChannel(_ deliveryAddress: String, fundingTxidHex: String, outputIndex: Int, force: Bool,  resolve: RCTPromiseResolveBlock, reject: RCTPromiseRejectBlock) {
        print("ReactNativeLND", "closeChannel");
        resolve("")
        
    }
    
    @objc
    func stopDaemon(_ resolve: @escaping RCTPromiseResolveBlock, reject: RCTPromiseRejectBlock) -> Void {
        print("ReactNativeLND", "stopDaemon");
        let req = Lnrpc_StopRequest()
        let serializedReq = try? req.serializedData()
        LndmobileStopDaemon(serializedReq, StartCallback(resolve: resolve))
    }
    
    @objc
    static func requiresMainQueueSetup() -> Bool {
        return true
    }
    
}
