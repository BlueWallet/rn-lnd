//
//  RnLndCallbacks.swift
//  rn-lnd
//
//  Created by Marcos Rodriguez on 1/4/21.
//

import Foundation

class StartCallback: NSObject, LndmobileCallbackProtocol {
    
    var resolve: RCTPromiseResolveBlock
    var reject: RCTPromiseRejectBlock
    
    init(resolve: @escaping RCTPromiseResolveBlock, reject: @escaping RCTPromiseRejectBlock) {
        self.resolve = resolve
        self.reject = reject
    }
    
    func onError(_ p0: Error?) {
        print("ReactNativeLND", "start callback onError");
        reject("start callback onError", p0?.localizedDescription, p0)
    }
    
    func onResponse(_ p0: Data?) {
        print("ReactNativeLND", "lnd started ===========================================================================")
        resolve(true)
    }
}

class StartCallback2: NSObject, LndmobileCallbackProtocol {
    
    var resolve: RCTPromiseResolveBlock
    var reject: RCTPromiseRejectBlock
    
    init(resolve: @escaping RCTPromiseResolveBlock, reject: @escaping RCTPromiseRejectBlock) {
        self.resolve = resolve
        self.reject = reject
    }
    
    
    func onError(_ p0: Error?) {
        reject("start callback2 onError", p0?.localizedDescription, p0)
    }
    
    func onResponse(_ p0: Data?) {
        print("ReactNativeLND", "lnd is ready ===========================================================================");
        resolve(true)
    }
}


class UnlockWalletCallback: NSObject, LndmobileCallbackProtocol {
    
    var resolve: RCTPromiseResolveBlock
    var reject: RCTPromiseRejectBlock
    
    init(resolve: @escaping RCTPromiseResolveBlock,  reject: @escaping RCTPromiseRejectBlock) {
        self.resolve = resolve
        self.reject = reject
    }
    
    func onError(_ p0: Error?) {
        print("ReactNativeLND", "UnlockWalletCallback error \(String(describing: p0?.localizedDescription))");
        reject("UnlockWalletCallback onError", p0?.localizedDescription, p0)
    }
    
    func onResponse(_ p0: Data?) {
        print("ReactNativeLND", "UnlockWalletCallback ok")
        guard let p0Data = p0, let response = try? Lnrpc_UnlockWalletResponse(serializedData: p0Data) else {
            return reject("UnlockWalletResponse unable to generate string from response", nil, nil)
            
        }
        print("ReactNativeLND resp: \(response.textFormatString())")
        resolve(true)
    }
}

class GenSeedCallback: NSObject, LndmobileCallbackProtocol {
    
    var resolve: RCTPromiseResolveBlock
    var reject: RCTPromiseRejectBlock
    
    init(resolve: @escaping RCTPromiseResolveBlock, reject: @escaping RCTPromiseRejectBlock) {
        self.resolve = resolve
        self.reject = reject
    }
    
    func onError(_ p0: Error?) {
        print("ReactNativeLND", "GenSeedCallback error \(String(describing: p0?.localizedDescription))");
        reject("GenSeedCallback onError", p0?.localizedDescription, p0)
    }
    
    func onResponse(_ p0: Data?) {
        print("ReactNativeLND", "GenSeedCallback ok")
        guard let p0 = p0, let response = try? Lnrpc_GenSeedResponse(serializedData: p0) else {
            return reject("GenSeedCallback unable to generate string from response", nil, nil)
            
        }
        resolve(response.cipherSeedMnemonic.joined(separator: " "))
    }
}

class InitWalletCallback: NSObject, LndmobileCallbackProtocol {
    
    var resolve: RCTPromiseResolveBlock
    var reject: RCTPromiseRejectBlock
    
    init(resolve: @escaping RCTPromiseResolveBlock, reject: @escaping RCTPromiseRejectBlock) {
        self.resolve = resolve
        self.reject = reject
    }
    
    func onError(_ p0: Error?) {
        print("ReactNativeLND", "InitWalletCallback error \(String(describing: p0?.localizedDescription))");
        reject("InitWalletCallback onError", p0?.localizedDescription, p0)
    }
    
