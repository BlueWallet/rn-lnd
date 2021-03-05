//
//  RnLndCallbacks.swift
//  rn-lnd
//
//  Created by Marcos Rodriguez on 1/4/21.
//

import Foundation

class StartCallback: NSObject, LndmobileCallbackProtocol {
    
    var resolve: RCTPromiseResolveBlock
    
    init(resolve: @escaping RCTPromiseResolveBlock) {
        self.resolve = resolve
    }
    
    func onError(_ p0: Error?) {
        print("ReactNativeLND", "start callback onError");
        resolve(false)
    }
    
    func onResponse(_ p0: Data?) {
        print("ReactNativeLND", "lnd started ===========================================================================")
        resolve(true)
    }
}

class StartCallback2: NSObject, LndmobileCallbackProtocol {
        
    func onError(_ p0: Error?) {
        print("ReactNativeLND", "StartCallback2 error");
    }
    
    func onResponse(_ p0: Data?) {
        print("ReactNativeLND", "lnd is ready ===========================================================================");
    }
}


class UnlockWalletCallback: NSObject, LndmobileCallbackProtocol {
    
    var resolve: RCTPromiseResolveBlock
    
    init(resolve: @escaping RCTPromiseResolveBlock) {
        self.resolve = resolve
    }
    
    func onError(_ p0: Error?) {
        print("ReactNativeLND", "UnlockWalletCallback error \(String(describing: p0?.localizedDescription))");
        resolve(false)
    }
    
    func onResponse(_ p0: Data?) {
        print("ReactNativeLND", "UnlockWalletCallback ok")
        guard let p0Data = p0, let response = try? Lnrpc_UnlockWalletResponse(serializedData: p0Data) else {
            return resolve(false)
        }
        print("ReactNativeLND resp: \(response.textFormatString())")
        resolve(true)
    }
}

class GenSeedCallback: NSObject, LndmobileCallbackProtocol {
    
    var resolve: RCTPromiseResolveBlock
    
    init(resolve: @escaping RCTPromiseResolveBlock) {
        self.resolve = resolve
    }
    
    func onError(_ p0: Error?) {
        print("ReactNativeLND", "GenSeedCallback error \(String(describing: p0?.localizedDescription))");
        resolve(false)
    }
    
    func onResponse(_ p0: Data?) {
        print("ReactNativeLND", "GenSeedCallback ok")
        guard let p0 = p0, let response = try? Lnrpc_GenSeedResponse(serializedData: p0) else {
            return resolve(false)
        }
        resolve(response.cipherSeedMnemonic.joined(separator: " "))
    }
}

class InitWalletCallback: NSObject, LndmobileCallbackProtocol {
    
    var resolve: RCTPromiseResolveBlock
    
    init(resolve: @escaping RCTPromiseResolveBlock) {
        self.resolve = resolve
    }
    
    func onError(_ p0: Error?) {
        print("ReactNativeLND", "InitWalletCallback error \(String(describing: p0?.localizedDescription))");
        resolve(false)
    }
    
    func onResponse(_ p0: Data?) {
        print("ReactNativeLND", "InitWalletCallback ok")
        guard let p0 = p0, let response = try? Lnrpc_InitWalletResponse(serializedData: p0), let responseJSON = try? response.jsonString() else {
            return resolve(false)
        }
        print("ReactNativeLND resp: \(responseJSON)")
        resolve(true)
    }
}

class SendToRouteCallback: NSObject, LndmobileCallbackProtocol {
    
    var resolve: RCTPromiseResolveBlock
    
    init(resolve: @escaping RCTPromiseResolveBlock) {
        self.resolve = resolve
    }
    
    func onError(_ p0: Error?) {
        print("ReactNativeLND", "SendToRouteCallback error \(String(describing: p0?.localizedDescription))");
        resolve(false)
    }
    
    func onResponse(_ p0: Data?) {
        print("ReactNativeLND", "SendToRouteCallback ok")
        guard let p0 = p0, let response = try? Lnrpc_HTLCAttempt(serializedData: p0), let jsonResponse = try? response.jsonString() else {    return resolve(false)
        }
        print("ReactNativeLND resp: \(jsonResponse)")
        resolve(jsonResponse)
    }
}

class GetInfoCallback: NSObject, LndmobileCallbackProtocol {
    
    var resolve: RCTPromiseResolveBlock
    
    init(resolve: @escaping RCTPromiseResolveBlock) {
        self.resolve = resolve
    }
    
    func onError(_ p0: Error?) {
        print("ReactNativeLND", "GetInfoCallback error \(String(describing: p0?.localizedDescription))");
        resolve(false)
    }
    
