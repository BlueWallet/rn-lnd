import Lndmobile

@objc(RnLnd)

class RnLnd: NSObject {
    
    func getLNDDocumentsDirectory() -> String {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return "\(documentsDirectory.absoluteString)/.lnd"
    }
    
    func wipeLndDir() -> Bool {
        do {
            try FileManager.default.removeItem(atPath: getLNDDocumentsDirectory())
            return true
        } catch {
            return false
        }
    }
    func copyFiles() {
        let directory = "\(getLNDDocumentsDirectory())/data/chain/bitcoin/mainnet"
        do {
            try FileManager.default.createDirectory(atPath: directory, withIntermediateDirectories: true, attributes: nil)
        } catch{
            print("copyFiles failed")
        }
        let filesToCopy = ["block_headers.bin", "neutrino.db", "peers.json", "reg_filter_headers.bin"]
        for file in filesToCopy {
            let filePath = Bundle.main.bundleURL.appendingPathComponent(file)
            do {
                try FileManager.default.copyItem(atPath: filePath.absoluteString, toPath: "\(directory)/\(file)")
            } catch {
                print("copy \(file) failed")
            }
        }
    }
    
    @objc
    func sendToRouteV2(paymentHashHex: String, paymentAddrHex: String, queryRoutesJsonString: String, resolve: @escaping RCTPromiseResolveBlock, reject: @escaping RCTPromiseRejectBlock) -> Void {
    }
    
    @objc
    func start(_ lndArguments: String, resolve: @escaping RCTPromiseResolveBlock, reject: @escaping RCTPromiseRejectBlock) -> Void {
        print("ReactNativeLND", "start");
       
        if !FileManager.default.fileExists(atPath: "\(getLNDDocumentsDirectory())/data/chain/bitcoin/mainnet/block_headers.bin") {
            copyFiles()
        }
        let callback = StartCallback(resolve: resolve, reject: reject)
        let callback2 = StartCallback2(resolve: resolve, reject: reject)
        LndmobileStart(lndArguments + " --lnddir=" + getLNDDocumentsDirectory(), callback, callback2);
    }
    
    @objc
    func unlockWallet(_ password: String, resolve: @escaping RCTPromiseResolveBlock, reject: @escaping RCTPromiseRejectBlock) -> Void {
        print("ReactNativeLND", "unlocking wallet with password -->" + password + "<--");
        var unlockRequest = Lnrpc_UnlockWalletRequest()
        guard let passwordData = password.data(using: .utf8) else {
            return reject("ReactNativeLND unlockWallet", "unable to generate password data", nil)
        }
        unlockRequest.walletPassword = passwordData
        guard let serializedData = try? unlockRequest.serializedData() else {
            return reject("ReactNativeLND unlockWallet", "unable to generate serialized data", nil)
        }
        
        LndmobileUnlockWallet(serializedData, UnlockWalletCallback(resolve: resolve, reject: reject))
    }
    
    @objc
    func initWallet(_ password: String, mnemonics: String, resolve: @escaping RCTPromiseResolveBlock, reject: @escaping RCTPromiseRejectBlock) -> Void {
        print("ReactNativeLND", "initWallet");
        guard let passwordData = password.data(using: .utf8) else {
            return reject("ReactNativeLND initWallet", "unable to generate password data object", nil)
        }
        let cipherSeed = mnemonics.components(separatedBy: " ")
        var request = Lnrpc_InitWalletRequest()
        request.walletPassword = passwordData
        request.recoveryWindow = 0
        request.cipherSeedMnemonic = cipherSeed
        
        guard let serializedData = try? request.serializedData() else {
            return reject(nil, nil, nil)
        }
        LndmobileInitWallet(serializedData, InitWalletCallback(resolve: resolve, reject: reject))
    }
    
    @objc
    func getInfo(_ resolve: @escaping RCTPromiseResolveBlock, reject: @escaping RCTPromiseRejectBlock) -> Void {
        print("ReactNativeLND", "getInfo");
        let request = Lnrpc_GetInfoRequest()
        
        guard let serializedData = try? request.serializedData() else {
            return reject(nil, nil, nil)
        }
        LndmobileGetInfo(serializedData, GetInfoCallback(resolve: resolve, reject: reject))
    }
    
    @objc
    func listPeers(_ resolve: @escaping RCTPromiseResolveBlock, reject: @escaping RCTPromiseRejectBlock) -> Void {
        print("ReactNativeLND", "listPeers");
        let request = Lnrpc_ListPeersRequest()
        
        guard let serializedData = try? request.serializedData() else {
            return reject(nil, nil, nil)
        }
        LndmobileListPeers(serializedData, ListPeersCallback(resolve: resolve, reject: reject))
    }
    