    func onResponse(_ p0: Data?) {
        print("ReactNativeLND", "InitWalletCallback ok")
        guard let p0 = p0, let response = try? Lnrpc_InitWalletResponse(serializedData: p0), let responseJSON = try? response.jsonString() else {
            return reject("InitWalletCallback unable to generate string from response", nil, nil)
        }
        print("ReactNativeLND resp: \(responseJSON)")
        resolve(true)
    }
}

class SendToRouteCallback: NSObject, LndmobileCallbackProtocol {
    
    var resolve: RCTPromiseResolveBlock
    var reject: RCTPromiseRejectBlock
    
    init(resolve: @escaping RCTPromiseResolveBlock, reject: @escaping RCTPromiseRejectBlock) {
        self.resolve = resolve
        self.reject = reject
    }
    
    func onError(_ p0: Error?) {
        print("ReactNativeLND", "SendToRouteCallback error \(String(describing: p0?.localizedDescription))");
        reject("SendToRouteCallback onError", p0?.localizedDescription, p0)
    }
    
    func onResponse(_ p0: Data?) {
        print("ReactNativeLND", "SendToRouteCallback ok")
        guard let p0 = p0, let response = try? Lnrpc_HTLCAttempt(serializedData: p0), let jsonResponse = try? response.jsonString() else {    return reject("SendToRouteCallback unable to generate string from response", nil, nil)
            
        }
        print("ReactNativeLND resp: \(jsonResponse)")
        resolve(jsonResponse)
    }
}

class GetInfoCallback: NSObject, LndmobileCallbackProtocol {
    
    var resolve: RCTPromiseResolveBlock
    var reject: RCTPromiseRejectBlock
    
    init(resolve: @escaping RCTPromiseResolveBlock, reject: @escaping RCTPromiseRejectBlock) {
        self.resolve = resolve
        self.reject = reject
    }
    
    func onError(_ p0: Error?) {
        print("ReactNativeLND", "GetInfoCallback error \(String(describing: p0?.localizedDescription))");
        reject("GetInfoCallback onError", p0?.localizedDescription, p0)
    }
    
    func onResponse(_ p0: Data?) {
        print("ReactNativeLND", "GetInfoCallback ok")
        guard let p0 = p0, let response = try? Lnrpc_GetInfoResponse(serializedData: p0), let jsonResponse = try? response.jsonString() else {    return reject("GetInfoCallback unable to generate string from response", nil, nil)
            
        }
        print("ReactNativeLND resp: \(jsonResponse)")
        resolve(true)
    }
}

class GetTransactionsCallback: NSObject, LndmobileCallbackProtocol {
    
    var resolve: RCTPromiseResolveBlock
    var reject: RCTPromiseRejectBlock
    
    init(resolve: @escaping RCTPromiseResolveBlock, reject: @escaping RCTPromiseRejectBlock) {
        self.resolve = resolve
        self.reject = reject
    }
    
    func onError(_ p0: Error?) {
        print("ReactNativeLND", "GetTransactionsCallback error \(String(describing: p0?.localizedDescription))");
        reject("GetTransactionsCallback onError", p0?.localizedDescription, p0)
    }
    
    func onResponse(_ p0: Data?) {
        print("ReactNativeLND", "GetTransactionsCallback ok")
        guard let p0 = p0, let response = try? Lnrpc_TransactionDetails(serializedData: p0), let jsonResponse = try? response.jsonString() else { return reject("GetInfoCallback unable to generate string from response", nil, nil)
            
        }
        print("ReactNativeLND resp: \(jsonResponse)")
        resolve(jsonResponse)
    }
}

class PendingChannelsCallback: NSObject, LndmobileCallbackProtocol {
    
    var resolve: RCTPromiseResolveBlock
    var reject: RCTPromiseRejectBlock
    
    init(resolve: @escaping RCTPromiseResolveBlock, reject: @escaping RCTPromiseRejectBlock) {
        self.resolve = resolve
        self.reject = reject
    }
    
