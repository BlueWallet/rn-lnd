// RnLnd.m
#import <React/RCTBridgeModule.h>

@interface RCT_EXTERN_MODULE(RnLnd, NSObject)

RCT_EXTERN_METHOD(start:(NSString *)lndArguments resolve:(RCTPromiseResolveBlock)resolve reject:(RCTPromiseRejectBlock)reject)
RCT_EXTERN_METHOD(unlockWallet:(NSString *)password resolve:(RCTPromiseResolveBlock)resolve reject:(RCTPromiseRejectBlock)reject)
RCT_EXTERN_METHOD(initWallet:(NSString *)password mnemonics:(NSString *)mnemonics resolve:(RCTPromiseResolveBlock)resolve reject:(RCTPromiseRejectBlock)reject)
RCT_EXTERN_METHOD(getInfo:(RCTPromiseResolveBlock)resolve reject:(RCTPromiseRejectBlock)reject)
RCT_EXTERN_METHOD(listChannels:(RCTPromiseResolveBlock)resolve reject:(RCTPromiseRejectBlock)reject)
RCT_EXTERN_METHOD(pendingChannels:(RCTPromiseResolveBlock)resolve reject:(RCTPromiseRejectBlock)reject)
RCT_EXTERN_METHOD(fundingStateStepVerify:(NSString *)chanIdHex psbtHex:(NSString *)psbtHex resolve:(RCTPromiseResolveBlock)resolve reject:(RCTPromiseRejectBlock)reject)
RCT_EXTERN_METHOD(fundingStateStepFinalize:(NSString *)chanIdHex psbtHex:(NSString *)psbtHex resolve:(RCTPromiseResolveBlock)resolve reject:(RCTPromiseRejectBlock)reject)
RCT_EXTERN_METHOD(openChannelPsbt:(NSString *)pubkeyHex amountSats:(nonull NSNumber *)amountSats privateChannel:(BOOL)privateChannel resolve:(RCTPromiseResolveBlock)resolve reject:(RCTPromiseRejectBlock)reject)
RCT_EXTERN_METHOD(connectPeer:(NSString *)host pubkeyHex:(NSString *)pubkeyHex resolve:(RCTPromiseResolveBlock)resolve reject:(RCTPromiseRejectBlock)reject)
RCT_EXTERN_METHOD(walletBalance:(RCTPromiseResolveBlock)resolve reject:(RCTPromiseRejectBlock)reject)
RCT_EXTERN_METHOD(channelBalance:(RCTPromiseResolveBlock)resolve reject:(RCTPromiseRejectBlock)reject)
RCT_EXTERN_METHOD(sendPaymentSync:(NSString *)paymentRequest resolve:(RCTPromiseResolveBlock)resolve reject:(RCTPromiseRejectBlock)reject)
RCT_EXTERN_METHOD(sendToRouteSync:(NSString *)paymentHashHex resolve:(RCTPromiseResolveBlock)resolve reject:(RCTPromiseRejectBlock)reject)
RCT_EXTERN_METHOD(genSeed:(RCTPromiseResolveBlock)resolve reject:(RCTPromiseRejectBlock)reject)
RCT_EXTERN_METHOD(addInvoice:(nonull NSNumber *)sat memo:(NSString *)memo expiry:(nonull NSNumber *)expiry resolve:(RCTPromiseResolveBlock)resolve reject:(RCTPromiseRejectBlock)reject)
RCT_EXTERN_METHOD(closeChannel:(NSString *)deliveryAddress fundingTxidHex:(NSString *)fundingTxidHex outputIndex:(nonull NSNumber *)outputIndex force:(BOOL)force callback:(RCTResponseSenderBlock)callback)
RCT_EXTERN_METHOD(stopDaemon:(RCTPromiseResolveBlock)resolve reject:(RCTPromiseRejectBlock)reject)
RCT_EXTERN_METHOD(listPeers:(RCTPromiseResolveBlock)resolve reject:(RCTPromiseRejectBlock)reject)
RCT_EXTERN_METHOD(listInvoices:(RCTPromiseResolveBlock)resolve reject:(RCTPromiseRejectBlock)reject)
RCT_EXTERN_METHOD(getLndDir:(RCTPromiseResolveBlock)resolve reject:(RCTPromiseRejectBlock)reject)
RCT_EXTERN_METHOD(getLogs:(RCTPromiseResolveBlock)resolve reject:(RCTPromiseRejectBlock)reject)
RCT_EXTERN_METHOD(wipeLndDir:(RCTPromiseResolveBlock)resolve reject:(RCTPromiseRejectBlock)reject)
RCT_EXTERN_METHOD(getTransactions:(RCTPromiseResolveBlock)resolve reject:(RCTPromiseRejectBlock)reject)
RCT_EXTERN_METHOD(queryRoutes:(NSString *)sourceHex
                  destHex:(NSString *)destHex
                  amtSat:(nonull NSNumber *)amtSat
                  resolve:(RCTPromiseResolveBlock)resolve reject:(RCTPromiseRejectBlock)reject)
RCT_EXTERN_METHOD(listPayments:(RCTPromiseResolveBlock)resolve reject:(RCTPromiseRejectBlock)reject)
RCT_EXTERN_METHOD(decodePayReq:(NSString *)paymentRequest resolve:(RCTPromiseResolveBlock)resolve reject:(RCTPromiseRejectBlock)reject)
RCT_EXTERN_METHOD(sendAllCoins:(NSString *)address resolve:(RCTPromiseResolveBlock)resolve reject:(RCTPromiseRejectBlock)reject)
RCT_EXTERN_METHOD(fundingStateStepCancel:(NSString *)chanIdHex resolve:(RCTPromiseResolveBlock)resolve reject:(RCTPromiseRejectBlock)reject)
RCT_EXTERN_METHOD(fundingStateStepCancel:(NSString *)paymentHashHex
                  paymentAddrHex:(NSString *)paymentAddrHex
                  queryRoutesJsonString:(NSString *)queryRoutesJsonString
                  resolve:(RCTPromiseResolveBlock)resolve reject:(RCTPromiseRejectBlock)reject)

@end
