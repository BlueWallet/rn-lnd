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
        guard let p0 = p0, let response = try? Lnrpc_InitWalletResponse(serializedData: p0) else { return resolve(false) }
        print("ReactNativeLND resp: \(response.textFormatString())")
        resolve(true)
    }
}
