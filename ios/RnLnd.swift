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
        var unlockRequest = Lnrpc_UnlockWalletRequest()
        guard let passwordData = password.data(using: .utf8) else {
            return resolve(false)
        }
        unlockRequest.walletPassword = passwordData
        guard let serializedData = try? unlockRequest.serializedData() else {
            return resolve(false)
        }
        LndmobileUnlockWallet(serializedData, UnlockWalletCallback(resolve: resolve))
    }
    
    @objc
    func initWallet(_ password: String, mnemonics: String, resolve: @escaping RCTPromiseResolveBlock, reject: RCTPromiseRejectBlock) -> Void {
        print("ReactNativeLND", "initWallet");
        guard let passwordData = password.data(using: .utf8) else { return resolve(false) }
        let cipherSeed = mnemonics.components(separatedBy: " ")
        var request = Lnrpc_InitWalletRequest()
        request.walletPassword = passwordData
        request.cipherSeedMnemonic = cipherSeed
        
        LndmobileInitWallet(try? request.serializedData(), InitWalletCallback(resolve: resolve))
    }
    
    @objc
    func getInfo(_ resolve: @escaping RCTPromiseResolveBlock, reject: RCTPromiseRejectBlock) -> Void {
        print("ReactNativeLND", "getInfo");
        let request = Lnrpc_GetInfoRequest()
        LndmobileGetInfo(try? request.serializedData(), GetInfoCallback(resolve: resolve))
    }
    
    @objc
    func listChannels(_ resolve: @escaping RCTPromiseResolveBlock, reject: RCTPromiseRejectBlock) -> Void {
        print("ReactNativeLND", "listChannels");
        let request = Lnrpc_ListChannelsRequest()
        LndmobileListChannels(try? request.serializedData(), ListChannelsCallback(resolve: resolve))
    }
    
    @objc
    func pendingChannels(_ resolve: @escaping RCTPromiseResolveBlock, reject: RCTPromiseRejectBlock) -> Void {
        print("ReactNativeLND", "pendingChannels");
        let request = Lnrpc_PendingChannelsRequest()
        LndmobilePendingChannels(try? request.serializedData(), PendingChannelsCallback(resolve: resolve))
    }
    
    @objc
    func fundingStateStepVerify(_ chanIdHex: String, psbtHex: String, resolve: @escaping RCTPromiseResolveBlock, reject: RCTPromiseRejectBlock) {
        print("ReactNativeLND", "fundingStateStepVerify");
        
        guard let chanIdHexData = chanIdHex.data(using: .utf8), let psbtData = psbtHex.data(using: .utf8) else { return resolve(false) }
        
        var funding = Lnrpc_FundingPsbtVerify()
        funding.pendingChanID = chanIdHexData
        funding.fundedPsbt = psbtData
        
        var request = Lnrpc_FundingTransitionMsg()
        request.psbtVerify = funding
        LndmobileFundingStateStep(try? request.serializedData(), FundingStateStepCallback(resolve: resolve))
    }
    
    @objc
    func fundingStateStepFinalize(_ chanIdHex: String, psbtHex: String,  resolve: @escaping RCTPromiseResolveBlock, reject: RCTPromiseRejectBlock) {
        print("ReactNativeLND", "fundingStateStepFinalize");
        
        
        guard let chanIdHexData = chanIdHex.data(using: .utf8), let psbtData = psbtHex.data(using: .utf8) else { return resolve(false) }
        
        var funding = Lnrpc_FundingPsbtFinalize()
        funding.pendingChanID = chanIdHexData
        funding.signedPsbt = psbtData
        
        var request = Lnrpc_FundingTransitionMsg()
        request.psbtFinalize = funding
        LndmobileFundingStateStep(try? request.serializedData(), FundingStateStepCallback(resolve: resolve))
    }
    
    @objc
    func openChannelPsbt(_ pubkeyHex: String, amountSats: Int, privateChannel: Bool, resolve: @escaping RCTPromiseResolveBlock, reject: RCTPromiseRejectBlock) {
        print("ReactNativeLND", "openChannelPsbt");
        
        guard let pubkeyToUse = pubkeyHex.data(using: .utf8) else { return resolve(false) }
        
        let psbtShim = Lnrpc_PsbtShim()
        var fundingShim = Lnrpc_FundingShim()
        fundingShim.psbtShim = psbtShim
        var request = Lnrpc_OpenChannelRequest()
        request.localFundingAmount = Int64(amountSats)
        request.nodePubkey = pubkeyToUse
        request.fundingShim = fundingShim
        request.private = privateChannel

        LndmobileOpenChannel(try? request.serializedData(), OpenChannelRecvStream(resolve: resolve))
    }
    
    @objc
    func connectPeer(_ host: String, pubkeyHex: String, resolve: @escaping RCTPromiseResolveBlock, reject: RCTPromiseRejectBlock) {
        print("ReactNativeLND", "connectPeer");
        
        var address = Lnrpc_LightningAddress()
        address.host = host
        address.pubkey = pubkeyHex
        var request = Lnrpc_ConnectPeerRequest()
        request.addr = address
        LndmobileConnectPeer(try? request.serializedData(), EmptyResponseBooleanCallback(resolve: resolve))
    }
    
    @objc
    func walletBalance(_ resolve: @escaping RCTPromiseResolveBlock, reject: RCTPromiseRejectBlock) -> Void {
        print("ReactNativeLND", "walletBalance");
        let request = Lnrpc_WalletBalanceRequest()
        LndmobileWalletBalance(try? request.serializedData(), WalletBalanceCallback(resolve: resolve))
    }
    
    @objc
    func channelBalance(_ resolve: @escaping RCTPromiseResolveBlock, reject: RCTPromiseRejectBlock) -> Void {
        print("ReactNativeLND", "channelBalance");
        let request = Lnrpc_ChannelBalanceRequest()
        LndmobileChannelBalance(try? request.serializedData(), ChannelBalanceCallback(resolve: resolve))
    }
    
    @objc
    func sendPaymentSync(_ paymentRequest: String, resolve: @escaping RCTPromiseResolveBlock, reject: RCTPromiseRejectBlock) {
        print("ReactNativeLND", "sendPaymentSync");
        var request = Lnrpc_SendRequest()
        request.paymentRequest = paymentRequest
        LndmobileSendPaymentSync(try? request.serializedData(), SendPaymentSyncCallback(resolve: resolve))
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
    func addInvoice(_ sat: Int, memo: String, expiry: Int, resolve: @escaping RCTPromiseResolveBlock, reject: RCTPromiseRejectBlock) {
        print("ReactNativeLND", "addInvoice");
        var request = Lnrpc_Invoice()
        request.value = Int64(sat)
        request.memo = memo
        request.private = true
        request.expiry = Int64(expiry)
        LndmobileAddInvoice(try? request.serializedData(), AddInvoiceCallback(resolve: resolve))
    }
    
    @objc
    func closeChannel(_ deliveryAddress: String, fundingTxidHex: String, outputIndex: Int, force: Bool,  resolve: @escaping RCTPromiseResolveBlock, reject: RCTPromiseRejectBlock) {
        print("ReactNativeLND", "closeChannel");
        
        var channelPoint = Lnrpc_ChannelPoint()
        channelPoint.fundingTxidStr = fundingTxidHex
        channelPoint.outputIndex = UInt32(outputIndex)
        
        var request = Lnrpc_CloseChannelRequest()
        request.channelPoint = channelPoint
        request.deliveryAddress = deliveryAddress
        request.force = force
        
        LndmobileCloseChannel(try? request.serializedData(), CloseChannelRecvStream(resolve: resolve))
    }
    
    @objc
    func stopDaemon(_ resolve: @escaping RCTPromiseResolveBlock, reject: RCTPromiseRejectBlock) -> Void {
        print("ReactNativeLND", "stopDaemon");
        let req = Lnrpc_StopRequest()
        let serializedReq = try? req.serializedData()
        LndmobileStopDaemon(serializedReq, EmptyResponseBooleanCallback(resolve: resolve))
    }
    
    @objc
    static func requiresMainQueueSetup() -> Bool {
        return true
    }
    
}
