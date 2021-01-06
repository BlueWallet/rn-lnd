// DO NOT EDIT.
// swift-format-ignore-file
//
// Generated by the Swift generator plugin for the protocol buffer compiler.
// Source: invoicesrpc/invoices.proto
//
// For information on using the generated types, please see the documentation:
//   https://github.com/apple/swift-protobuf/

import Foundation
import SwiftProtobuf

// If the compiler emits an error on this type, it is because this file
// was generated by a version of the `protoc` Swift plug-in that is
// incompatible with the version of SwiftProtobuf to which you are linking.
// Please ensure that you are building against the same version of the API
// that was used to generate this file.
fileprivate struct _GeneratedWithProtocGenSwiftVersion: SwiftProtobuf.ProtobufAPIVersionCheck {
  struct _2: SwiftProtobuf.ProtobufAPIVersion_2 {}
  typealias Version = _2
}

struct Invoicesrpc_CancelInvoiceMsg {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  /// Hash corresponding to the (hold) invoice to cancel.
  var paymentHash: Data = Data()

  var unknownFields = SwiftProtobuf.UnknownStorage()

  init() {}
}

struct Invoicesrpc_CancelInvoiceResp {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  var unknownFields = SwiftProtobuf.UnknownStorage()

  init() {}
}

struct Invoicesrpc_AddHoldInvoiceRequest {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  ///
  ///An optional memo to attach along with the invoice. Used for record keeping
  ///purposes for the invoice's creator, and will also be set in the description
  ///field of the encoded payment request if the description_hash field is not
  ///being used.
  var memo: String = String()

  /// The hash of the preimage
  var hash: Data = Data()

  ///
  ///The value of this invoice in satoshis
  ///
  ///The fields value and value_msat are mutually exclusive.
  var value: Int64 = 0

  ///
  ///The value of this invoice in millisatoshis
  ///
  ///The fields value and value_msat are mutually exclusive.
  var valueMsat: Int64 = 0

  ///
  ///Hash (SHA-256) of a description of the payment. Used if the description of
  ///payment (memo) is too long to naturally fit within the description field
  ///of an encoded payment request.
  var descriptionHash: Data = Data()

  /// Payment request expiry time in seconds. Default is 3600 (1 hour).
  var expiry: Int64 = 0

  /// Fallback on-chain address.
  var fallbackAddr: String = String()

  /// Delta to use for the time-lock of the CLTV extended to the final hop.
  var cltvExpiry: UInt64 = 0

  ///
  ///Route hints that can each be individually used to assist in reaching the
  ///invoice's destination.
  var routeHints: [Lnrpc_RouteHint] = []

  /// Whether this invoice should include routing hints for private channels.
  var `private`: Bool = false

  var unknownFields = SwiftProtobuf.UnknownStorage()

  init() {}
}

struct Invoicesrpc_AddHoldInvoiceResp {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  ///
  ///A bare-bones invoice for a payment within the Lightning Network.  With the
  ///details of the invoice, the sender has all the data necessary to send a
  ///payment to the recipient.
  var paymentRequest: String = String()

  var unknownFields = SwiftProtobuf.UnknownStorage()

  init() {}
}

struct Invoicesrpc_SettleInvoiceMsg {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  /// Externally discovered pre-image that should be used to settle the hold
  /// invoice.
  var preimage: Data = Data()

  var unknownFields = SwiftProtobuf.UnknownStorage()

  init() {}
}

struct Invoicesrpc_SettleInvoiceResp {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  var unknownFields = SwiftProtobuf.UnknownStorage()

  init() {}
}

struct Invoicesrpc_SubscribeSingleInvoiceRequest {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  /// Hash corresponding to the (hold) invoice to subscribe to.
  var rHash: Data = Data()

  var unknownFields = SwiftProtobuf.UnknownStorage()

  init() {}
}

// MARK: - Code below here is support for the SwiftProtobuf runtime.

fileprivate let _protobuf_package = "invoicesrpc"

