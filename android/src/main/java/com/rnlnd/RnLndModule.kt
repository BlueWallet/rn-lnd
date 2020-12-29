package com.rnlnd

import android.util.Log
import androidx.core.content.ContextCompat
import com.facebook.react.bridge.Promise
import com.facebook.react.bridge.ReactApplicationContext
import com.facebook.react.bridge.ReactContextBaseJavaModule
import com.facebook.react.bridge.ReactMethod
import com.google.protobuf.ByteString
import lndmobile.Lndmobile
import kotlin.random.Random
import com.rnlnd.helpers.*;
import lndmobile.SendStream


class RnLndModule(reactContext: ReactApplicationContext) : ReactContextBaseJavaModule(reactContext) {
    override fun getName(): String {
        return "RnLnd"
    }

    // Example method
    // See https://reactnative.dev/docs/native-modules-android
    @ReactMethod
    fun multiply(a: Int, b: Int, promise: Promise) {
      promise.resolve(666);
    }

  @ReactMethod
  fun start(lndArguments: String, promise: Promise) {
    val dir = ContextCompat.getExternalFilesDirs(reactApplicationContext.applicationContext, null)[0];
    Log.v("ReactNativeLND", "starting LND in " + dir);
    var argumentsToUse = "--sync-freelist --tlsdisableautofill  --maxpendingchannels=10 --nobootstrap " + //
      "--chan-status-sample-interval=5s --minchansize=1000000 --ignore-historical-gossip-filters --rejecthtlc " +
      "--bitcoin.active --bitcoin.mainnet --bitcoin.defaultchanconfs=0 --routing.assumechanvalid " +
      "--protocol.wumbo-channels --rpclisten=127.0.0.1 --norest --nolisten " +
      "--maxbackoff=2s --enable-upfront-shutdown " + // --chan-enable-timeout=10s  --connectiontimeout=15s
      "--bitcoin.node=neutrino --neutrino.connect=btcd-mainnet.lightning.computer --neutrino.maxpeers=100 " +
      "--neutrino.assertfilterheader=660000:08312375fabc082b17fa8ee88443feb350c19a34bb7483f94f7478fa4ad33032 " +
      "--neutrino.feeurl=https://nodes.lightning.computer/fees/v1/btc-fee-estimates.json  --numgraphsyncpeers=0 " +
      "--bitcoin.basefee=100000 --bitcoin.feerate=10000 "; // --chan-disable-timeout=60s

    if (lndArguments != "") {
      argumentsToUse = lndArguments;
    }
    Lndmobile.start(argumentsToUse + " --lnddir=" + dir + "/.lnd", StartCallback(promise), StartCallback2());
  }

  @ReactMethod
  fun unlockWallet(password: String, promise: Promise) {
    Log.v("ReactNativeLND", "unlocking wallet with password -->" + password + "<--");

    val pw: ByteString = ByteString.copyFromUtf8(password);
    val reqUnlock: lnrpc.Walletunlocker.UnlockWalletRequest = lnrpc.Walletunlocker
      .UnlockWalletRequest
      .newBuilder()
      .setWalletPassword(pw)
      .build();
    Lndmobile.unlockWallet(reqUnlock.toByteArray(), UnlockWalletCallback(promise));
  }

  @ReactMethod
  fun initWallet(password: String, mnemonics: String, promise: Promise) {
    Log.v("ReactNativeLND", "init wallet "  + password + " " + mnemonics);
    val pw: ByteString = ByteString.copyFromUtf8(password);
    val cipherSeed = mnemonics.split(" ").toMutableList();
    val req: lnrpc.Walletunlocker.InitWalletRequest = lnrpc.Walletunlocker
      .InitWalletRequest
      .newBuilder()
      .setWalletPassword(pw)
      .addAllCipherSeedMnemonic(cipherSeed)
      .build();

    Lndmobile.initWallet(req.toByteArray(), InitWalletCallback(promise));
  }

  @ReactMethod
  fun getInfo(promise: Promise) {
    Log.v("ReactNativeLND", "getInfo");
    val req: lnrpc.Rpc.GetInfoRequest = lnrpc.Rpc.GetInfoRequest.newBuilder().build();
    Lndmobile.getInfo(req.toByteArray(), GetInfoCallback(promise));
  }

  @ReactMethod
  fun listChannels(promise: Promise) {
    Log.v("ReactNativeLND", "listChannels");
    val req: lnrpc.Rpc.ListChannelsRequest = lnrpc.Rpc.ListChannelsRequest.newBuilder().build();
    Lndmobile.listChannels(req.toByteArray(), ListChannelsCallback(promise));
  }

  @ReactMethod
  fun pendingChannels(promise: Promise) {
    Log.v("ReactNativeLND", "pendingChannels");
    val req: lnrpc.Rpc.PendingChannelsRequest = lnrpc.Rpc.PendingChannelsRequest.newBuilder().build();
    Lndmobile.pendingChannels(req.toByteArray(), PendingChannelsCallback(promise))
  }

  @ReactMethod
  fun fundingStateStepVerify(chanIdHex: String, psbtHex: String, promise: Promise) {
    Log.v("ReactNativeLND", "fundingStateStep verifying channel " + chanIdHex + " with psbt " + psbtHex);

    val chanId : ByteString = ByteString.copyFrom(hexStringToByteArray(chanIdHex));
    val psbt : ByteString = ByteString.copyFrom(hexStringToByteArray(psbtHex));

    val funding: lnrpc.Rpc.FundingPsbtVerify = lnrpc.Rpc.FundingPsbtVerify.newBuilder()
      .setPendingChanId(chanId)
      .setFundedPsbt(psbt)
      .build();

    val req: lnrpc.Rpc.FundingTransitionMsg = lnrpc.Rpc.FundingTransitionMsg
      .newBuilder()
      .setPsbtVerify(funding)
      .build();

    Lndmobile.fundingStateStep(req.toByteArray(), FundingStateStepCallback(promise));
  }

