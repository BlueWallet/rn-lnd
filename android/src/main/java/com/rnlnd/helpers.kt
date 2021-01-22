package com.rnlnd.helpers

import android.util.Log
import com.facebook.react.bridge.Promise
import com.google.protobuf.InvalidProtocolBufferException
import com.google.protobuf.MessageOrBuilder
import lndmobile.Callback
import lndmobile.RecvStream

class OpenChannelRecvStream(promise: Promise) : RecvStream {
  private val promise = promise;

  public override  fun onError(p0: Exception) {}

  public override  fun onResponse(var1: ByteArray?) {
    if (var1 != null) {
      val resp: lnrpc.Rpc.OpenStatusUpdate = lnrpc.Rpc.OpenStatusUpdate.parseFrom(var1);
      this.promise.resolve(respToJson(resp));
    } else {
      this.promise.resolve(true);
    }
  }
}

class CloseChannelRecvStream(promise: Promise) : RecvStream {
  private val promise = promise;

  public override  fun onError(p0: Exception) {}

  public override  fun onResponse(var1: ByteArray?) {
    if (var1 != null) {
      val resp: lnrpc.Rpc.CloseStatusUpdate = lnrpc.Rpc.CloseStatusUpdate.parseFrom(var1);
      Log.v("ReactNativeLND", "CloseChannelRecvStream onResponse: " + respToJson(resp));
      this.promise.resolve(respToJson(resp));
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
      this.promise.resolve(respToJson(resp));
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
      this.promise.resolve(respToJson(resp));
    } else {
      this.promise.resolve(false);
    }
  }
}


class ListChannelsCallback(promise: Promise) : Callback {
  private val promise = promise;

  public override  fun onError(p0: Exception) {
    Log.v("ReactNativeLND", "ListChannelsCallback onError");
    this.promise.resolve(false);
  }

  public override  fun onResponse(p0: ByteArray?) {
    Log.v("ReactNativeLND", "ListChannelsCallback success");
    if (p0 != null) {
      val resp: lnrpc.Rpc.ListChannelsResponse = lnrpc.Rpc.ListChannelsResponse.parseFrom(p0);
      this.promise.resolve(respToJson(resp));

      /*val gsonPretty = com.google.gson.GsonBuilder().setPrettyPrinting().create();

      val channelsArray = mutableListOf<Any>();
      resp.channelsList.iterator().forEach {
        val channelInfoHashMap : HashMap<String, Any> = HashMap<String, Any>();
        channelInfoHashMap.put("active", it.active);
        channelInfoHashMap.put("capacity", it.capacity);
        channelInfoHashMap.put("localBalance", it.localBalance);
        channelInfoHashMap.put("remoteBalance", it.remoteBalance);
        channelInfoHashMap.put("chanId", it.chanId);
        channelInfoHashMap.put("channelPoint", it.channelPoint);
        channelInfoHashMap.put("initiator", it.initiator);
        channelInfoHashMap.put("numUpdates", it.numUpdates);
        channelInfoHashMap.put("remotePubkey", it.remotePubkey);
        channelInfoHashMap.put("private", it.private);
        channelInfoHashMap.put("localChanReserveSat", it.localConstraints.chanReserveSat);
        channelInfoHashMap.put("remoteChanReserveSat", it.remoteConstraints.chanReserveSat);
        channelInfoHashMap.put("totalSatoshisReceived", it.totalSatoshisReceived);
        channelInfoHashMap.put("totalSatoshisSent", it.totalSatoshisSent);
        channelsArray.add(channelInfoHashMap);
      }

      this.promise.resolve(gsonPretty.toJson(channelsArray));*/
    } else {
      this.promise.resolve(false);
    }
  }
}

class ListPeersCallback(promise: Promise) : Callback {
  private val promise = promise;

  public override  fun onError(p0: Exception) {
    Log.v("ReactNativeLND", "ListPeersCallback onError");
    this.promise.resolve(false);
  }

  public override  fun onResponse(p0: ByteArray?) {
    Log.v("ReactNativeLND", "ListPeersCallback success");
    if (p0 != null) {
      val resp: lnrpc.Rpc.ListPeersResponse = lnrpc.Rpc.ListPeersResponse.parseFrom(p0);
      this.promise.resolve(respToJson(resp));
    } else {
      this.promise.resolve(false);
    }
  }
}


class PendingChannelsCallback(promise: Promise) : Callback {
  private val promise = promise;

  public override  fun onError(p0: Exception) {
    Log.v("ReactNativeLND", "PendingChannelsCallback onError");
    this.promise.resolve(false);
  }