extension Invoicesrpc_CancelInvoiceMsg: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  static let protoMessageName: String = _protobuf_package + ".CancelInvoiceMsg"
  static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .standard(proto: "payment_hash"),
  ]

  mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      // The use of inline closures is to circumvent an issue where the compiler
      // allocates stack space for every case branch when no optimizations are
      // enabled. https://github.com/apple/swift-protobuf/issues/1034
      switch fieldNumber {
      case 1: try { try decoder.decodeSingularBytesField(value: &self.paymentHash) }()
      default: break
      }
    }
  }

  func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    if !self.paymentHash.isEmpty {
      try visitor.visitSingularBytesField(value: self.paymentHash, fieldNumber: 1)
    }
    try unknownFields.traverse(visitor: &visitor)
  }

  static func ==(lhs: Invoicesrpc_CancelInvoiceMsg, rhs: Invoicesrpc_CancelInvoiceMsg) -> Bool {
    if lhs.paymentHash != rhs.paymentHash {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}

extension Invoicesrpc_CancelInvoiceResp: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  static let protoMessageName: String = _protobuf_package + ".CancelInvoiceResp"
  static let _protobuf_nameMap = SwiftProtobuf._NameMap()

  mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let _ = try decoder.nextFieldNumber() {
    }
  }

  func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    try unknownFields.traverse(visitor: &visitor)
  }

  static func ==(lhs: Invoicesrpc_CancelInvoiceResp, rhs: Invoicesrpc_CancelInvoiceResp) -> Bool {
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}

