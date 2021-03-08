import Lndmobile

@objc(RnLnd)

class RnLnd: NSObject {
    
    private func stringToBytes(_ string: String) -> [UInt8]? {
        let length = string.count
        if length & 1 != 0 {
            return nil
        }
        var bytes = [UInt8]()
        bytes.reserveCapacity(length/2)
        var index = string.startIndex
        for _ in 0..<length/2 {
            let nextIndex = string.index(index, offsetBy: 2)
            if let b = UInt8(string[index..<nextIndex], radix: 16) {
                bytes.append(b)
            } else {
                return nil
            }
            index = nextIndex
        }
        return bytes
    }
    
    private func base64BytesStringToData(string: String) -> Data? {
        return Data(base64Encoded: string)
    }
    
    private func stringToBytesToData(string: String) -> Data? {
        guard let bytes = stringToBytes(string) else {
            return nil;
        }
        return Data(bytes: bytes)
    }
    
    private func stringToBytesToDataBase64Encoded(string: String) -> Data? {
        guard let bytes = stringToBytes(string) else {
            return nil;
        }
        return Data(bytes: bytes).base64EncodedData()
    }
    
    private func generateRandomBytes() -> String? {
        let bytes = [UInt8](repeating: 0, count: 32).map { _ in arc4random() }
        let data = Data(bytes: bytes, count: 32)
        return data.base64EncodedString()
    }
    