  public override  fun onResponse(p0: ByteArray?) {
    Log.v("ReactNativeLND", "PendingChannelsCallback success");
    if (p0 != null) {
      val resp: lnrpc.Rpc.PendingChannelsResponse = lnrpc.Rpc.PendingChannelsResponse.parseFrom(p0);
      this.promise.resolve(respToJson(resp));
    } else {
      this.promise.resolve(false);
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
    Log.v("ReactNativeLND", "lnd started ===========================================================================");
    this.promise.resolve(true);
  }
}

class StartCallback2 : Callback {
  public override  fun onError(p0: Exception) {
    Log.v("ReactNativeLND", "start callback onError 2");
  }

  public override  fun onResponse(p0: ByteArray?) {
    Log.v("ReactNativeLND", "lnd is ready ===========================================================================");
  }
}


class InitWalletCallback(promise: Promise) : Callback {
  private val promise = promise;

  override fun onError(e: Exception) {
    Log.v("ReactNativeLND", "lnd init err ===========================================================================" + e.message);
    this.promise.resolve(false);
  }

  override fun onResponse(bytes: ByteArray?) {
    Log.v("ReactNativeLND", "lnd inited ===========================================================================");
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
    Log.v("ReactNativeLND", "lnd unlock err ===========================================================================" + e.message);
    this.prr.resolve(false);
  }

  override fun onResponse(bytes: ByteArray?) {
    Log.v("ReactNativeLND", "lnd unlocked ===========================================================================");
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
        this.promise.resolve(respToJson(resp));
      } else {
        this.promise.resolve(false);
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
        this.promise.resolve(respToJson(resp));
      } else {
        this.promise.resolve(false);
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
        this.promise.resolve(resp.cipherSeedMnemonicList.joinToString(" "));
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
        this.promise.resolve(respToJson(resp));
      } else {
        this.promise.resolve(false);
      }
    } catch (e: InvalidProtocolBufferException) {
      e.printStackTrace();
      this.promise.resolve(false);
    }
  }
}

class DecodePayReqCallback(private val promise: Promise) : Callback {
  override fun onError(e: Exception) {
    Log.v("ReactNativeLND", "DecodePayReqCallback err" + e.message);
    this.promise.resolve(false);
  }

  override fun onResponse(bytes: ByteArray?) {
    Log.v("ReactNativeLND", "DecodePayReqCallback ok");
    try {
      if (bytes != null) {
        val resp: lnrpc.Rpc.PayReq = lnrpc.Rpc.PayReq.parseFrom(bytes);
        this.promise.resolve(respToJson(resp));
      } else {
        this.promise.resolve(false);
      }
    } catch (e: InvalidProtocolBufferException) {
      e.printStackTrace();
      this.promise.resolve(false);
    }
  }
}


class SendToRouteV2Callback(private val promise: Promise) : Callback {
  override fun onError(e: Exception) {
    Log.v("ReactNativeLND", "SendtoRouteV2Callback err" + e.message);
    this.promise.resolve(false);
  }

  override fun onResponse(bytes: ByteArray?) {
    Log.v("ReactNativeLND", "SendtoRouteV2Callback ok");
    try {
      if (bytes != null) {
        val resp: lnrpc.Rpc.HTLCAttempt = lnrpc.Rpc.HTLCAttempt.parseFrom(bytes);
        this.promise.resolve(respToJson(resp));
      } else {
        this.promise.resolve(false);
      }
    } catch (e: InvalidProtocolBufferException) {
      e.printStackTrace();
      this.promise.resolve(false);
    }
  }
}


class AddInvoiceCallback(private val promise: Promise) : Callback {
  override fun onError(e: Exception) {
    Log.v("ReactNativeLND", "AddInvoiceCallback err" + e.message);
    this.promise.resolve(false);
  }

  override fun onResponse(bytes: ByteArray?) {
    Log.v("ReactNativeLND", "AddInvoiceCallback ok");
    try {
      if (bytes != null) {
        val resp: lnrpc.Rpc.AddInvoiceResponse = lnrpc.Rpc.AddInvoiceResponse.parseFrom(bytes)
        this.promise.resolve(respToJson(resp));
      } else {
        this.promise.resolve(false);
      }
    } catch (e: InvalidProtocolBufferException) {
      e.printStackTrace();
      this.promise.resolve(false);
    }
  }
}



class ListPaymentsCallback(private val promise: Promise) : Callback {
  override fun onError(e: Exception) {
    Log.v("ReactNativeLND", "ListPaymentsCallback err" + e.message);
    this.promise.resolve(false);
  }

  override fun onResponse(bytes: ByteArray?) {
    Log.v("ReactNativeLND", "ListPaymentsCallback ok");
    try {
      if (bytes != null) {
        val resp = lnrpc.Rpc.ListPaymentsResponse.parseFrom(bytes)
        this.promise.resolve(respToJson(resp));
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

fun respToJson(resp: MessageOrBuilder): String {
  return com.google.protobuf.util.JsonFormat.printer().print(resp);
}