    func onError(_ p0: Error?) {
        print("ReactNativeLND", "PendingChannelsCallback error \(String(describing: p0?.localizedDescription))");
        reject("PendingChannelsCallback onError", p0?.localizedDescription, p0)
    }
    
    func onResponse(_ p0: Data?) {
        print("ReactNativeLND", "PendingChannelsCallback ok")
        guard let p0 = p0, let response = try? Lnrpc_PendingChannelsResponse(serializedData: p0), let jsonResponse = try? response.jsonString() else {
            return reject("PendingChannelsCallback unable to generate string from response", nil, nil)
        }
        print("ReactNativeLND resp: \(jsonResponse)")
        resolve(jsonResponse)
    }
}

class ListChannelsCallback: NSObject, LndmobileCallbackProtocol {
    
    var resolve: RCTPromiseResolveBlock
    var reject: RCTPromiseRejectBlock
    
    init(resolve: @escaping RCTPromiseResolveBlock, reject: @escaping RCTPromiseRejectBlock) {
        self.resolve = resolve
        self.reject = reject
    }
    
    func onError(_ p0: Error?) {
        print("ReactNativeLND", "ListChannelsCallback error \(String(describing: p0?.localizedDescription))");
        reject("ListChannelsCallback onError", p0?.localizedDescription, p0)
    }
    
    func onResponse(_ p0: Data?) {
        print("ReactNativeLND", "ListChannelsCallback ok")
        guard let p0 = p0, let response = try? Lnrpc_ListChannelsResponse(serializedData: p0), let jsonResponse = try? response.jsonString() else {
            return reject("ListChannelsCallback unable to generate string from response", nil, nil)
        }
        print("ReactNativeLND resp: \(jsonResponse)")
        resolve(jsonResponse)
    }
}

class ChannelBalanceCallback: NSObject, LndmobileCallbackProtocol {
    
    var resolve: RCTPromiseResolveBlock
    var reject: RCTPromiseRejectBlock
    
    init(resolve: @escaping RCTPromiseResolveBlock, reject: @escaping RCTPromiseRejectBlock) {
        self.resolve = resolve
        self.reject = reject
    }
    
    func onError(_ p0: Error?) {
        print("ReactNativeLND", "ChannelBalanceCallback error \(String(describing: p0?.localizedDescription))");
        reject("ChannelBalanceCallback onError", p0?.localizedDescription, p0)
    }
    
    func onResponse(_ p0: Data?) {
        print("ReactNativeLND", "ChannelBalanceCallback ok")
        guard let p0 = p0, let response = try? Lnrpc_ChannelBalanceResponse(serializedData: p0), let jsonResponse = try? response.jsonString() else { return reject("ChannelBalanceCallback unable to generate string from response", nil, nil) }
        print("ReactNativeLND resp: \(jsonResponse)")
        resolve(true)
    }
}

class ListPeersCallback: NSObject, LndmobileCallbackProtocol {
    
    var resolve: RCTPromiseResolveBlock
    var reject: RCTPromiseRejectBlock
    
    init(resolve: @escaping RCTPromiseResolveBlock, reject: @escaping RCTPromiseRejectBlock) {
        self.resolve = resolve
        self.reject = reject
    }
    
    func onError(_ p0: Error?) {
        print("ReactNativeLND", "ListPeersCallback error \(String(describing: p0?.localizedDescription))");
        reject("ListPeersCallback onError", p0?.localizedDescription, p0)
    }
    
    func onResponse(_ p0: Data?) {
        print("ReactNativeLND", "ListPeersCallback ok")
        guard let p0 = p0, let response = try? Lnrpc_ListPeersResponse(serializedData: p0), let jsonResponse = try? response.jsonString() else { return reject("ListPeersCallback unable to generate string from response", nil, nil) }
        print("ReactNativeLND ListPeersCallback resp: \(jsonResponse)")
        resolve(jsonResponse)
    }
}

class WalletBalanceCallback: NSObject, LndmobileCallbackProtocol {
    
    var resolve: RCTPromiseResolveBlock
    var reject: RCTPromiseRejectBlock
    