    func getLNDDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory.appendingPathComponent(".lnd")
    }
    
    @objc
    func getLndDir(_ resolve: @escaping RCTPromiseResolveBlock, reject: @escaping RCTPromiseResolveBlock) {
        let path = getLNDDocumentsDirectory().absoluteString
        return resolve(path)
    }
    
    @objc func wipeLndDir(_ resolve: @escaping RCTPromiseResolveBlock, reject: @escaping RCTPromiseResolveBlock) {
        do {
            try FileManager.default.removeItem(at: getLNDDocumentsDirectory())
            return resolve(true)
        } catch {
            return resolve(false)
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
    func sendToRouteV2(_ paymentHashHex: String, paymentAddrHex: String, queryRoutesJsonString: String, resolve: @escaping RCTPromiseResolveBlock, reject: @escaping RCTPromiseResolveBlock) -> Void {
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
                if let paymentHashHexData = stringToBytesToData(string: paymentHashHex) {
                    request.paymentHash = paymentHashHexData
                    request.route = routeTemp
                }
                guard let serializedData = try? request.serializedData() else { return }
                let callback = SendToRouteCallback(resolve: resolve)
                LndmobileSendToRouteSync(serializedData, callback)
                
            } else {
                print("bad json")
            }
        } catch let error as NSError {
            print(error)
        }
        
    }
    
    @objc
    func start(_ lndArguments: String, resolve: @escaping RCTPromiseResolveBlock, reject: @escaping RCTPromiseResolveBlock) -> Void {
        print("ReactNativeLND", "start");
        let path = getLNDDocumentsDirectory().appendingPathComponent( "data/chain/bitcoin/mainnet/block_headers.bin")
        if !FileManager.default.fileExists(atPath: path.path) {
            copyFiles()
        }
        LndmobileStart("\(lndArguments) --lnddir=\(getLNDDocumentsDirectory().path)", StartCallback(resolve: resolve), StartCallback2())
    }
    
    @objc
    func unlockWallet(_ password: String, resolve: @escaping RCTPromiseResolveBlock, reject: @escaping RCTPromiseResolveBlock) -> Void {
        print("ReactNativeLND", "unlocking wallet with password -->" + password + "<--");
        var unlockRequest = Lnrpc_UnlockWalletRequest()
        guard let passwordData = password.data(using: .utf8) else {
            return resolve(false)
        }
        unlockRequest.walletPassword = passwordData
        guard let serializedData = try? unlockRequest.serializedData() else {
            return resolve(false)
        }
        
        let callback = UnlockWalletCallback(resolve: resolve)

        LndmobileUnlockWallet(serializedData, callback)
    }
    
    @objc
    func initWallet(_ password: String, mnemonics: String, resolve: @escaping RCTPromiseResolveBlock, reject: @escaping RCTPromiseResolveBlock) -> Void {
        print("ReactNativeLND", "initWallet");
        guard let passwordData = password.data(using: .utf8) else {
            return resolve(false)
        }
        let cipherSeed = mnemonics.components(separatedBy: " ")
        var request = Lnrpc_InitWalletRequest()
        request.walletPassword = passwordData
        request.recoveryWindow = 0
        request.cipherSeedMnemonic = cipherSeed
        
        guard let serializedData = try? request.serializedData() else {
            return resolve(false)
        }
        let callback = InitWalletCallback(resolve: resolve)
        print(callback)
        LndmobileInitWallet(serializedData, callback)
    }
    
    @objc
    func getInfo(_ resolve: @escaping RCTPromiseResolveBlock, reject: @escaping RCTPromiseResolveBlock) -> Void {
        print("ReactNativeLND", "getInfo");
        let request = Lnrpc_GetInfoRequest()
        
        guard let serializedData = try? request.serializedData() else {
            return resolve(false)
        }
        LndmobileGetInfo(serializedData, GetInfoCallback(resolve: resolve))
    }
    
    @objc
    func listPeers(_ resolve: @escaping RCTPromiseResolveBlock, reject: @escaping RCTPromiseResolveBlock) -> Void {
        print("ReactNativeLND", "listPeers");
        let request = Lnrpc_ListPeersRequest()
        
        guard let serializedData = try? request.serializedData() else {
            return resolve(false)
        }
        LndmobileListPeers(serializedData, ListPeersCallback(resolve: resolve))
    }
    
    @objc
    func listChannels(_ resolve: @escaping RCTPromiseResolveBlock, reject: @escaping RCTPromiseResolveBlock) -> Void {
        print("ReactNativeLND", "listChannels");
        let request = Lnrpc_ListChannelsRequest()
        
        guard let serializedData = try? request.serializedData() else {
            return resolve(false)
        }
        let callback = ListChannelsCallback(resolve: resolve)
        LndmobileListChannels(serializedData, callback)
    }
    
    @objc
    func pendingChannels(_ resolve: @escaping RCTPromiseResolveBlock, reject: @escaping RCTPromiseResolveBlock) -> Void {
        print("ReactNativeLND", "pendingChannels");
        let request = Lnrpc_PendingChannelsRequest()
        
        guard let serializedData = try? request.serializedData() else {
            return resolve(false)
        }
        LndmobilePendingChannels(serializedData, PendingChannelsCallback(resolve: resolve))
    }
    
    @objc
    func fundingStateStepVerify(_ chanIdHex: String, psbtHex: String, resolve: @escaping RCTPromiseResolveBlock, reject: @escaping RCTPromiseResolveBlock) {
        print("ReactNativeLND", "fundingStateStepVerify");
        print(chanIdHex)
        guard let chanIdHexData = stringToBytesToData(string: chanIdHex), let psbtData = stringToBytesToData(string: psbtHex) else {
            return resolve(false)
        }
        
        var funding = Lnrpc_FundingPsbtVerify()
        funding.pendingChanID = chanIdHexData
        funding.fundedPsbt = psbtData
        
        var request = Lnrpc_FundingTransitionMsg()
        request.psbtVerify = funding
        
        guard let serializedData = try? request.serializedData() else {
            return resolve(false)
        }
        LndmobileFundingStateStep(serializedData, FundingStateStepCallback(resolve: resolve))
    }
    
    @objc
    func fundingStateStepFinalize(_ chanIdHex: String, psbtHex: String,  resolve: @escaping RCTPromiseResolveBlock, reject: @escaping RCTPromiseResolveBlock) {
        print("ReactNativeLND", "fundingStateStepFinalize");
        
        guard let chanIdHexData = stringToBytesToData(string: chanIdHex), let psbtData = stringToBytesToData(string: psbtHex) else {
            return resolve(false)
        }
        
        var funding = Lnrpc_FundingPsbtFinalize()
        funding.pendingChanID = chanIdHexData
        funding.signedPsbt = psbtData
        
        var request = Lnrpc_FundingTransitionMsg()
        request.psbtFinalize = funding
        guard let serializedData = try? request.serializedData() else {
            return resolve(false)
        }
        LndmobileFundingStateStep(serializedData, FundingStateStepCallback(resolve: resolve))
    }
    
    @objc
    func fundingStateStepCancel(_ chanIdHex: String, resolve: @escaping RCTPromiseResolveBlock, reject: @escaping RCTPromiseResolveBlock) {
        print("ReactNativeLND", "fundingStateStep");
        
        guard let chanIdHexData = stringToBytesToData(string: chanIdHex) else {
            return resolve(false)

        }
        
        var fundingShimCancel = Lnrpc_FundingShimCancel()
        fundingShimCancel.pendingChanID = chanIdHexData
        
        var request = Lnrpc_FundingTransitionMsg()
        request.shimCancel = fundingShimCancel
        guard let serializedData = try? request.serializedData() else {
            return resolve(false)
        }
        LndmobileFundingStateStep(serializedData, FundingStateStepCallback(resolve: resolve))
    }
    
    @objc
    func openChannelPsbt(_ pubkeyHex: String, amountSats: NSNumber, privateChannel: Bool, resolve: @escaping RCTPromiseResolveBlock, reject: @escaping RCTPromiseResolveBlock) {
        print("ReactNativeLND", "openChannelPsbt");
        
        
        guard let nodePubKey = stringToBytesToData(string: pubkeyHex), let randomBytes = generateRandomBytes(), let pendingChanIDData =  base64BytesStringToData(string: randomBytes) else { return resolve(false) }
        
   

        var psbtShim = Lnrpc_PsbtShim()
        psbtShim.pendingChanID = pendingChanIDData
        var fundingShim = Lnrpc_FundingShim()
        fundingShim.psbtShim = psbtShim
        var request = Lnrpc_OpenChannelRequest()
        request.localFundingAmount = amountSats.int64Value
        request.nodePubkey = nodePubKey
        request.fundingShim = fundingShim
        request.private = privateChannel
        guard let serializedData = try? request.serializedData() else {
            return resolve(false)
        }
        
        let stream = OpenChannelRecvStream(resolve: resolve)
        LndmobileOpenChannel(serializedData,stream)
    }
    
    @objc
    func connectPeer(_ host: String, pubkeyHex: String, resolve: @escaping RCTPromiseResolveBlock, reject: @escaping RCTPromiseResolveBlock) {
        print("ReactNativeLND", "connectPeer");
        
        var address = Lnrpc_LightningAddress()
        address.host = host
        address.pubkey = pubkeyHex
        var request = Lnrpc_ConnectPeerRequest()
        request.addr = address
        guard let serializedData = try? request.serializedData() else {
            return resolve(false)
        }
        LndmobileConnectPeer(serializedData, EmptyResponseBooleanCallback(resolve: resolve))
    }
    
    @objc
    func walletBalance(_ resolve: @escaping RCTPromiseResolveBlock, reject: @escaping RCTPromiseResolveBlock) -> Void {
        print("ReactNativeLND", "walletBalance");
        let request = Lnrpc_WalletBalanceRequest()
        guard let serializedData = try? request.serializedData() else {
            return resolve(false)
        }
        LndmobileWalletBalance(serializedData, WalletBalanceCallback(resolve: resolve))
    }
    
    @objc
    func getTransactions(_ resolve: @escaping RCTPromiseResolveBlock, reject: @escaping RCTPromiseResolveBlock) -> Void {
        print("ReactNativeLND", "getTransactions");
        let request = Lnrpc_GetTransactionsRequest()
        guard let serializedData = try? request.serializedData() else {
            return resolve(false)
        }
        LndmobileGetTransactions(serializedData, GetTransactionsCallback(resolve: resolve))
    }
    
    @objc
    func channelBalance(_ resolve: @escaping RCTPromiseResolveBlock, reject: @escaping RCTPromiseResolveBlock) -> Void {
        print("ReactNativeLND", "channelBalance");
        let request = Lnrpc_ChannelBalanceRequest()
        guard let serializedData = try? request.serializedData() else {
            return resolve(false)
        }
        LndmobileChannelBalance(serializedData, ChannelBalanceCallback(resolve: resolve))
    }
    
    @objc
    func listInvoices(_ resolve: @escaping RCTPromiseResolveBlock, reject: @escaping RCTPromiseResolveBlock) -> Void {
        print("ReactNativeLND", "listInvoices");
        let request = Lnrpc_ListInvoiceRequest()
        guard let serializedData = try? request.serializedData() else {
            return resolve(false)
        }
        LndmobileListInvoices(serializedData, ListInvoicesCallback(resolve: resolve))
    }
    
    @objc
    func getLogs(_ resolve: @escaping RCTPromiseResolveBlock, reject: @escaping RCTPromiseResolveBlock) {
        let path = getLNDDocumentsDirectory().appendingPathComponent("logs/bitcoin/mainnet/lnd.log")
        guard let log = FileManager.default.contents(atPath: path.path), let logString = String(data: log, encoding: .utf8) else {
            return resolve(false)
        }
        resolve(logString)
    }
    
    @objc
    func sendPaymentSync(_ paymentRequest: String, amtSat: NSNumber, resolve: @escaping RCTPromiseResolveBlock, reject: @escaping RCTPromiseResolveBlock) {
        print("ReactNativeLND", "sendPaymentSync");
        var request = Lnrpc_SendRequest()
        request.paymentRequest = paymentRequest
        request.amt = amtSat.int64Value
        guard let serializedData = try? request.serializedData() else {
            return resolve(false)
        }
        LndmobileSendPaymentSync(serializedData, SendPaymentSyncCallback(resolve: resolve))
    }
    
    @objc
    func genSeed(_ resolve: @escaping RCTPromiseResolveBlock, reject: @escaping RCTPromiseResolveBlock) -> Void {
        print("ReactNativeLND", "genSeed");
        let request = Lnrpc_GenSeedRequest()
        guard let serializedData = try? request.serializedData() else {
            return resolve(false)
        }
        LndmobileGenSeed(serializedData
                         , GenSeedCallback(resolve: resolve))
    }
    
    @objc
    func addInvoice(_ sat: NSNumber, memo: String, expiry: NSNumber, resolve: @escaping RCTPromiseResolveBlock, reject: @escaping RCTPromiseResolveBlock) {
        print("ReactNativeLND", "addInvoice");
        var request = Lnrpc_Invoice()
        request.value = sat.int64Value
        request.memo = memo
        request.private = true
        request.expiry = expiry.int64Value
        guard let serializedData = try? request.serializedData() else {
            return resolve(false)
        }
        LndmobileAddInvoice(serializedData, AddInvoiceCallback(resolve: resolve))
    }
    
    @objc
    func queryRoutes(_ sourceHex: String, destHex: String, amtSat: NSNumber, resolve: @escaping RCTPromiseResolveBlock, reject: @escaping RCTPromiseResolveBlock) {
        print("ReactNativeLND", "queryRoutes");
        var request = Lnrpc_QueryRoutesRequest()
        request.amt = amtSat.int64Value
        request.useMissionControl = true
        request.pubKey = destHex
        request.sourcePubKey = sourceHex
        guard let serializedData = try? request.serializedData() else {
            return resolve(false)
        }
        LndmobileQueryRoutes(serializedData, QueryRoutesCallback(resolve: resolve))
    }
    
    @objc
    func decodePayReq(_ paymentRequest: String, resolve: @escaping RCTPromiseResolveBlock, reject: @escaping RCTPromiseResolveBlock) {
        print("ReactNativeLND", "decodePayReq");
        var request = Lnrpc_PayReqString()
        request.payReq = paymentRequest
        guard let serializedData = try? request.serializedData() else {
            return resolve(false)
        }
        LndmobileDecodePayReq(serializedData, DecodePayReqCallback(resolve: resolve))
    }
    
    @objc
    func sendAllCoins(_ address: String, resolve: @escaping RCTPromiseResolveBlock, reject: @escaping RCTPromiseResolveBlock) {
        print("ReactNativeLND", "sendAllCoins");
        var request = Lnrpc_SendCoinsRequest()
        request.addr = address
        request.sendAll = true
        guard let serializedData = try? request.serializedData() else {
            return resolve(false)
        }
        LndmobileSendCoins(serializedData, SendCoinsCallback(resolve: resolve))
    }
    
    @objc
    func listPayments(_ resolve: @escaping RCTPromiseResolveBlock, reject: @escaping RCTPromiseResolveBlock) {
        print("ReactNativeLND", "listPayments");
        let request = Lnrpc_ListPaymentsRequest()
        guard let serializedData = try? request.serializedData() else {
            return resolve(false)
        }
        LndmobileListPayments(serializedData, ListPaymentsCallback(resolve: resolve))
    }
    
    @objc func closeChannel(_ deliveryAddress: String, fundingTxidHex: String, outputIndex: NSNumber, force: Bool,  resolve: @escaping RCTPromiseResolveBlock, reject: @escaping RCTPromiseResolveBlock) {
        print("ReactNativeLND", "closeChannel");
        
        var channelPoint = Lnrpc_ChannelPoint()
        channelPoint.fundingTxidStr = fundingTxidHex
        channelPoint.outputIndex = outputIndex.uint32Value
        
        var request = Lnrpc_CloseChannelRequest()
        request.channelPoint = channelPoint
        request.deliveryAddress = deliveryAddress
        request.force = force
        
        guard let serializedData = try? request.serializedData() else {
            return resolve(false)
        }
        
        LndmobileCloseChannel(serializedData, CloseChannelCallback(resolve: resolve))
    }
    
    @objc
    func stopDaemon(_ resolve: @escaping RCTPromiseResolveBlock, reject: @escaping RCTPromiseResolveBlock) -> Void {
        print("ReactNativeLND", "stopDaemon");
        let request = Lnrpc_StopRequest()
        guard let serializedData = try? request.serializedData() else {
            return resolve(false)
        }
        LndmobileStopDaemon(serializedData, EmptyResponseBooleanCallback(resolve: resolve))
    }
    
    @objc
    static func requiresMainQueueSetup() -> Bool {
        return true
    }
    
}
