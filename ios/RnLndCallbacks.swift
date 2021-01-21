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
        print("ReactNativeLND", "start callback onError")
        reject("start callback onError", p0?.localizedDescription, p0)
    }

    func onResponse(_ p0: Data?) {
        print("ReactNativeLND", "lnd started ===========================================================================")
        resolve(p0)
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

    func onResponse(_: Data?) {
        print("ReactNativeLND", "lnd is ready ===========================================================================")
        resolve(true)
    }
}

class UnlockWalletCallback: NSObject, LndmobileCallbackProtocol {
    var resolve: RCTPromiseResolveBlock
    var reject: RCTPromiseRejectBlock

    init(resolve: @escaping RCTPromiseResolveBlock, reject: @escaping RCTPromiseRejectBlock) {
        self.resolve = resolve
        self.reject = reject
    }

    func onError(_ p0: Error?) {
        print("ReactNativeLND", "UnlockWalletCallback error \(String(describing: p0?.localizedDescription))")
        reject("UnlockWalletCallback onError", p0?.localizedDescription, p0)
    }

    func onResponse(_ p0: Data?) {
        print("ReactNativeLND", "UnlockWalletCallback ok")
        guard let p0Data = p0, let response = try? Lnrpc_UnlockWalletResponse(serializedData: p0Data), let jsonResponse = try? response.jsonString() else {
            return reject("UnlockWalletResponse unable to generate string from response", nil, nil)
        }
        print("ReactNativeLND resp: \(jsonResponse)")
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
        print("ReactNativeLND", "GenSeedCallback error \(String(describing: p0?.localizedDescription))")
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
        print("ReactNativeLND", "InitWalletCallback error \(String(describing: p0?.localizedDescription))")
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

class GetInfoCallback: NSObject, LndmobileCallbackProtocol {
    var resolve: RCTPromiseResolveBlock
    var reject: RCTPromiseRejectBlock

    init(resolve: @escaping RCTPromiseResolveBlock, reject: @escaping RCTPromiseRejectBlock) {
        self.resolve = resolve
        self.reject = reject
    }

    func onError(_ p0: Error?) {
        print("ReactNativeLND", "GetInfoCallback error \(String(describing: p0?.localizedDescription))")
        reject("GetInfoCallback onError", p0?.localizedDescription, p0)
    }

    func onResponse(_ p0: Data?) {
        print("ReactNativeLND", "GetInfoCallback ok")
        guard let p0 = p0, let response = try? Lnrpc_GetInfoResponse(serializedData: p0), let jsonResponse = try? response.jsonString() else { return reject("GetInfoCallback unable to generate string from response", nil, nil)
        }
        print("ReactNativeLND resp: \(jsonResponse)")
        resolve(true)
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
        print("ReactNativeLND", "PendingChannelsCallback error \(String(describing: p0?.localizedDescription))")
        reject("PendingChannelsCallback onError", p0?.localizedDescription, p0)
    }

    func onResponse(_ p0: Data?) {
        print("ReactNativeLND", "PendingChannelsCallback ok")
        guard let p0 = p0, let response = try? Lnrpc_PendingChannelsResponse(serializedData: p0), let jsonResponse = try? response.jsonString() else {
            return reject("PendingChannelsCallback unable to generate string from response", nil, nil)
        }
        print("ReactNativeLND resp: \(jsonResponse)")
        resolve(true)
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
        print("ReactNativeLND", "ListChannelsCallback error \(String(describing: p0?.localizedDescription))")
        reject("ListChannelsCallback onError", p0?.localizedDescription, p0)
    }

    func onResponse(_ p0: Data?) {
        print("ReactNativeLND", "ListChannelsCallback ok")
        guard let p0 = p0, let response = try? Lnrpc_ListChannelsResponse(serializedData: p0), let jsonResponse = try? response.jsonString() else {
            return reject("ListChannelsCallback unable to generate string from response", nil, nil)
        }
        print("ReactNativeLND resp: \(jsonResponse)")
        resolve(true)
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
        print("ReactNativeLND", "ChannelBalanceCallback error \(String(describing: p0?.localizedDescription))")
        reject("ChannelBalanceCallback onError", p0?.localizedDescription, p0)
    }

    func onResponse(_ p0: Data?) {
        print("ReactNativeLND", "ChannelBalanceCallback ok")
        guard let p0 = p0, let response = try? Lnrpc_ChannelBalanceResponse(serializedData: p0), let jsonResponse = try? response.jsonString() else { return reject("ChannelBalanceCallback unable to generate string from response", nil, nil) }
        print("ReactNativeLND resp: \(jsonResponse)")
        resolve(true)
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
        print("ReactNativeLND", "WalletBalanceCallback error \(String(describing: p0?.localizedDescription))")
        reject("WalletBalanceCallback onError", p0?.localizedDescription, p0)
    }

    func onResponse(_ p0: Data?) {
        print("ReactNativeLND", "WalletBalanceCallback ok")
        guard let p0 = p0, let response = try? Lnrpc_WalletBalanceResponse(serializedData: p0), let jsonResponse = try? response.jsonString() else { return reject("WalletBalanceCallback unable to generate string from response", nil, nil) }
        print("ReactNativeLND resp: \(jsonResponse)")
        resolve(true)
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
        print("ReactNativeLND", "AddInvoiceCallback error \(String(describing: p0?.localizedDescription))")
        reject("AddInvoiceCallback onError", p0?.localizedDescription, p0)
    }

    func onResponse(_ p0: Data?) {
        print("ReactNativeLND", "AddInvoiceCallback ok")
        guard let p0 = p0, let response = try? Lnrpc_AddInvoiceResponse(serializedData: p0), let jsonResponse = try? response.jsonString() else { return reject("AddInvoiceCallback unable to generate string from response", nil, nil) }
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
        print("ReactNativeLND", "SendPaymentSyncCallback error \(String(describing: p0?.localizedDescription))")
        reject("SendPaymentSyncCallback onError", p0?.localizedDescription, p0)
    }

    func onResponse(_ p0: Data?) {
        print("ReactNativeLND", "SendPaymentSyncCallback ok")
        guard let p0 = p0, let response = try? Lnrpc_SendResponse(serializedData: p0), let jsonResponse = try? response.jsonString() else { return reject("SendPaymentsSyncCallback unable to generate string from response", nil, nil) }
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
        print("ReactNativeLND", "callback onError")
        reject("EmptyResponseBooleanCallback onError", p0?.localizedDescription, p0)
    }

    func onResponse(_: Data?) {
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
        print("ReactNativeLND", "FundingStateStepCallback error \(String(describing: p0?.localizedDescription))")
        reject("FundingStateStepCallback onError", p0?.localizedDescription, p0)
    }

    func onResponse(_ p0: Data?) {
        print("ReactNativeLND", "FundingStateStepCallback ok")
        guard let p0 = p0, let response = try? Lnrpc_FundingStateStepResp(serializedData: p0), let jsonResponse = try? response.jsonString() else { return reject("FundingStateCallback unable to generate string from response", nil, nil) }
        print("ReactNativeLND resp: \(jsonResponse)")
        resolve(true)
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
        print("ReactNativeLND", "OpenChannelRecvStream error \(String(describing: p0?.localizedDescription))")
        reject("OpenChannelRecvStream onError", p0?.localizedDescription, p0)
    }

    override func onResponse(_ p0: Data?) {
        print("ReactNativeLND", "OpenChannelRecvStream ok")
        guard let p0 = p0, let response = try? Lnrpc_OpenStatusUpdate(serializedData: p0), let jsonResponse = try? response.jsonString() else { return reject("OpenChannelRecvStream unable to generate string from response", nil, nil) }
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
        print("ReactNativeLND", "CloseChannelRecvStream error \(String(describing: p0?.localizedDescription))")
        reject("CloseChannelRecvStream onError", p0?.localizedDescription, p0)
    }

    override func onResponse(_ p0: Data?) {
        print("ReactNativeLND", "CloseChannelRecvStream ok")
        guard let p0 = p0, let response = try? Lnrpc_CloseStatusUpdate(serializedData: p0), let jsonResponse = try? response.jsonString() else { return reject("CloseChannelRecvStream unable to generate string from response", nil, nil)
        }
        print("ReactNativeLND resp: \(jsonResponse)")
        resolve(true)
    }
}