    func onResponse(_ p0: Data?) {
        print("ReactNativeLND", "GetInfoCallback ok")
        guard let p0 = p0, let response = try? Lnrpc_GetInfoResponse(serializedData: p0), let jsonResponse = try? response.jsonString() else {     return resolve(false)
        }
        print("ReactNativeLND resp: \(jsonResponse)")
        resolve(true)
    }
}

class GetTransactionsCallback: NSObject, LndmobileCallbackProtocol {
    
    var resolve: RCTPromiseResolveBlock
    
    init(resolve: @escaping RCTPromiseResolveBlock) {
        self.resolve = resolve
    }
    
    func onError(_ p0: Error?) {
        print("ReactNativeLND", "GetTransactionsCallback error \(String(describing: p0?.localizedDescription))")
        resolve(false)
    }
    
    func onResponse(_ p0: Data?) {
        print("ReactNativeLND", "GetTransactionsCallback ok")
        guard let p0 = p0, let response = try? Lnrpc_TransactionDetails(serializedData: p0), let jsonResponse = try? response.jsonString() else { return resolve(false)
            
        }
        print("ReactNativeLND resp: \(jsonResponse)")
        resolve(jsonResponse)
    }
}

class PendingChannelsCallback: NSObject, LndmobileCallbackProtocol {
    
    var resolve: RCTPromiseResolveBlock
    
    init(resolve: @escaping RCTPromiseResolveBlock) {
        self.resolve = resolve
    }
    
    func onError(_ p0: Error?) {
        print("ReactNativeLND", "PendingChannelsCallback error \(String(describing: p0?.localizedDescription))");
        return resolve(false)
    }
    
    func onResponse(_ p0: Data?) {
        print("ReactNativeLND", "PendingChannelsCallback ok")
        guard let p0 = p0, let response = try? Lnrpc_PendingChannelsResponse(serializedData: p0), let jsonResponse = try? response.jsonString() else {
            return resolve(false)
        }
        print("ReactNativeLND resp: \(jsonResponse)")
        resolve(jsonResponse)
    }
}

class ListChannelsCallback: NSObject, LndmobileCallbackProtocol {
    
    var resolve: RCTPromiseResolveBlock
    
    init(resolve: @escaping RCTPromiseResolveBlock) {
        self.resolve = resolve
    }
    
    func onError(_ p0: Error?) {
        print("ReactNativeLND", "ListChannelsCallback error \(String(describing: p0?.localizedDescription))");
        resolve(false)
    }
    
    func onResponse(_ p0: Data?) {
        print("ReactNativeLND", "ListChannelsCallback ok")
        guard let p0 = p0, let response = try? Lnrpc_ListChannelsResponse(serializedData: p0), let jsonResponse = try? response.jsonString() else {
            return resolve(false)
        }
        print("ReactNativeLND resp: \(jsonResponse)")
        resolve(jsonResponse)
    }
}

class ChannelBalanceCallback: NSObject, LndmobileCallbackProtocol {
    
    var resolve: RCTPromiseResolveBlock
    
    init(resolve: @escaping RCTPromiseResolveBlock) {
        self.resolve = resolve
    }
    
    func onError(_ p0: Error?) {
        print("ReactNativeLND", "ChannelBalanceCallback error \(String(describing: p0?.localizedDescription))")
        resolve(false)
    }
    
    func onResponse(_ p0: Data?) {
        print("ReactNativeLND", "ChannelBalanceCallback ok")
        guard let p0 = p0, let response = try? Lnrpc_ChannelBalanceResponse(serializedData: p0), let jsonResponse = try? response.jsonString() else { return resolve(false) }
        print("ReactNativeLND resp: \(jsonResponse)")
        resolve(true)
    }
}

class ListPeersCallback: NSObject, LndmobileCallbackProtocol {
    
    var resolve: RCTPromiseResolveBlock
    
    init(resolve: @escaping RCTPromiseResolveBlock) {
        self.resolve = resolve
    }
    
    func onError(_ p0: Error?) {
        print("ReactNativeLND", "ListPeersCallback error \(String(describing: p0?.localizedDescription))")
        resolve(false)
    }
    
    func onResponse(_ p0: Data?) {
        print("ReactNativeLND", "ListPeersCallback ok")
        guard let p0 = p0, let response = try? Lnrpc_ListPeersResponse(serializedData: p0), let jsonResponse = try? response.jsonString() else {   return resolve(false) }
        print("ReactNativeLND ListPeersCallback resp: \(jsonResponse)")
        resolve(jsonResponse)
    }
}

class WalletBalanceCallback: NSObject, LndmobileCallbackProtocol {
    
    var resolve: RCTPromiseResolveBlock
    
