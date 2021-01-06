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
        print("ReactNativeLND", "start callback onError 2");
    }

    func onResponse(_ p0: Data?) {
        print("ReactNativeLND", "lnd is ready ===========================================================================");
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
        guard let p0 = p0, let response = try? Lnrpc_GenSeedResponse(serializedData: p0) else { return resolve(false) }
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
        guard let p0 = p0, let response = try? Lnrpc_InitWalletResponse(serializedData: p0), let responseJSON = try? response.jsonString() else { return resolve(false) }
        print("ReactNativeLND resp: \(responseJSON)")
        resolve(true)
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
        guard let p0 = p0, let response = try? Lnrpc_GetInfoResponse(serializedData: p0), let jsonResponse = try? response.jsonString() else { return resolve(false) }
        print("ReactNativeLND resp: \(jsonResponse)")
        resolve(true)
    }
}

class PendingChannelsCallback: NSObject, LndmobileCallbackProtocol {
    
    var resolve: RCTPromiseResolveBlock
    
    init(resolve: @escaping RCTPromiseResolveBlock) {
        self.resolve = resolve
    }
    
    func onError(_ p0: Error?) {
        print("ReactNativeLND", "PendingChannelsCallback error \(String(describing: p0?.localizedDescription))");
        resolve(false)
    }

    func onResponse(_ p0: Data?) {
        print("ReactNativeLND", "PendingChannelsCallback ok")
        guard let p0 = p0, let response = try? Lnrpc_PendingChannelsResponse(serializedData: p0), let jsonResponse = try? response.jsonString() else { return resolve(false) }
        print("ReactNativeLND resp: \(jsonResponse)")
        resolve(true)
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
        guard let p0 = p0, let response = try? Lnrpc_ListChannelsResponse(serializedData: p0), let jsonResponse = try? response.jsonString() else { return resolve(false) }
        print("ReactNativeLND resp: \(jsonResponse)")
        resolve(true)
    }
}

class ChannelBalanceCallback: NSObject, LndmobileCallbackProtocol {
    
    var resolve: RCTPromiseResolveBlock
    
    init(resolve: @escaping RCTPromiseResolveBlock) {
        self.resolve = resolve
    }
    
    func onError(_ p0: Error?) {
        print("ReactNativeLND", "ChannelBalanceCallback error \(String(describing: p0?.localizedDescription))");
        resolve(false)
    }

    func onResponse(_ p0: Data?) {
        print("ReactNativeLND", "ChannelBalanceCallback ok")
        guard let p0 = p0, let response = try? Lnrpc_ChannelBalanceResponse(serializedData: p0), let jsonResponse = try? response.jsonString() else { return resolve(false) }
        print("ReactNativeLND resp: \(jsonResponse)")
        resolve(true)
    }
}

class WalletBalanceCallback: NSObject, LndmobileCallbackProtocol {
    
    var resolve: RCTPromiseResolveBlock
    
    init(resolve: @escaping RCTPromiseResolveBlock) {
        self.resolve = resolve
    }
    
    func onError(_ p0: Error?) {
        print("ReactNativeLND", "WalletBalanceCallback error \(String(describing: p0?.localizedDescription))");
        resolve(false)
    }

    func onResponse(_ p0: Data?) {
        print("ReactNativeLND", "WalletBalanceCallback ok")
        guard let p0 = p0, let response = try? Lnrpc_WalletBalanceResponse(serializedData: p0), let jsonResponse = try? response.jsonString() else { return resolve(false) }
        print("ReactNativeLND resp: \(jsonResponse)")
        resolve(true)
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
        resolve(true)
    }
}