    @objc
    func listChannels(_ resolve: @escaping RCTPromiseResolveBlock, reject: @escaping RCTPromiseRejectBlock) -> Void {
        print("ReactNativeLND", "listChannels");
        let request = Lnrpc_ListChannelsRequest()
        
        guard let serializedData = try? request.serializedData() else {
            return reject(nil, nil, nil)
        }
        LndmobileListChannels(serializedData, ListChannelsCallback(resolve: resolve, reject: reject))
    }
    
    @objc
    func pendingChannels(_ resolve: @escaping RCTPromiseResolveBlock, reject: @escaping RCTPromiseRejectBlock) -> Void {
        print("ReactNativeLND", "pendingChannels");
        let request = Lnrpc_PendingChannelsRequest()
        
        guard let serializedData = try? request.serializedData() else {
            return reject(nil, nil, nil)
        }
        LndmobilePendingChannels(serializedData, PendingChannelsCallback(resolve: resolve, reject: reject))
    }
    
    @objc
    func fundingStateStepVerify(_ chanIdHex: String, psbtHex: String, resolve: @escaping RCTPromiseResolveBlock, reject: @escaping RCTPromiseRejectBlock) {
        print("ReactNativeLND", "fundingStateStepVerify");
        
        guard let chanIdHexData = chanIdHex.data(using: .utf8), let psbtData = psbtHex.data(using: .utf8) else {
            return reject("fundingStateStepVerify", "unable to generate chanIdHex/psbtHex data objects", nil)
        }
        
        var funding = Lnrpc_FundingPsbtVerify()
        funding.pendingChanID = chanIdHexData
        funding.fundedPsbt = psbtData
        
        var request = Lnrpc_FundingTransitionMsg()
        request.psbtVerify = funding
        
        guard let serializedData = try? request.serializedData() else {
            return reject(nil, nil, nil)
        }
        LndmobileFundingStateStep(serializedData, FundingStateStepCallback(resolve: resolve, reject: reject))
    }
    
    @objc
    func fundingStateStepFinalize(_ chanIdHex: String, psbtHex: String,  resolve: @escaping RCTPromiseResolveBlock, reject: @escaping RCTPromiseRejectBlock) {
        print("ReactNativeLND", "fundingStateStepFinalize");
        
        guard let chanIdHexData = chanIdHex.data(using: .utf8), let psbtData = psbtHex.data(using: .utf8) else {
            return reject("fundingStateStepFinalize", "unable to generate chanIdHex/psbtHex data objects", nil)
            
        }
        
        var funding = Lnrpc_FundingPsbtFinalize()
        funding.pendingChanID = chanIdHexData
        funding.signedPsbt = psbtData
        
        var request = Lnrpc_FundingTransitionMsg()
        request.psbtFinalize = funding
        guard let serializedData = try? request.serializedData() else {
            return reject(nil, nil, nil)
        }
        LndmobileFundingStateStep(serializedData, FundingStateStepCallback(resolve: resolve, reject: reject))
    }
    
    @objc
    func fundingStateStepCancel(_ chanIdHex: String, resolve: @escaping RCTPromiseResolveBlock, reject: @escaping RCTPromiseRejectBlock) {
        print("ReactNativeLND", "fundingStateStep");
        
        guard let chanIdHexData = chanIdHex.data(using: .utf8) else {
            return reject("fundingStateStepCancel", "unable to generate chanIdHex/psbtHex data objects", nil)
            
        }
        
        var fundingShimCancel = Lnrpc_FundingShimCancel()
        fundingShimCancel.pendingChanID = chanIdHexData
        
        var request = Lnrpc_FundingTransitionMsg()
        request.shimCancel = fundingShimCancel
        guard let serializedData = try? request.serializedData() else {
            return reject(nil, nil, nil)
        }
        LndmobileFundingStateStep(serializedData, FundingStateStepCallback(resolve: resolve, reject: reject))
    }
    
