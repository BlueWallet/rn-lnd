package com.rnlnd.helpers

import android.util.Log
import com.facebook.react.bridge.Promise
import com.google.protobuf.InvalidProtocolBufferException
import lndmobile.Callback
import lndmobile.RecvStream

class OpenChannelRecvStream(promise: Promise) : RecvStream {
  private val promise = promise;

  public override  fun onError(p0: Exception) {}

  public override  fun onResponse(var1: ByteArray?) {
    if (var1 != null) {
      val resp: lnrpc.Rpc.OpenStatusUpdate = lnrpc.Rpc.OpenStatusUpdate.parseFrom(var1);
      val gsonPretty = com.google.gson.GsonBuilder().setPrettyPrinting().create();
      val hashMap : HashMap<String, Any> = HashMap<String, Any>();
      hashMap.put("fundingAddress", resp.psbtFund.fundingAddress);
      hashMap.put("fundingAmount", resp.psbtFund.fundingAmount);
      hashMap.put("pendingChanId", byteArrayToHex(resp.pendingChanId.toByteArray()));
      this.promise.resolve(gsonPretty.toJson(hashMap));
    } else {
      this.promise.resolve(true);
    }
  }
}

class FundingStateStepCallback(promise: Promise) : Callback {
  private val promise = promise;

  public override  fun onError(p0: Exception) {
    Log.v("ReactNativeLND", "FundingStateStepCallback onError: " + p0.message);
    this.promise.resolve(false);
  }

  public override  fun onResponse(p0: ByteArray?) {
    Log.v("ReactNativeLND", "FundingStateStepCallback success");
    if (p0 != null) {
      val resp: lnrpc.Rpc.FundingStateStepResp = lnrpc.Rpc.FundingStateStepResp.parseFrom(p0);
      Log.v("ReactNativeLND", "FundingStateStepCallback success --> " + resp.toString());
      val gsonPretty = com.google.gson.GsonBuilder().setPrettyPrinting().create();
//      this.promise.resolve(resp.toString());
      this.promise.resolve(gsonPretty.toJson(resp));
    } else {
      this.promise.resolve(true);
    }
  }
}

class GetInfoCallback(promise: Promise) : Callback {
  private val promise = promise;

  public override  fun onError(p0: Exception) {
    Log.v("ReactNativeLND", "GetInfoCallback onError");
    this.promise.resolve(false);
  }

  public override  fun onResponse(p0: ByteArray?) {
    Log.v("ReactNativeLND", "GetInfoCallback success");
    if (p0 != null) {
      val resp: lnrpc.Rpc.GetInfoResponse = lnrpc.Rpc.GetInfoResponse.parseFrom(p0);
      val gsonPretty = com.google.gson.GsonBuilder().setPrettyPrinting().create();
      val hashMap : HashMap<String, Any> = HashMap<String, Any>();
      hashMap.put("blockHeight", resp.blockHeight);
      hashMap.put("identityPubkey", resp.identityPubkey);
      hashMap.put("numActiveChannels", resp.numActiveChannels);
      hashMap.put("numInactiveChannels", resp.numInactiveChannels);
      hashMap.put("numPeers", resp.numPeers);
      hashMap.put("numPendingChannels", resp.numPendingChannels);
      hashMap.put("syncedToGraph", resp.syncedToGraph);
      hashMap.put("version", resp.version);
      hashMap.put("syncedToChain", resp.syncedToChain);

      Log.v("ReactNativeLND", "GetInfoCallback success :: " + gsonPretty.toJson(hashMap));

//      this.promise.resolve(resp);
      this.promise.resolve(gsonPretty.toJson(hashMap));
//      this.promise.resolve(gsonPretty.toJson(resp.allFields));
    } else {
      this.promise.resolve(true);
    }
  }
}


class ListChannelsCallback(promise: Promise) : Callback {
  private val promise = promise;

  public override  fun onError(p0: Exception) {
    Log.v("ReactNativeLND", "ListChannelsCallback onError");
    this.promise.resolve("[]");
  }

  public override  fun onResponse(p0: ByteArray?) {
    Log.v("ReactNativeLND", "ListChannelsCallback success");
    if (p0 != null) {
      val resp: lnrpc.Rpc.ListChannelsResponse = lnrpc.Rpc.ListChannelsResponse.parseFrom(p0);
      val gsonPretty = com.google.gson.GsonBuilder().setPrettyPrinting().create();
      this.promise.resolve(gsonPretty.toJson(resp));
    } else {
      this.promise.resolve("[]");
    }
  }
}


