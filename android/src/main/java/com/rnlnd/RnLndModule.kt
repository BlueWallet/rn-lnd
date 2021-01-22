package com.rnlnd

import android.util.Base64
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
import org.json.JSONObject;

class RnLndModule(reactContext: ReactApplicationContext) : ReactContextBaseJavaModule(reactContext) {
    override fun getName(): String {
        return "RnLnd"
    }

  @ReactMethod
  fun getLndDir(promise: Promise) {
    val dir = this._getLndDir();
    promise.resolve(dir);
  }

  private fun _getLndDir(): String {
    val dir = ContextCompat.getExternalFilesDirs(reactApplicationContext.applicationContext, null)[0];
    return dir.toString() + "/.lnd";
  }

  @ReactMethod
  fun start(lndArguments: String, promise: Promise) {
    val dir = this._getLndDir();
    Log.v("ReactNativeLND", "starting LND in " + dir);
    Lndmobile.start(lndArguments + " --lnddir=" + dir, StartCallback(promise), StartCallback2());
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
  fun listPeers(promise: Promise) {
    Log.v("ReactNativeLND", "listPeers");
    val req: lnrpc.Rpc.ListPeersRequest = lnrpc.Rpc.ListPeersRequest.newBuilder().build();
    Lndmobile.listPeers(req.toByteArray(), ListPeersCallback(promise));
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
  fun openChannelPsbt(pubkeyHex: String, amountSats: Integer, privateChannel: Boolean, promise: Promise) {
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
      .setPrivate(privateChannel)
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
  fun decodePayReq(paymentRequest: String, promise: Promise) {
    Log.v("ReactNativeLND", "decodePayReq");

    val req: lnrpc.Rpc.PayReqString = lnrpc.Rpc.PayReqString.newBuilder()
      .setPayReq(paymentRequest)
      .build();

    Lndmobile.decodePayReq(req.toByteArray(), DecodePayReqCallback(promise));
  }

  @ReactMethod
  fun sendToRouteV2(paymentHashHex: String, paymentAddrHex: String, queryRoutesJsonString: String, promise: Promise) {
    Log.v("ReactNativeLND", "sendToRouteV2");

    val rootJson = JSONObject(queryRoutesJsonString);
    val routesJson = rootJson.getJSONArray("routes");
    val routeJson = routesJson.getJSONObject(0);
    val hopsJson = routeJson.getJSONArray("hops");

    val routeTemp = lnrpc.Rpc.Route.newBuilder()
      .setTotalAmtMsat(routeJson.getString("total_amt_msat").toLong())
      .setTotalFeesMsat(routeJson.getString("total_fees_msat").toLong())
      .setTotalTimeLock(routeJson.getString("total_time_lock").toInt());

    for (c in 1..hopsJson.length()) {
      val hopJson = hopsJson.getJSONObject(c-1);
      Log.v("ReactNativeLND", "chanId = " + hopJson.getLong("chan_id") + " " + hopJson.getString("chan_id") + " " + hopJson.getString("chan_id").toLong().toString() );

      // ACHTUNG: `.getString("").toLong()` MUST be used as `getLong()` can yield incorrect result on big numbers in json
      val hopTemp = lnrpc.Rpc.Hop.newBuilder()
        .setChanId(hopJson.getString("chan_id").toLong())
        .setChanCapacity(hopJson.getString("chan_capacity").toLong())
        .setExpiry(hopJson.getString("expiry").toInt())
        .setAmtToForwardMsat(hopJson.getString("amt_to_forward_msat").toLong())
        .setFeeMsat(hopJson.getString("fee_msat").toLong())
        .setPubKey(hopJson.getString("pub_key"))
        .setTlvPayload(hopJson.getBoolean("tlv_payload"));

      if (paymentAddrHex !== "" && c == hopsJson.length()) {
        // only last hop
        val mppRecord = lnrpc.Rpc.MPPRecord.newBuilder()
          .setPaymentAddr(ByteString.copyFrom(hexStringToByteArray(paymentAddrHex)))
          .setTotalAmtMsat(hopJson.getString("amt_to_forward_msat").toLong())
          .build();
        hopTemp.setMppRecord(mppRecord);
      };

      routeTemp.addHops(hopTemp.build());
    }


    val req = routerrpc.RouterOuterClass.SendToRouteRequest.newBuilder()
      .setPaymentHash(ByteString.copyFrom(hexStringToByteArray(paymentHashHex)))
      .setRoute(routeTemp.build())
      .build();

    Log.v("ReactNativeLND", "req = " + com.google.protobuf.util.JsonFormat.printer().print(req));

    Lndmobile.routerSendToRouteV2(req.toByteArray(), SendToRouteV2Callback(promise));
  }

  @ReactMethod
  fun genSeed(promise: Promise) {
    Log.v("ReactNativeLND", "genSeed");
    val req: lnrpc.Walletunlocker.GenSeedRequest = lnrpc.Walletunlocker.GenSeedRequest
      .newBuilder()
      .build();
    Lndmobile.genSeed(req.toByteArray(), GenSeedCallback(promise))
  }

  @ReactMethod
  fun addInvoice(sat: Int, memo: String, expiry: Int, promise: Promise) {
    Log.v("ReactNativeLND", "addInvoice");
    val req: lnrpc.Rpc.Invoice = lnrpc.Rpc.Invoice
      .newBuilder()
      .setValue(sat.toLong())
      .setMemo(memo)
      .setPrivate(true) // hmm
      .setExpiry(expiry.toLong())
      .build();
    Lndmobile.addInvoice(req.toByteArray(), AddInvoiceCallback(promise))
  }

  @ReactMethod
  fun listPayments(promise: Promise) {
    Log.v("ReactNativeLND", "listPayments");
    val req = lnrpc.Rpc.ListPaymentsRequest
      .newBuilder()
      .build();
    Lndmobile.listPayments(req.toByteArray(), ListPaymentsCallback(promise));
  }

  @ReactMethod
  fun closeChannel(deliveryAddress: String, fundingTxidHex: String, outputIndex: Int, force: Boolean, promise: Promise) {
    Log.v("ReactNativeLND", "closeChannel");
    val channelPoint: lnrpc.Rpc.ChannelPoint = lnrpc.Rpc.ChannelPoint
      .newBuilder()
      .setFundingTxidStr(fundingTxidHex)
      .setOutputIndex(outputIndex)
      .build();

    val req: lnrpc.Rpc.CloseChannelRequest = lnrpc.Rpc.CloseChannelRequest
      .newBuilder()
      .setChannelPoint(channelPoint)
      .setDeliveryAddress(deliveryAddress)
      .setForce(force)
      .build();
    Lndmobile.closeChannel(req.toByteArray(), CloseChannelRecvStream(promise));
  }

  @ReactMethod
  fun stopDaemon(promise: Promise) {
    Log.v("ReactNativeLND", "stopDaemon");

    val req: lnrpc.Rpc.StopRequest = lnrpc.Rpc.StopRequest
      .newBuilder()
      .build();
    Lndmobile.stopDaemon(req.toByteArray(), EmptyResponseBooleanCallback(promise));
  }
}