    init(resolve: @escaping RCTPromiseResolveBlock, reject: @escaping RCTPromiseRejectBlock) {
        self.resolve = resolve
        self.reject = reject
    }
    
    func onError(_ p0: Error?) {
        print("ReactNativeLND", "WalletBalanceCallback error \(String(describing: p0?.localizedDescription))");
        reject("WalletBalanceCallback onError", p0?.localizedDescription, p0)
    }
    
    func onResponse(_ p0: Data?) {
        print("ReactNativeLND", "WalletBalanceCallback ok")
        guard let p0 = p0, let response = try? Lnrpc_WalletBalanceResponse(serializedData: p0), let jsonResponse = try? response.jsonString() else { return reject("WalletBalanceCallback unable to generate string from response", nil, nil) }
        print("ReactNativeLND resp: \(jsonResponse)")
        resolve(jsonResponse)
    }
}

class ListPaymentsCallback: NSObject, LndmobileCallbackProtocol {
    
    var resolve: RCTPromiseResolveBlock
    var reject: RCTPromiseRejectBlock
    
    init(resolve: @escaping RCTPromiseResolveBlock, reject: @escaping RCTPromiseRejectBlock) {
        self.resolve = resolve
        self.reject = reject
    }
    
    func onError(_ p0: Error?) {
        print("ReactNativeLND", "ListPaymentsCallback error \(String(describing: p0?.localizedDescription))");
        reject("ListPaymentsCallback onError", p0?.localizedDescription, p0)
    }
    
    func onResponse(_ p0: Data?) {
        print("ReactNativeLND", "ListPaymentsCallback ok")
        guard let p0 = p0, let response = try? Lnrpc_ListPaymentsResponse(serializedData: p0), let jsonResponse = try? response.jsonString() else { return reject("ListPaymentsCallback unable to generate string from response", nil, nil) }
        print("ReactNativeLND resp: \(jsonResponse)")
        resolve(jsonResponse)
    }
}

class SendCoinsCallback: NSObject, LndmobileCallbackProtocol {
    
    var resolve: RCTPromiseResolveBlock
    var reject: RCTPromiseRejectBlock
    
    init(resolve: @escaping RCTPromiseResolveBlock, reject: @escaping RCTPromiseRejectBlock) {
        self.resolve = resolve
        self.reject = reject
    }
    
    func onError(_ p0: Error?) {
        print("ReactNativeLND", "SendCoinsCallback error \(String(describing: p0?.localizedDescription))");
        reject("SendCoinsCallback onError", p0?.localizedDescription, p0)
    }
    
    func onResponse(_ p0: Data?) {
        print("ReactNativeLND", "SendCoinsCallback ok")
        guard let p0 = p0, let response = try? Lnrpc_SendCoinsResponse(serializedData: p0), let jsonResponse = try? response.jsonString() else { return reject("SendCoinsCallback unable to generate string from response", nil, nil) }
        print("ReactNativeLND resp: \(jsonResponse)")
        resolve(jsonResponse)
    }
}

class ListInvoicesCallback: NSObject, LndmobileCallbackProtocol {
    
    var resolve: RCTPromiseResolveBlock
    var reject: RCTPromiseRejectBlock
    
    init(resolve: @escaping RCTPromiseResolveBlock, reject: @escaping RCTPromiseRejectBlock) {
        self.resolve = resolve
        self.reject = reject
    }
    
    func onError(_ p0: Error?) {
        print("ReactNativeLND", "ListInvoicesCallback error \(String(describing: p0?.localizedDescription))");
        reject("ListInvoicesCallback onError", p0?.localizedDescription, p0)
    }
    
    func onResponse(_ p0: Data?) {
        print("ReactNativeLND", "ListInvoicesCallback ok")
        guard let p0 = p0, let response = try? Lnrpc_ListInvoiceResponse(serializedData: p0), let jsonResponse = try? response.jsonString() else { return reject("ListInvoicesCallback unable to generate string from response", nil, nil) }
        print("ReactNativeLND resp: \(jsonResponse)")
        resolve(jsonResponse)
    }
}

