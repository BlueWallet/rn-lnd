import Lndmobile

@objc(RnLnd)
class RnLnd: NSObject {
    
    @objc
    func start(_ lndArguments: String, resolve: RCTPromiseResolveBlock, reject: RCTPromiseRejectBlock) -> Void {
        print("ReactNativeLND", "start");
        resolve("")
    }
    
    @objc
    func unlockWallet(_ password: String, resolve: RCTPromiseResolveBlock, reject: RCTPromiseRejectBlock) -> Void {
        print("ReactNativeLND", "unlockWallet");
        resolve("")
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
    func genSeed(_ resolve: RCTPromiseResolveBlock, reject: RCTPromiseRejectBlock) -> Void {
        print("ReactNativeLND", "genSeed");
        resolve("")
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
    func stopDaemon(_ resolve: RCTPromiseResolveBlock, reject: RCTPromiseRejectBlock) -> Void {
        print("ReactNativeLND", "stopDaemon");
        resolve("")
    }
    
    
    @objc
    static func requiresMainQueueSetup() -> Bool {
        return true
    }
    
}