    init(resolve: @escaping RCTPromiseResolveBlock) {
        self.resolve = resolve
    }
    
    func onError(_ p0: Error?) {
        print("ReactNativeLND", "WalletBalanceCallback error \(String(describing: p0?.localizedDescription))")
        resolve(false)
    }
    
    func onResponse(_ p0: Data?) {
        print("ReactNativeLND", "WalletBalanceCallback ok")
        guard let p0 = p0, let response = try? Lnrpc_WalletBalanceResponse(serializedData: p0), let jsonResponse = try? response.jsonString() else { return resolve(false) }
        print("ReactNativeLND resp: \(jsonResponse)")
        resolve(jsonResponse)
    }
}

class ListPaymentsCallback: NSObject, LndmobileCallbackProtocol {
    
    var resolve: RCTPromiseResolveBlock
    
    init(resolve: @escaping RCTPromiseResolveBlock) {
        self.resolve = resolve
    }
    
    func onError(_ p0: Error?) {
        print("ReactNativeLND", "ListPaymentsCallback error \(String(describing: p0?.localizedDescription))")
        resolve(false)
    }
    
    func onResponse(_ p0: Data?) {
        print("ReactNativeLND", "ListPaymentsCallback ok")
        guard let p0 = p0, let response = try? Lnrpc_ListPaymentsResponse(serializedData: p0), let jsonResponse = try? response.jsonString() else { return resolve(false) }
        print("ReactNativeLND resp: \(jsonResponse)")
        resolve(jsonResponse)
    }
}

class SendCoinsCallback: NSObject, LndmobileCallbackProtocol {
    
    var resolve: RCTPromiseResolveBlock
    
    init(resolve: @escaping RCTPromiseResolveBlock) {
        self.resolve = resolve
    }
    
    func onError(_ p0: Error?) {
        print("ReactNativeLND", "SendCoinsCallback error \(String(describing: p0?.localizedDescription))");
        resolve(false)
    }
    
    func onResponse(_ p0: Data?) {
        print("ReactNativeLND", "SendCoinsCallback ok")
        guard let p0 = p0, let response = try? Lnrpc_SendCoinsResponse(serializedData: p0), let jsonResponse = try? response.jsonString() else { return resolve(false) }
        print("ReactNativeLND resp: \(jsonResponse)")
        resolve(jsonResponse)
    }
}

class ListInvoicesCallback: NSObject, LndmobileCallbackProtocol {
    
    var resolve: RCTPromiseResolveBlock
    
    init(resolve: @escaping RCTPromiseResolveBlock) {
        self.resolve = resolve
    }
    
    func onError(_ p0: Error?) {
        print("ReactNativeLND", "ListInvoicesCallback error \(String(describing: p0?.localizedDescription))")
        resolve(false)
    }
    
    func onResponse(_ p0: Data?) {
        print("ReactNativeLND", "ListInvoicesCallback ok")
        guard let p0 = p0, let response = try? Lnrpc_ListInvoiceResponse(serializedData: p0), let jsonResponse = try? response.jsonString() else { return resolve(false) }
        print("ReactNativeLND resp: \(jsonResponse)")
        resolve(jsonResponse)
    }
}

class QueryRoutesCallback: NSObject, LndmobileCallbackProtocol {
    
    var resolve: RCTPromiseResolveBlock
    
    init(resolve: @escaping RCTPromiseResolveBlock) {
        self.resolve = resolve
    }
    
    func onError(_ p0: Error?) {
        print("ReactNativeLND", "QueryRoutesCallback error \(String(describing: p0?.localizedDescription))")
        resolve(false)
    }
    
    func onResponse(_ p0: Data?) {
        print("ReactNativeLND", "QueryRoutesCallback ok")
        guard let p0 = p0, let response = try? Lnrpc_QueryRoutesResponse(serializedData: p0), let jsonResponse = try? response.jsonString() else { return resolve(false) }
        print("ReactNativeLND resp: \(jsonResponse)")
        resolve(jsonResponse)
    }
}

class DecodePayReqCallback: NSObject, LndmobileCallbackProtocol {
    
    var resolve: RCTPromiseResolveBlock
    
    init(resolve: @escaping RCTPromiseResolveBlock) {
        self.resolve = resolve
    }
    
    func onError(_ p0: Error?) {
        print("ReactNativeLND", "DecodePayReqCallback error \(String(describing: p0?.localizedDescription))")
        resolve(false)
    }
    
    func onResponse(_ p0: Data?) {
        print("ReactNativeLND", "DecodePayReqCallback ok")
        guard let p0 = p0, let response = try? Lnrpc_PayReq(serializedData: p0), let jsonResponse = try? response.jsonString() else { return resolve(false) }
        print("ReactNativeLND resp: \(jsonResponse)")
        resolve(jsonResponse)
    }
}