class QueryRoutesCallback: NSObject, LndmobileCallbackProtocol {
    
    var resolve: RCTPromiseResolveBlock
    var reject: RCTPromiseRejectBlock
    
    init(resolve: @escaping RCTPromiseResolveBlock, reject: @escaping RCTPromiseRejectBlock) {
        self.resolve = resolve
        self.reject = reject
    }
    
    func onError(_ p0: Error?) {
        print("ReactNativeLND", "QueryRoutesCallback error \(String(describing: p0?.localizedDescription))");
        reject("QueryRoutesCallback onError", p0?.localizedDescription, p0)
    }
    
    func onResponse(_ p0: Data?) {
        print("ReactNativeLND", "QueryRoutesCallback ok")
        guard let p0 = p0, let response = try? Lnrpc_QueryRoutesResponse(serializedData: p0), let jsonResponse = try? response.jsonString() else { return reject("QueryRoutesCallback unable to generate string from response", nil, nil) }
        print("ReactNativeLND resp: \(jsonResponse)")
        resolve(jsonResponse)
    }
}

class DecodePayReqCallback: NSObject, LndmobileCallbackProtocol {
    
    var resolve: RCTPromiseResolveBlock
    var reject: RCTPromiseRejectBlock
    
    init(resolve: @escaping RCTPromiseResolveBlock, reject: @escaping RCTPromiseRejectBlock) {
        self.resolve = resolve
        self.reject = reject
    }
    
    func onError(_ p0: Error?) {
        print("ReactNativeLND", "DecodePayReqCallback error \(String(describing: p0?.localizedDescription))");
        reject("DecodePayReqCallback onError", p0?.localizedDescription, p0)
    }
    
    func onResponse(_ p0: Data?) {
        print("ReactNativeLND", "DecodePayReqCallback ok")
        guard let p0 = p0, let response = try? Lnrpc_PayReq(serializedData: p0), let jsonResponse = try? response.jsonString() else { return reject("DecodePayReqCallback unable to generate string from response", nil, nil) }
        print("ReactNativeLND resp: \(jsonResponse)")
        resolve(jsonResponse)
    }
}



class AddInvoiceCallback: NSObject, LndmobileCallbackProtocol {
    
    var resolve: RCTPromiseResolveBlock
    var reject: RCTPromiseRejectBlock
    
    init(resolve: @escaping RCTPromiseResolveBlock, reject: @escaping RCTPromiseRejectBlock) {
        self.resolve = resolve
        self.reject = reject
    }
    
    func onError(_ p0: Error?) {
        print("ReactNativeLND", "AddInvoiceCallback error \(String(describing: p0?.localizedDescription))");
        reject("AddInvoiceCallback onError", p0?.localizedDescription, p0)
    }
    
    func onResponse(_ p0: Data?) {
        print("ReactNativeLND", "AddInvoiceCallback ok")
        guard let p0 = p0, let response = try? Lnrpc_AddInvoiceResponse(serializedData: p0), let jsonResponse = try? response.jsonString() else { return reject("AddInvoiceCallback unable to generate string from response", nil, nil)  }
        print("ReactNativeLND resp: \(jsonResponse)")
        resolve(true)
    }
}

class SendPaymentSyncCallback: NSObject, LndmobileCallbackProtocol {
    
    var resolve: RCTPromiseResolveBlock
    var reject: RCTPromiseRejectBlock
    
    init(resolve: @escaping RCTPromiseResolveBlock, reject: @escaping RCTPromiseRejectBlock) {
        self.resolve = resolve
        self.reject = reject
    }
    
    func onError(_ p0: Error?) {
        print("ReactNativeLND", "SendPaymentSyncCallback error \(String(describing: p0?.localizedDescription))");
        reject("SendPaymentSyncCallback onError", p0?.localizedDescription, p0)
    }
    