    @objc
    func openChannelPsbt(_ pubkeyHex: String, amountSats: Int, privateChannel: Bool, resolve: @escaping RCTPromiseResolveBlock, reject: @escaping RCTPromiseRejectBlock) {
        print("ReactNativeLND", "openChannelPsbt");
        
        guard let pubkeyToUse = pubkeyHex.data(using: .utf8) else {
            return reject("openChannelPsbt", "unable to generate pubkeyToUse data object", nil)
        }
        
        let psbtShim = Lnrpc_PsbtShim()
        var fundingShim = Lnrpc_FundingShim()
        fundingShim.psbtShim = psbtShim
        var request = Lnrpc_OpenChannelRequest()
        request.localFundingAmount = Int64(amountSats)
        request.nodePubkey = pubkeyToUse
        request.fundingShim = fundingShim
        request.private = privateChannel
        guard let serializedData = try? request.serializedData() else {
            return reject(nil, nil, nil)
        }
        LndmobileOpenChannel(serializedData, OpenChannelRecvStream(resolve: resolve, reject: reject))
    }
    
    @objc
    func connectPeer(_ host: String, pubkeyHex: String, resolve: @escaping RCTPromiseResolveBlock, reject: @escaping RCTPromiseRejectBlock) {
        print("ReactNativeLND", "connectPeer");
        
        var address = Lnrpc_LightningAddress()
        address.host = host
        address.pubkey = pubkeyHex
        var request = Lnrpc_ConnectPeerRequest()
        request.addr = address
        guard let serializedData = try? request.serializedData() else {
            return reject(nil, nil, nil)
        }
        LndmobileConnectPeer(serializedData, EmptyResponseBooleanCallback(resolve: resolve, reject: reject))
    }
    
    @objc
    func walletBalance(_ resolve: @escaping RCTPromiseResolveBlock, reject: @escaping RCTPromiseRejectBlock) -> Void {
        print("ReactNativeLND", "walletBalance");
        let request = Lnrpc_WalletBalanceRequest()
        guard let serializedData = try? request.serializedData() else {
            return reject(nil, nil, nil)
        }
        LndmobileWalletBalance(serializedData, WalletBalanceCallback(resolve: resolve, reject: reject))
    }
    
    @objc
    func getTransactions(_ resolve: @escaping RCTPromiseResolveBlock, reject: @escaping RCTPromiseRejectBlock) -> Void {
        print("ReactNativeLND", "getTransactions");
        let request = Lnrpc_GetTransactionsRequest()
        guard let serializedData = try? request.serializedData() else {
            return reject(nil, nil, nil)
        }
        LndmobileGetTransactions(serializedData, GetTransactionsCallback(resolve: resolve, reject: reject))
    }
    
    @objc
    func channelBalance(_ resolve: @escaping RCTPromiseResolveBlock, reject: @escaping RCTPromiseRejectBlock) -> Void {
        print("ReactNativeLND", "channelBalance");
        let request = Lnrpc_ChannelBalanceRequest()
        guard let serializedData = try? request.serializedData() else {
            return reject(nil, nil, nil)
        }
        LndmobileChannelBalance(serializedData, ChannelBalanceCallback(resolve: resolve, reject: reject))
    }
    
    @objc
    func listInvoices(_ resolve: @escaping RCTPromiseResolveBlock, reject: @escaping RCTPromiseRejectBlock) -> Void {
        print("ReactNativeLND", "listInvoices");
        let request = Lnrpc_ListInvoiceRequest()
        guard let serializedData = try? request.serializedData() else {
            return reject(nil, nil, nil)
        }
        LndmobileListInvoices(serializedData, ListInvoicesCallback(resolve: resolve, reject: reject))
    }
    
    @objc
    func getLogs(_ resolve: @escaping RCTPromiseResolveBlock, reject: @escaping RCTPromiseRejectBlock) {
        guard let log = FileManager.default.contents(atPath: "\(getLNDDocumentsDirectory())/logs/bitcoin/mainnet/lnd.log"), let logString = String(data: log, encoding: .utf8) else {
            return reject(nil, nil, nil)
        }
        resolve(logString)
    }
    
    @objc
    func sendPaymentSync(_ paymentRequest: String, satsAmount: Int64, resolve: @escaping RCTPromiseResolveBlock, reject: @escaping RCTPromiseRejectBlock) {
        print("ReactNativeLND", "sendPaymentSync");
        var request = Lnrpc_SendRequest()
        request.paymentRequest = paymentRequest
        request.amt = satsAmount
        guard let serializedData = try? request.serializedData() else {
            return reject(nil, nil, nil)
        }
        LndmobileSendPaymentSync(serializedData, SendPaymentSyncCallback(resolve: resolve, reject: reject))
    }
    
    @objc
    func genSeed(_ resolve: @escaping RCTPromiseResolveBlock, reject: @escaping RCTPromiseRejectBlock) -> Void {
        print("ReactNativeLND", "genSeed");
        let request = Lnrpc_GenSeedRequest()
        guard let serializedData = try? request.serializedData() else {
            return reject(nil, nil, nil)
        }
        LndmobileGenSeed(serializedData
                         , GenSeedCallback(resolve: resolve, reject: reject))
    }
    