extension Invoicesrpc_AddHoldInvoiceRequest: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  static let protoMessageName: String = _protobuf_package + ".AddHoldInvoiceRequest"
  static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .same(proto: "memo"),
    2: .same(proto: "hash"),
    3: .same(proto: "value"),
    10: .standard(proto: "value_msat"),
    4: .standard(proto: "description_hash"),
    5: .same(proto: "expiry"),
    6: .standard(proto: "fallback_addr"),
    7: .standard(proto: "cltv_expiry"),
    8: .standard(proto: "route_hints"),
    9: .same(proto: "private"),
  ]

  mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      // The use of inline closures is to circumvent an issue where the compiler
      // allocates stack space for every case branch when no optimizations are
      // enabled. https://github.com/apple/swift-protobuf/issues/1034
      switch fieldNumber {
      case 1: try { try decoder.decodeSingularStringField(value: &self.memo) }()
      case 2: try { try decoder.decodeSingularBytesField(value: &self.hash) }()
      case 3: try { try decoder.decodeSingularInt64Field(value: &self.value) }()
      case 4: try { try decoder.decodeSingularBytesField(value: &self.descriptionHash) }()
      case 5: try { try decoder.decodeSingularInt64Field(value: &self.expiry) }()
      case 6: try { try decoder.decodeSingularStringField(value: &self.fallbackAddr) }()
      case 7: try { try decoder.decodeSingularUInt64Field(value: &self.cltvExpiry) }()
      case 8: try { try decoder.decodeRepeatedMessageField(value: &self.routeHints) }()
      case 9: try { try decoder.decodeSingularBoolField(value: &self.`private`) }()
      case 10: try { try decoder.decodeSingularInt64Field(value: &self.valueMsat) }()
      default: break
      }
    }
  }

  func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    if !self.memo.isEmpty {
      try visitor.visitSingularStringField(value: self.memo, fieldNumber: 1)
    }
    if !self.hash.isEmpty {
      try visitor.visitSingularBytesField(value: self.hash, fieldNumber: 2)
    }
    if self.value != 0 {
      try visitor.visitSingularInt64Field(value: self.value, fieldNumber: 3)
    }
    if !self.descriptionHash.isEmpty {
      try visitor.visitSingularBytesField(value: self.descriptionHash, fieldNumber: 4)
    }
    if self.expiry != 0 {
      try visitor.visitSingularInt64Field(value: self.expiry, fieldNumber: 5)
    }
    if !self.fallbackAddr.isEmpty {
      try visitor.visitSingularStringField(value: self.fallbackAddr, fieldNumber: 6)
    }
    if self.cltvExpiry != 0 {
      try visitor.visitSingularUInt64Field(value: self.cltvExpiry, fieldNumber: 7)
    }
    if !self.routeHints.isEmpty {
      try visitor.visitRepeatedMessageField(value: self.routeHints, fieldNumber: 8)
    }
    if self.`private` != false {
      try visitor.visitSingularBoolField(value: self.`private`, fieldNumber: 9)
    }
    if self.valueMsat != 0 {
      try visitor.visitSingularInt64Field(value: self.valueMsat, fieldNumber: 10)
    }
    try unknownFields.traverse(visitor: &visitor)
  }

  static func ==(lhs: Invoicesrpc_AddHoldInvoiceRequest, rhs: Invoicesrpc_AddHoldInvoiceRequest) -> Bool {
    if lhs.memo != rhs.memo {return false}
    if lhs.hash != rhs.hash {return false}
    if lhs.value != rhs.value {return false}
    if lhs.valueMsat != rhs.valueMsat {return false}
    if lhs.descriptionHash != rhs.descriptionHash {return false}
    if lhs.expiry != rhs.expiry {return false}
    if lhs.fallbackAddr != rhs.fallbackAddr {return false}
    if lhs.cltvExpiry != rhs.cltvExpiry {return false}
    if lhs.routeHints != rhs.routeHints {return false}
    if lhs.`private` != rhs.`private` {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}

extension Invoicesrpc_AddHoldInvoiceResp: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  static let protoMessageName: String = _protobuf_package + ".AddHoldInvoiceResp"
  static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .standard(proto: "payment_request"),
  ]

  mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      // The use of inline closures is to circumvent an issue where the compiler
      // allocates stack space for every case branch when no optimizations are
      // enabled. https://github.com/apple/swift-protobuf/issues/1034
      switch fieldNumber {
      case 1: try { try decoder.decodeSingularStringField(value: &self.paymentRequest) }()
      default: break
      }
    }
  }

  func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    if !self.paymentRequest.isEmpty {
      try visitor.visitSingularStringField(value: self.paymentRequest, fieldNumber: 1)
    }
    try unknownFields.traverse(visitor: &visitor)
  }

  static func ==(lhs: Invoicesrpc_AddHoldInvoiceResp, rhs: Invoicesrpc_AddHoldInvoiceResp) -> Bool {
    if lhs.paymentRequest != rhs.paymentRequest {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}

extension Invoicesrpc_SettleInvoiceMsg: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  static let protoMessageName: String = _protobuf_package + ".SettleInvoiceMsg"
  static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .same(proto: "preimage"),
  ]

  mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      // The use of inline closures is to circumvent an issue where the compiler
      // allocates stack space for every case branch when no optimizations are
      // enabled. https://github.com/apple/swift-protobuf/issues/1034
      switch fieldNumber {
      case 1: try { try decoder.decodeSingularBytesField(value: &self.preimage) }()
      default: break
      }
    }
  }

  func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    if !self.preimage.isEmpty {
      try visitor.visitSingularBytesField(value: self.preimage, fieldNumber: 1)
    }
    try unknownFields.traverse(visitor: &visitor)
  }

  static func ==(lhs: Invoicesrpc_SettleInvoiceMsg, rhs: Invoicesrpc_SettleInvoiceMsg) -> Bool {
    if lhs.preimage != rhs.preimage {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}

extension Invoicesrpc_SettleInvoiceResp: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  static let protoMessageName: String = _protobuf_package + ".SettleInvoiceResp"
  static let _protobuf_nameMap = SwiftProtobuf._NameMap()

  mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let _ = try decoder.nextFieldNumber() {
    }
  }

  func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    try unknownFields.traverse(visitor: &visitor)
  }

  static func ==(lhs: Invoicesrpc_SettleInvoiceResp, rhs: Invoicesrpc_SettleInvoiceResp) -> Bool {
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}

extension Invoicesrpc_SubscribeSingleInvoiceRequest: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  static let protoMessageName: String = _protobuf_package + ".SubscribeSingleInvoiceRequest"
  static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    2: .standard(proto: "r_hash"),
  ]

  mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      // The use of inline closures is to circumvent an issue where the compiler
      // allocates stack space for every case branch when no optimizations are
      // enabled. https://github.com/apple/swift-protobuf/issues/1034
      switch fieldNumber {
      case 2: try { try decoder.decodeSingularBytesField(value: &self.rHash) }()
      default: break
      }
    }
  }

  func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    if !self.rHash.isEmpty {
      try visitor.visitSingularBytesField(value: self.rHash, fieldNumber: 2)
    }
    try unknownFields.traverse(visitor: &visitor)
  }

  static func ==(lhs: Invoicesrpc_SubscribeSingleInvoiceRequest, rhs: Invoicesrpc_SubscribeSingleInvoiceRequest) -> Bool {
    if lhs.rHash != rhs.rHash {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}