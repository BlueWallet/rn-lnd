import Lndmobile

@objc(RnLnd)

class RnLnd: NSObject {
    
    func getLNDDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory.appendingPathComponent(".lnd")
    }
    
    @objc
    func getLndDir(_ resolve: @escaping RCTPromiseResolveBlock, reject: @escaping RCTPromiseRejectBlock) {
        let path = getLNDDocumentsDirectory().absoluteString
        return resolve(path)
    }
    
    @objc func wipeLndDir(_ resolve: @escaping RCTPromiseResolveBlock, reject: @escaping RCTPromiseRejectBlock) {
        do {
            try FileManager.default.removeItem(at: getLNDDocumentsDirectory())
            return resolve(true)
        } catch {
            return reject("wipeLndDir", error.localizedDescription, error)
        }
    }
    
    func copyFiles() {
        let directory = getLNDDocumentsDirectory().appendingPathComponent( "data/chain/bitcoin/mainnet")
        print(directory)
        do {
            try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true, attributes: nil)
        } catch {
            print("copyFiles failed")
            print(error.localizedDescription)
            return
        }
        let filesToCopy = ["block_headers", "neutrino", "peers", "reg_filter_headers"]
        let filesToCopyExtension = ["bin", "db", "json", "bin"]
        for (index, file) in filesToCopy.enumerated() {
            guard let filePath = Bundle.main.url(forResource: file, withExtension: filesToCopyExtension[index]) else {
                print("unable to find \(file) in app bundle")
                return
            }
            do {
                try FileManager.default.copyItem(at: filePath, to: URL(string: "\(directory)\(file).\(filesToCopyExtension[index])")!)
            } catch {
                print("copy \(file) failed")
                print(error.localizedDescription)
            }
        }
    }
    
    @objc
    func sendToRouteV2(paymentHashHex: String, paymentAddrHex: String, queryRoutesJsonString: String, resolve: @escaping RCTPromiseResolveBlock, reject: @escaping RCTPromiseRejectBlock) -> Void {
        print("ReactNativeLND", "sendRouteV2 queryRoutesJsonString = \(queryRoutesJsonString)");
        do {
            if let data = queryRoutesJsonString.data(using: .utf8), let jsonArray = try JSONSerialization.jsonObject(with: data, options : .allowFragments) as? Dictionary<String,Any>
            {
               print(jsonArray) // use the json here
                let routesJSON = jsonArray["routes"] as? [Dictionary<String,Any>]
                let routeJSON = routesJSON?.first
                let hopsJSON = routeJSON?["hops"] as? [Dictionary<String,Any>]
                var routeTemp = Lnrpc_Route()
                if let totalAmountMSat = routeJSON?["total_amt_msat"] as? String, let totalAmountMSatInt = Int64(totalAmountMSat) {
                    routeTemp.totalAmt = totalAmountMSatInt
                }
                if let totalFeesMSat = routeJSON?["total_fees_msat"] as? String, let totalFeesMSatInt = Int64(totalFeesMSat) {
                    routeTemp.totalFeesMsat = totalFeesMSatInt
                }
                if let totalTimeLock = routeJSON?["total_time_lock"] as? String, let totalTimeLockInt = UInt32(totalTimeLock) {
                    routeTemp.totalTimeLock = totalTimeLockInt
                }
                
                var hopsArray = [Lnrpc_Hop]()
                if let hops = hopsJSON {
                    for (index, hop) in hops.enumerated() {
                        var hopTemp = Lnrpc_Hop()
                        
                        if let chanID = hop["chan_id"] as? String, let chanIDInt = UInt64(chanID) {
                            hopTemp.chanID = chanIDInt
                        }
                        if let chanCapacity = hop["chan_capacity"] as? String, let chanCapacityInt = Int64(chanCapacity) {
                            hopTemp.chanCapacity = chanCapacityInt
                        }
                        if let expiry = hop["expiry"] as? String, let expiryInt = UInt32(expiry) {
                            hopTemp.expiry = expiryInt
                        }
                        if let forwardMSat = hop["amt_to_forward_msat"] as? String, let forwardMSatInt = Int64(forwardMSat) {
                            hopTemp.amtToForwardMsat = forwardMSatInt
                        }
                        if let feeMSat = hop["fee_msat"] as? String, let feeMSatInt = Int64(feeMSat) {
                            hopTemp.feeMsat = feeMSatInt
                        }
                        if let pubKey = hop["pub_key"] as? String {
                            hopTemp.pubKey = pubKey
                        }
                        if let tlvPayLoad = hop["tlv_payload"] as? Bool {
                            hopTemp.tlvPayload = tlvPayLoad
                        }
                        if (!paymentAddrHex.isEmpty && hops.count - 1 == index) {
                            var mppRecord = Lnrpc_MPPRecord()
                            if let paymentAddrData = paymentAddrHex.data(using: .utf8) {
                                mppRecord.paymentAddr = paymentAddrData
                            }
                            if let forwardMSat = hop["amt_to_forward_msat"] as? String, let forwardMSatInt = Int64(forwardMSat) {
                                mppRecord.totalAmtMsat = forwardMSatInt
                            }
                            hopTemp.mppRecord = mppRecord
                        }
                        hopsArray.append(hopTemp)
                    }
                }
                routeTemp.hops = hopsArray
                
                var request = Routerrpc_SendToRouteRequest()
                if let paymentHashHexData = paymentHashHex.data(using: .utf8) {
                    request.paymentHash = paymentHashHexData
                    request.route = routeTemp
                }
                guard let serializedData = try? request.serializedData() else { return }
                let callback = SendToRouteCallback(resolve: resolve, reject: reject)
                LndmobileSendToRouteSync(serializedData, callback)
                
            } else {
                print("bad json")
            }
        } catch let error as NSError {
            print(error)
        }
        
    }
    
    @objc
    func start(_ lndArguments: String, resolve: @escaping RCTPromiseResolveBlock, reject: @escaping RCTPromiseRejectBlock) -> Void {
        print("ReactNativeLND", "start");
        let path = getLNDDocumentsDirectory().appendingPathComponent( "data/chain/bitcoin/mainnet/block_headers.bin")
        if !FileManager.default.fileExists(atPath: path.path) {
            copyFiles()
        }
        let callback = StartCallback(resolve: resolve, reject: reject)
        let callback2 = StartCallback2(resolve: resolve, reject: reject)
        LndmobileStart("\(lndArguments) --lnddir=\(getLNDDocumentsDirectory().path)", callback, callback2);
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
        
        let callback = UnlockWalletCallback(resolve: resolve, reject: reject)

        LndmobileUnlockWallet(serializedData, callback)
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
        let callback = InitWalletCallback(resolve: resolve, reject: reject)
        print(callback)
        return LndmobileInitWallet(serializedData, callback)
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
        let callback = ListChannelsCallback(resolve: resolve, reject: reject)
        return LndmobileListChannels(serializedData, callback)
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
    func openChannelPsbt(_ pubkeyHex: String, amountSats: NSNumber, privateChannel: Bool, resolve: @escaping RCTPromiseResolveBlock, reject: @escaping RCTPromiseRejectBlock) {
        print("ReactNativeLND", "openChannelPsbt");
        
        guard let pubkeyToUse = pubkeyHex.data(using: .utf8) else {
            return reject("openChannelPsbt", "unable to generate pubkeyToUse data object", nil)
        }
        
        let psbtShim = Lnrpc_PsbtShim()
        var fundingShim = Lnrpc_FundingShim()
        fundingShim.psbtShim = psbtShim
        var request = Lnrpc_OpenChannelRequest()
        request.localFundingAmount = amountSats.int64Value
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
        let path = getLNDDocumentsDirectory().appendingPathComponent("logs/bitcoin/mainnet/lnd.log")
        guard let log = FileManager.default.contents(atPath: path.path), let logString = String(data: log, encoding: .utf8) else {
            return reject(nil, nil, nil)
        }
        resolve(logString)
    }
    
    @objc
    func sendPaymentSync(_ paymentRequest: String, satsAmount: NSNumber, resolve: @escaping RCTPromiseResolveBlock, reject: @escaping RCTPromiseRejectBlock) {
        print("ReactNativeLND", "sendPaymentSync");
        var request = Lnrpc_SendRequest()
        request.paymentRequest = paymentRequest
        request.amt = satsAmount.int64Value
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
    func addInvoice(_ sat: NSNumber, memo: String, expiry: NSNumber, resolve: @escaping RCTPromiseResolveBlock, reject: @escaping RCTPromiseRejectBlock) {
        print("ReactNativeLND", "addInvoice");
        var request = Lnrpc_Invoice()
        request.value = sat.int64Value
        request.memo = memo
        request.private = true
        request.expiry = expiry.int64Value
        guard let serializedData = try? request.serializedData() else {
            return reject(nil, nil, nil)
        }
        LndmobileAddInvoice(serializedData, AddInvoiceCallback(resolve: resolve, reject: reject))
    }
    
    @objc
    func queryRoutes(_ sourceHex: String, destHex: String, amtSat: NSNumber, resolve: @escaping RCTPromiseResolveBlock, reject: @escaping RCTPromiseRejectBlock) {
        print("ReactNativeLND", "queryRoutes");
        var request = Lnrpc_QueryRoutesRequest()
        request.amt = amtSat.int64Value
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
        print("ReactNativeLND", "decodePayReq");
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
    
    @objc func closeChannel(_ deliveryAddress: String, fundingTxidHex: String, outputIndex: NSNumber, force: Bool,  resolve: @escaping RCTPromiseResolveBlock, reject: @escaping RCTPromiseRejectBlock) {
        print("ReactNativeLND", "closeChannel");
        
        var channelPoint = Lnrpc_ChannelPoint()
        channelPoint.fundingTxidStr = fundingTxidHex
        channelPoint.outputIndex = outputIndex.uint32Value
        
        var request = Lnrpc_CloseChannelRequest()
        request.channelPoint = channelPoint
        request.deliveryAddress = deliveryAddress
        request.force = force
        
        guard let serializedData = try? request.serializedData() else {
            return reject(nil, nil, nil)
        }
        return LndmobileCloseChannel(serializedData, CloseChannelRecvStream(resolve: resolve, reject: reject))
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