    @objc
    func addInvoice(_ sat: Int, memo: String, expiry: Int, resolve: @escaping RCTPromiseResolveBlock, reject: @escaping RCTPromiseRejectBlock) {
        print("ReactNativeLND", "addInvoice");
        var request = Lnrpc_Invoice()
        request.value = Int64(sat)
        request.memo = memo
        request.private = true
        request.expiry = Int64(expiry)
        guard let serializedData = try? request.serializedData() else {
            return reject(nil, nil, nil)
        }
        LndmobileAddInvoice(serializedData, AddInvoiceCallback(resolve: resolve, reject: reject))
    }
    
    @objc
    func queryRoutes(_ sourceHex: String, destHex: String, amtSat: Int, resolve: @escaping RCTPromiseResolveBlock, reject: @escaping RCTPromiseRejectBlock) {
        print("ReactNativeLND", "queryRoutes");
        var request = Lnrpc_QueryRoutesRequest()
        request.amt = Int64(amtSat)
        request.useMissionControl = true
        request.pubKey = destHex
        request.sourcePubKey = sourceHex
        guard let serializedData = try? request.serializedData() else {
            return reject(nil, nil, nil)
        }
        LndmobileQueryRoutes(serializedData, QueryRoutesCallback(resolve: resolve, reject: reject))
    }
    
    @objc
    func decodePayReq(_ paymentRequest: String, resolve: @escaping RCTPromiseResolveBlock, reject: @escaping RCTPromiseRejectBlock) {
        print("ReactNativeLND", "queryRoutes");
        var request = Lnrpc_PayReqString()
        request.payReq = paymentRequest
        guard let serializedData = try? request.serializedData() else {
            return reject(nil, nil, nil)
        }
        LndmobileDecodePayReq(serializedData, DecodePayReqCallback(resolve: resolve, reject: reject))
    }
    
    @objc
    func sendAllCoins(_ address: String, resolve: @escaping RCTPromiseResolveBlock, reject: @escaping RCTPromiseRejectBlock) {
        print("ReactNativeLND", "sendAllCoins");
        var request = Lnrpc_SendCoinsRequest()
        request.addr = address
        request.sendAll = true
        guard let serializedData = try? request.serializedData() else {
            return reject(nil, nil, nil)
        }
        LndmobileSendCoins(serializedData, SendCoinsCallback(resolve: resolve, reject: reject))
    }
    
    @objc
    func listPayments(_ resolve: @escaping RCTPromiseResolveBlock, reject: @escaping RCTPromiseRejectBlock) {
        print("ReactNativeLND", "listPayments");
        let request = Lnrpc_ListPaymentsRequest()
        guard let serializedData = try? request.serializedData() else {
            return reject(nil, nil, nil)
        }
        LndmobileListPayments(serializedData, ListPaymentsCallback(resolve: resolve, reject: reject))
    }
    
    @objc
    func closeChannel(_ deliveryAddress: String, fundingTxidHex: String, outputIndex: Int, force: Bool,  resolve: @escaping RCTPromiseResolveBlock, reject: @escaping RCTPromiseRejectBlock) {
        print("ReactNativeLND", "closeChannel");
        
        var channelPoint = Lnrpc_ChannelPoint()
        channelPoint.fundingTxidStr = fundingTxidHex
        channelPoint.outputIndex = UInt32(outputIndex)
        
        var request = Lnrpc_CloseChannelRequest()
        request.channelPoint = channelPoint
        request.deliveryAddress = deliveryAddress
        request.force = force
        
        guard let serializedData = try? request.serializedData() else {
            return reject(nil, nil, nil)
        }
        LndmobileCloseChannel(serializedData, CloseChannelRecvStream(resolve: resolve, reject: reject))
    }
    
    @objc
    func stopDaemon(_ resolve: @escaping RCTPromiseResolveBlock, reject: @escaping RCTPromiseRejectBlock) -> Void {
        print("ReactNativeLND", "stopDaemon");
        let request = Lnrpc_StopRequest()
        guard let serializedData = try? request.serializedData() else {
            return reject(nil, nil, nil)
        }
        LndmobileStopDaemon(serializedData, EmptyResponseBooleanCallback(resolve: resolve, reject: reject))
    }
    
    @objc
    static func requiresMainQueueSetup() -> Bool {
        return true
    }
    
}