  @ReactMethod
  fun fundingStateStepFinalize(chanIdHex: String, psbtHex: String, promise: Promise) {
    Log.v("ReactNativeLND", "fundingStateStep finalizing channel " + chanIdHex + " with psbt " + psbtHex);

    val chanId : ByteString = ByteString.copyFrom(hexStringToByteArray(chanIdHex));
    val psbt : ByteString = ByteString.copyFrom(hexStringToByteArray(psbtHex));

    val funding: lnrpc.Rpc.FundingPsbtFinalize = lnrpc.Rpc.FundingPsbtFinalize.newBuilder()
      .setPendingChanId(chanId)
      .setSignedPsbt(psbt)
      .build();

    val req: lnrpc.Rpc.FundingTransitionMsg = lnrpc.Rpc.FundingTransitionMsg
      .newBuilder()
      .setPsbtFinalize(funding)
      .build();

    Lndmobile.fundingStateStep(req.toByteArray(), FundingStateStepCallback(promise));
  }

  @ReactMethod
  fun openChannelPsbt(pubkeyHex: String, amountSats: Integer, promise: Promise) {
    Log.v("ReactNativeLND", "openChannelPsbt");

    val pubkey2use: ByteString = ByteString.copyFrom(hexStringToByteArray(pubkeyHex));

    val bytes = ByteArray(32);
    Random.nextBytes(bytes);
    val chanId = ByteString.copyFrom(bytes);
    val psbtshim: lnrpc.Rpc.PsbtShim = lnrpc.Rpc.PsbtShim.newBuilder()
      .setPendingChanId(chanId)
      .build();

    val fundingshim: lnrpc.Rpc.FundingShim = lnrpc.Rpc.FundingShim.newBuilder()
      .setPsbtShim(psbtshim)
      .build();

    val req: lnrpc.Rpc.OpenChannelRequest = lnrpc.Rpc.OpenChannelRequest
      .newBuilder()
      .setLocalFundingAmount(amountSats.toLong())
      .setNodePubkey(pubkey2use)
      .setFundingShim(fundingshim)
      .build();

    Lndmobile.openChannel(req.toByteArray(), OpenChannelRecvStream(promise));
  }


  @ReactMethod
  fun connectPeer(host: String, pubkeyHex: String, promise: Promise) {
    Log.v("ReactNativeLND", "connectPeer");
    val addr: lnrpc.Rpc.LightningAddress = lnrpc.Rpc.LightningAddress.newBuilder()
      .setHost(host)
      .setPubkey(pubkeyHex)
      .build();

    val req: lnrpc.Rpc.ConnectPeerRequest = lnrpc.Rpc.ConnectPeerRequest
      .newBuilder()
      .setAddr(addr)
      .build();

    Lndmobile.connectPeer(req.toByteArray(), EmptyResponseBooleanCallback(promise));
  }

  @ReactMethod
  fun walletBalance(promise: Promise) {
    Log.v("ReactNativeLND", "walletBalance");
    val req: lnrpc.Rpc.WalletBalanceRequest = lnrpc.Rpc.WalletBalanceRequest
      .newBuilder()
      .build();
    Lndmobile.walletBalance(req.toByteArray(), WalletBalanceCallback(promise));
  }

  @ReactMethod
  fun channelBalance(promise: Promise) {
    Log.v("ReactNativeLND", "channelBalance");
    val req: lnrpc.Rpc.ChannelBalanceRequest = lnrpc.Rpc.ChannelBalanceRequest
      .newBuilder()
      .build();
    Lndmobile.channelBalance(req.toByteArray(), ChannelBalanceCallback(promise));
  }

  @ReactMethod
  fun sendPaymentSync(paymentRequest: String, promise: Promise) {
    Log.v("ReactNativeLND", "sendPaymentSync");
    val req: lnrpc.Rpc.SendRequest = lnrpc.Rpc.SendRequest.newBuilder()
      .setPaymentRequest(paymentRequest)
      .build();

    Lndmobile.sendPaymentSync(req.toByteArray(), SendPaymentSyncCallback(promise));
  }

  @ReactMethod
  fun sendToRouteSync(paymentHashHex: String, route: Any, promise: Promise) {
/*    Log.v("ReactNativeLND", "sendToRouteSync");
    val route = lnrpc.Rpc.Route.newBuilder();
    route.addAllHops(hops);
    route.build();
    val req: lnrpc.Rpc.SendToRouteRequest = lnrpc.Rpc.SendToRouteRequest.newBuilder()
      .setRoute(route)
      .setPaymentHash(ByteString.copyFrom(hexStringToByteArray(paymentHashHex)))
      .build();

    Lndmobile.sendToRouteSync(req.toByteArray(), SendPaymentSyncCallback(promise));*/
  }

  @ReactMethod
  fun genSeed(promise: Promise) {
    Log.v("ReactNativeLND", "genSeed");
    val req: lnrpc.Walletunlocker.GenSeedRequest = lnrpc.Walletunlocker.GenSeedRequest
      .newBuilder()
      .build();
    Lndmobile.genSeed(req.toByteArray(), GenSeedCallback(promise))
  }
}