class PendingChannelsCallback(promise: Promise) : Callback {
  private val promise = promise;

  public override  fun onError(p0: Exception) {
    Log.v("ReactNativeLND", "PendingChannelsCallback onError");
    this.promise.resolve("[]");
  }

  public override  fun onResponse(p0: ByteArray?) {
    Log.v("ReactNativeLND", "PendingChannelsCallback success");
    if (p0 != null) {
      val resp: lnrpc.Rpc.PendingChannelsResponse = lnrpc.Rpc.PendingChannelsResponse.parseFrom(p0);
      val gsonPretty = com.google.gson.GsonBuilder().setPrettyPrinting().create();
      this.promise.resolve(gsonPretty.toJson(resp));
    } else {
      this.promise.resolve("[]");
    }
  }
}


class EmptyResponseBooleanCallback(promise: Promise) : Callback {
  private val promise = promise;

  public override  fun onError(p0: Exception) {
    Log.v("ReactNativeLND", "Callback onError");
    this.promise.resolve(false);
  }

  public override  fun onResponse(p0: ByteArray?) {
    Log.v("ReactNativeLND", "Callback success");
    this.promise.resolve(true);
  }
}

class StartCallback(promise: Promise) : Callback {
  private val promise = promise;

  public override  fun onError(p0: Exception) {
    Log.v("ReactNativeLND", "start callback onError");
    this.promise.resolve(false);
  }

  public override  fun onResponse(p0: ByteArray?) {
    Log.v("ReactNativeLND", "lnd started !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
    this.promise.resolve(true);
  }
}

class StartCallback2 : Callback {
  public override  fun onError(p0: Exception) {
    Log.v("ReactNativeLND", "start callback onError 2");
  }

  public override  fun onResponse(p0: ByteArray?) {
    Log.v("ReactNativeLND", "lnd is ready!");
  }
}


class InitWalletCallback(promise: Promise) : Callback {
  private val promise = promise;

  override fun onError(e: Exception) {
    Log.v("ReactNativeLND", "lnd init err ???????????????????????????????????" + e.message);
    this.promise.resolve(false);
  }

  override fun onResponse(bytes: ByteArray?) {
    Log.v("ReactNativeLND", "lnd inited !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
    try {
      if (bytes != null) {
        val resp: lnrpc.Walletunlocker.InitWalletResponse = lnrpc.Walletunlocker.InitWalletResponse.parseFrom(bytes);
        Log.v("ReactNativeLND", "resp: " + resp.toString());
      }
      this.promise.resolve(true);
    } catch (e: InvalidProtocolBufferException) {
      e.printStackTrace()
      this.promise.resolve(false);
    }
  }
}



class UnlockWalletCallback(pr: Promise) : Callback {
  private val prr = pr;

  override fun onError(e: Exception) {
    Log.v("ReactNativeLND", "lnd unlock err ???????????????????????????????????" + e.message);
    this.prr.resolve(false);
  }

  override fun onResponse(bytes: ByteArray?) {
    Log.v("ReactNativeLND", "lnd unlocked !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
    try {
      if (bytes != null) {
        val resp: lnrpc.Walletunlocker.UnlockWalletRequest = lnrpc.Walletunlocker.UnlockWalletRequest.parseFrom(bytes);
        Log.v("ReactNativeLND", "lnd unlock resp: " + resp.toString());
      }
      this.prr.resolve(true);
    } catch (e: InvalidProtocolBufferException) {
      e.printStackTrace();
      this.prr.resolve(false);
    }
  }
}



class WalletBalanceCallback(promise: Promise) : Callback {
  private val promise = promise;

  override fun onError(e: Exception) {
    Log.v("ReactNativeLND", "WalletBalanceCallback err" + e.message);
    this.promise.resolve(false);
  }

  override fun onResponse(bytes: ByteArray?) {
    Log.v("ReactNativeLND", "WalletBalanceCallback ok");
    try {
      if (bytes != null) {
        val resp: lnrpc.Rpc.WalletBalanceResponse = lnrpc.Rpc.WalletBalanceResponse.parseFrom(bytes);
        Log.v("ReactNativeLND", "WalletBalanceResponse " + resp.toString());
        this.promise.resolve(resp.toString());
      } else {
        this.promise.resolve(true);
      }
    } catch (e: InvalidProtocolBufferException) {
      e.printStackTrace();
      this.promise.resolve(false);
    }
  }
}


class ChannelBalanceCallback(promise: Promise) : Callback {
  private val promise = promise;