class AddInvoiceCallback: NSObject, LndmobileCallbackProtocol {
    
    var resolve: RCTPromiseResolveBlock
    
    init(resolve: @escaping RCTPromiseResolveBlock) {
        self.resolve = resolve
    }
    
    func onError(_ p0: Error?) {
        print("ReactNativeLND", "AddInvoiceCallback error \(String(describing: p0?.localizedDescription))");
        resolve(false)
    }
    
    func onResponse(_ p0: Data?) {
        print("ReactNativeLND", "AddInvoiceCallback ok")
        guard let p0 = p0, let response = try? Lnrpc_AddInvoiceResponse(serializedData: p0), let jsonResponse = try? response.jsonString() else { return resolve(false) }
        print("ReactNativeLND resp: \(jsonResponse)")
        resolve(jsonResponse)
    }
}

class SendPaymentSyncCallback: NSObject, LndmobileCallbackProtocol {
    
    var resolve: RCTPromiseResolveBlock
    
    init(resolve: @escaping RCTPromiseResolveBlock) {
        self.resolve = resolve
    }
    
    func onError(_ p0: Error?) {
        print("ReactNativeLND", "SendPaymentSyncCallback error \(String(describing: p0?.localizedDescription))")
        resolve(false)
    }
    
    func onResponse(_ p0: Data?) {
        print("ReactNativeLND", "SendPaymentSyncCallback ok")
        guard let p0 = p0, let response = try? Lnrpc_SendResponse(serializedData: p0), let jsonResponse = try? response.jsonString() else { return resolve(false)  }
        print("ReactNativeLND resp: \(jsonResponse)")
        resolve(true)
    }
}

class EmptyResponseBooleanCallback: NSObject, LndmobileCallbackProtocol {
    
    var resolve: RCTPromiseResolveBlock
    
    init(resolve: @escaping RCTPromiseResolveBlock) {
        self.resolve = resolve
    }
    
    func onError(_ p0: Error?) {
        print("ReactNativeLND", "callback onError");
        resolve(false)
    }
    
    func onResponse(_ p0: Data?) {
        print("ReactNativeLND", "callback success")
        resolve(true)
    }
}


class FundingStateStepCallback: NSObject, LndmobileCallbackProtocol {
    
    var resolve: RCTPromiseResolveBlock
    
    init(resolve: @escaping RCTPromiseResolveBlock) {
        self.resolve = resolve
    }
    
    func onError(_ p0: Error?) {
        print("ReactNativeLND", "FundingStateStepCallback error \(String(describing: p0?.localizedDescription))")
        resolve(false)
    }
    
    func onResponse(_ p0: Data?) {
        print("ReactNativeLND", "FundingStateStepCallback ok")
        guard let p0 = p0, let response = try? Lnrpc_FundingStateStepResp(serializedData: p0), let jsonResponse = try? response.jsonString() else { return resolve(false) }
        print("ReactNativeLND resp: \(jsonResponse)")
        resolve(jsonResponse)
    }
}


class OpenChannelCallback: NSObject, LndmobileCallbackProtocol {
    
    var resolve: RCTPromiseResolveBlock
    
    init(resolve: @escaping RCTPromiseResolveBlock) {
        self.resolve = resolve
    }
    
    func onResponse(_ p0: Data?) {
        
        guard let p0 = p0, let response = try? Lnrpc_OpenStatusUpdate(serializedData: p0), let jsonResponse = try? response.jsonString() else {
            return resolve(false)
        }
        resolve(jsonResponse)
    }
    
    func onError(_ p0: Error?) {
        if p0?.localizedDescription != "EOF" {
            print("OpenChannel error response - \(p0?.localizedDescription ?? "")")
            resolve(false)
        } else {
            resolve(false)
        }
    }
}

class CloseChannelCallback: NSObject, LndmobileCallbackProtocol {
    
    var resolve: RCTPromiseResolveBlock
    
    init(resolve: @escaping RCTPromiseResolveBlock) {
        self.resolve = resolve
    }
    
    func onError(_ p0: Error?) {
        print("ReactNativeLND", "CloseChannelRecvStream error \(String(describing: p0?.localizedDescription))");
        resolve(false)
    }
    
    func onResponse(_ p0: Data?) {
        print("ReactNativeLND", "CloseChannelRecvStream ok")
        guard let p0 = p0, let response = try? Lnrpc_CloseStatusUpdate(serializedData: p0), let jsonResponse = try? response.jsonString() else {  return resolve(false)
        }
        print("ReactNativeLND resp: \(jsonResponse)")
        resolve(jsonResponse)
    }
}