    func onResponse(_ p0: Data?) {
        print("ReactNativeLND", "SendPaymentSyncCallback ok")
        guard let p0 = p0, let response = try? Lnrpc_SendResponse(serializedData: p0), let jsonResponse = try? response.jsonString() else { return reject("SendPaymentsSyncCallback unable to generate string from response", nil, nil)  }
        print("ReactNativeLND resp: \(jsonResponse)")
        resolve(true)
    }
}

class EmptyResponseBooleanCallback: NSObject, LndmobileCallbackProtocol {
    
    var resolve: RCTPromiseResolveBlock
    var reject: RCTPromiseRejectBlock
    
    init(resolve: @escaping RCTPromiseResolveBlock, reject: @escaping RCTPromiseRejectBlock) {
        self.resolve = resolve
        self.reject = reject
    }
    
    func onError(_ p0: Error?) {
        print("ReactNativeLND", "callback onError");
        reject("EmptyResponseBooleanCallback onError", p0?.localizedDescription, p0)
    }
    
    func onResponse(_ p0: Data?) {
        print("ReactNativeLND", "callback success")
        resolve(true)
    }
}


class FundingStateStepCallback: NSObject, LndmobileCallbackProtocol {
    
    var resolve: RCTPromiseResolveBlock
    var reject: RCTPromiseRejectBlock
    
    init(resolve: @escaping RCTPromiseResolveBlock, reject: @escaping RCTPromiseRejectBlock) {
        self.resolve = resolve
        self.reject = reject
    }
    
    func onError(_ p0: Error?) {
        print("ReactNativeLND", "FundingStateStepCallback error \(String(describing: p0?.localizedDescription))");
        reject("FundingStateStepCallback onError", p0?.localizedDescription, p0)
    }
    
    func onResponse(_ p0: Data?) {
        print("ReactNativeLND", "FundingStateStepCallback ok")
        guard let p0 = p0, let response = try? Lnrpc_FundingStateStepResp(serializedData: p0), let jsonResponse = try? response.jsonString() else { return resolve(true) }
        print("ReactNativeLND resp: \(jsonResponse)")
        resolve(jsonResponse)
    }
}

class OpenChannelRecvStream: LndmobileRecvStream {
    
    var resolve: RCTPromiseResolveBlock
    var reject: RCTPromiseRejectBlock
    
    init(resolve: @escaping RCTPromiseResolveBlock, reject: @escaping RCTPromiseRejectBlock) {
        self.resolve = resolve
        self.reject = reject
        super.init()
    }
    
    override func onError(_ p0: Error?) {
        print("ReactNativeLND", "OpenChannelRecvStream error \(String(describing: p0?.localizedDescription))");
        reject("OpenChannelRecvStream onError", p0?.localizedDescription, p0)
    }
    
    override func onResponse(_ p0: Data?) {
        print("ReactNativeLND", "OpenChannelRecvStream ok")
        guard let p0 = p0, let response = try? Lnrpc_OpenStatusUpdate(serializedData: p0), let jsonResponse = try? response.jsonString() else { return reject("OpenChannelRecvStream unable to generate string from response", nil, nil)  }
        print("ReactNativeLND resp: \(jsonResponse)")
        resolve(true)
    }
}

class CloseChannelRecvStream: LndmobileRecvStream {
    
    var resolve: RCTPromiseResolveBlock
    var reject: RCTPromiseRejectBlock
    
    init(resolve: @escaping RCTPromiseResolveBlock, reject: @escaping RCTPromiseRejectBlock) {
        self.resolve = resolve
        self.reject = reject
        super.init()
    }
    
    override func onError(_ p0: Error?) {
        print("ReactNativeLND", "CloseChannelRecvStream error \(String(describing: p0?.localizedDescription))");
        reject("CloseChannelRecvStream onError", p0?.localizedDescription, p0)
    }
    
    override func onResponse(_ p0: Data?) {
        print("ReactNativeLND", "CloseChannelRecvStream ok")
        guard let p0 = p0, let response = try? Lnrpc_CloseStatusUpdate(serializedData: p0), let jsonResponse = try? response.jsonString() else { return resolve(true)
        }
        print("ReactNativeLND resp: \(jsonResponse)")
        resolve(jsonResponse)
    }
}