  override fun onError(e: Exception) {
    Log.v("ReactNativeLND", "ChannelBalanceCallback err" + e.message);
    this.promise.resolve(false);
  }

  override fun onResponse(bytes: ByteArray?) {
    Log.v("ReactNativeLND", "ChannelBalanceCallback ok");
    try {
      if (bytes != null) {
        val resp: lnrpc.Rpc.ChannelBalanceResponse = lnrpc.Rpc.ChannelBalanceResponse.parseFrom(bytes);
        Log.v("ReactNativeLND", "ChannelBalanceCallback " + resp.toString());
        val hashMap : HashMap<String, Any> = HashMap<String, Any>();
        hashMap.put("localBalance", resp.localBalance.sat);
        hashMap.put("remoteBalance", resp.remoteBalance.sat);
        hashMap.put("pendingOpenLocalBalance", resp.pendingOpenLocalBalance.sat);
        hashMap.put("pendingOpenRemoteBalance", resp.pendingOpenRemoteBalance.sat);
        hashMap.put("unsettledLocalBalance", resp.unsettledLocalBalance.sat);
        hashMap.put("unsettledRemoteBalance", resp.unsettledRemoteBalance.sat);

        val gsonPretty = com.google.gson.GsonBuilder().setPrettyPrinting().create();
        this.promise.resolve(gsonPretty.toJson(hashMap));
      } else {
        this.promise.resolve(true);
      }
    } catch (e: InvalidProtocolBufferException) {
      e.printStackTrace();
      this.promise.resolve(false);
    }
  }
}


class GenSeedCallback(promise: Promise) : Callback {
  private val promise = promise;

  override fun onError(e: Exception) {
    Log.v("ReactNativeLND", "GenSeedCallback err" + e.message);
    this.promise.resolve(false);
  }

  override fun onResponse(bytes: ByteArray?) {
    Log.v("ReactNativeLND", "GenSeedCallback ok");
    try {
      if (bytes != null) {
        val resp: lnrpc.Walletunlocker.GenSeedResponse = lnrpc.Walletunlocker.GenSeedResponse.parseFrom(bytes);
        val gsonPretty = com.google.gson.GsonBuilder().setPrettyPrinting().create();
        Log.v("ReactNativeLND", "GenSeedCallback " + gsonPretty.toJson(resp.cipherSeedMnemonicList));
        this.promise.resolve(gsonPretty.toJson(resp.cipherSeedMnemonicList.joinToString(" ")));
      } else {
        this.promise.resolve(false);
      }
    } catch (e: InvalidProtocolBufferException) {
      e.printStackTrace();
      this.promise.resolve(false);
    }
  }
}



class SendPaymentSyncCallback(private val promise: Promise) : Callback {
  override fun onError(e: Exception) {
    Log.v("ReactNativeLND", "SendPaymentSyncCallback err" + e.message);
    this.promise.resolve(false);
  }

  override fun onResponse(bytes: ByteArray?) {
    Log.v("ReactNativeLND", "SendPaymentSyncCallback ok");
    try {
      if (bytes != null) {
        val resp: lnrpc.Rpc.SendResponse = lnrpc.Rpc.SendResponse.parseFrom(bytes);
        val hashMap : HashMap<String, Any> = HashMap<String, Any>();
        hashMap.put("paymentError", resp.paymentError);
        hashMap.put("paymentHash", byteArrayToHex(resp.paymentHash.toByteArray()));
        hashMap.put("paymentHash", byteArrayToHex(resp.paymentPreimage.toByteArray()));
        val gsonPretty = com.google.gson.GsonBuilder().setPrettyPrinting().create();
        this.promise.resolve(gsonPretty.toJson(hashMap));
      } else {
        this.promise.resolve(false);
      }
    } catch (e: InvalidProtocolBufferException) {
      e.printStackTrace();
      this.promise.resolve(false);
    }
  }
}




fun byteArrayToHex(bytesArg: ByteArray) : String {
  return bytesArg.joinToString("") { String.format("%02X", (it.toInt() and 0xFF)) }.toLowerCase()
}



fun hexStringToByteArray(strArg: String) : ByteArray {
  val HEX_CHARS = "0123456789ABCDEF"
  val str = strArg.toUpperCase();

  val result = ByteArray(str.length / 2)

  for (i in 0 until str.length step 2) {
    val firstIndex = HEX_CHARS.indexOf(str[i]);
    val secondIndex = HEX_CHARS.indexOf(str[i + 1]);

    val octet = firstIndex.shl(4).or(secondIndex)
    result.set(i.shr(1), octet.toByte())
  }

  return result
}
