// DO NOT EDIT.
// swift-format-ignore-file
//
// Generated by the Swift generator plugin for the protocol buffer compiler.
// Source: chainrpc/chainnotifier.proto
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

struct Chainrpc_ConfRequest {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  ///
  ///The transaction hash for which we should request a confirmation notification
  ///for. If set to a hash of all zeros, then the confirmation notification will
  ///be requested for the script instead.
  var txid: Data = Data()

  ///
  ///An output script within a transaction with the hash above which will be used
  ///by light clients to match block filters. If the transaction hash is set to a
  ///hash of all zeros, then a confirmation notification will be requested for
  ///this script instead.
  var script: Data = Data()

  ///
  ///The number of desired confirmations the transaction/output script should
  ///reach before dispatching a confirmation notification.
  var numConfs: UInt32 = 0

  ///
  ///The earliest height in the chain for which the transaction/output script
  ///could have been included in a block. This should in most cases be set to the
  ///broadcast height of the transaction/output script.
  var heightHint: UInt32 = 0

  var unknownFields = SwiftProtobuf.UnknownStorage()

  init() {}
}

struct Chainrpc_ConfDetails {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  /// The raw bytes of the confirmed transaction.
  var rawTx: Data = Data()

  /// The hash of the block in which the confirmed transaction was included in.
  var blockHash: Data = Data()

  /// The height of the block in which the confirmed transaction was included
  /// in.
  var blockHeight: UInt32 = 0

  /// The index of the confirmed transaction within the transaction.
  var txIndex: UInt32 = 0

  var unknownFields = SwiftProtobuf.UnknownStorage()

  init() {}
}

/// TODO(wilmer): need to know how the client will use this first.
struct Chainrpc_Reorg {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  var unknownFields = SwiftProtobuf.UnknownStorage()

  init() {}
}

struct Chainrpc_ConfEvent {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  var event: Chainrpc_ConfEvent.OneOf_Event? = nil

  ///
  ///An event that includes the confirmation details of the request
  ///(txid/ouput script).
  var conf: Chainrpc_ConfDetails {
    get {
      if case .conf(let v)? = event {return v}
      return Chainrpc_ConfDetails()
    }
    set {event = .conf(newValue)}
  }

  ///
  ///An event send when the transaction of the request is reorged out of the
  ///chain.
  var reorg: Chainrpc_Reorg {
    get {
      if case .reorg(let v)? = event {return v}
      return Chainrpc_Reorg()
    }
    set {event = .reorg(newValue)}
  }

  var unknownFields = SwiftProtobuf.UnknownStorage()

  enum OneOf_Event: Equatable {
    ///
    ///An event that includes the confirmation details of the request
    ///(txid/ouput script).
    case conf(Chainrpc_ConfDetails)
    ///
    ///An event send when the transaction of the request is reorged out of the
    ///chain.
    case reorg(Chainrpc_Reorg)

  #if !swift(>=4.1)
    static func ==(lhs: Chainrpc_ConfEvent.OneOf_Event, rhs: Chainrpc_ConfEvent.OneOf_Event) -> Bool {
      // The use of inline closures is to circumvent an issue where the compiler
      // allocates stack space for every case branch when no optimizations are
      // enabled. https://github.com/apple/swift-protobuf/issues/1034
      switch (lhs, rhs) {
      case (.conf, .conf): return {
        guard case .conf(let l) = lhs, case .conf(let r) = rhs else { preconditionFailure() }
        return l == r
      }()
      case (.reorg, .reorg): return {
        guard case .reorg(let l) = lhs, case .reorg(let r) = rhs else { preconditionFailure() }
        return l == r
      }()
      default: return false
      }
    }
  #endif
  }

  init() {}
}

struct Chainrpc_Outpoint {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  /// The hash of the transaction.
  var hash: Data = Data()

  /// The index of the output within the transaction.
  var index: UInt32 = 0

  var unknownFields = SwiftProtobuf.UnknownStorage()

  init() {}
}

struct Chainrpc_SpendRequest {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  ///
  ///The outpoint for which we should request a spend notification for. If set to
  ///a zero outpoint, then the spend notification will be requested for the
  ///script instead.
  var outpoint: Chainrpc_Outpoint {
    get {return _outpoint ?? Chainrpc_Outpoint()}
    set {_outpoint = newValue}
  }
  /// Returns true if `outpoint` has been explicitly set.
  var hasOutpoint: Bool {return self._outpoint != nil}
  /// Clears the value of `outpoint`. Subsequent reads from it will return its default value.
  mutating func clearOutpoint() {self._outpoint = nil}

  ///
  ///The output script for the outpoint above. This will be used by light clients
  ///to match block filters. If the outpoint is set to a zero outpoint, then a
  ///spend notification will be requested for this script instead.
  var script: Data = Data()

  ///
  ///The earliest height in the chain for which the outpoint/output script could
  ///have been spent. This should in most cases be set to the broadcast height of
  ///the outpoint/output script.
  var heightHint: UInt32 = 0

  var unknownFields = SwiftProtobuf.UnknownStorage()

  init() {}

  fileprivate var _outpoint: Chainrpc_Outpoint? = nil
}

struct Chainrpc_SpendDetails {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  /// The outpoint was that spent.
  var spendingOutpoint: Chainrpc_Outpoint {
    get {return _spendingOutpoint ?? Chainrpc_Outpoint()}
    set {_spendingOutpoint = newValue}
  }
  /// Returns true if `spendingOutpoint` has been explicitly set.
  var hasSpendingOutpoint: Bool {return self._spendingOutpoint != nil}
  /// Clears the value of `spendingOutpoint`. Subsequent reads from it will return its default value.
  mutating func clearSpendingOutpoint() {self._spendingOutpoint = nil}

  /// The raw bytes of the spending transaction.
  var rawSpendingTx: Data = Data()

  /// The hash of the spending transaction.
  var spendingTxHash: Data = Data()

  /// The input of the spending transaction that fulfilled the spend request.
  var spendingInputIndex: UInt32 = 0

  /// The height at which the spending transaction was included in a block.
  var spendingHeight: UInt32 = 0

  var unknownFields = SwiftProtobuf.UnknownStorage()

  init() {}

  fileprivate var _spendingOutpoint: Chainrpc_Outpoint? = nil
}

struct Chainrpc_SpendEvent {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  var event: Chainrpc_SpendEvent.OneOf_Event? = nil

  ///
  ///An event that includes the details of the spending transaction of the
  ///request (outpoint/output script).
  var spend: Chainrpc_SpendDetails {
    get {
      if case .spend(let v)? = event {return v}
      return Chainrpc_SpendDetails()
    }
    set {event = .spend(newValue)}
  }

  ///
  ///An event sent when the spending transaction of the request was
  ///reorged out of the chain.
  var reorg: Chainrpc_Reorg {
    get {
      if case .reorg(let v)? = event {return v}
      return Chainrpc_Reorg()
    }
    set {event = .reorg(newValue)}
  }

  var unknownFields = SwiftProtobuf.UnknownStorage()

  enum OneOf_Event: Equatable {
    ///
    ///An event that includes the details of the spending transaction of the
    ///request (outpoint/output script).
    case spend(Chainrpc_SpendDetails)
    ///
    ///An event sent when the spending transaction of the request was
    ///reorged out of the chain.
    case reorg(Chainrpc_Reorg)

  #if !swift(>=4.1)
    static func ==(lhs: Chainrpc_SpendEvent.OneOf_Event, rhs: Chainrpc_SpendEvent.OneOf_Event) -> Bool {
      // The use of inline closures is to circumvent an issue where the compiler
      // allocates stack space for every case branch when no optimizations are
      // enabled. https://github.com/apple/swift-protobuf/issues/1034
      switch (lhs, rhs) {
      case (.spend, .spend): return {
        guard case .spend(let l) = lhs, case .spend(let r) = rhs else { preconditionFailure() }
        return l == r
      }()
      case (.reorg, .reorg): return {
        guard case .reorg(let l) = lhs, case .reorg(let r) = rhs else { preconditionFailure() }
        return l == r
      }()
      default: return false
      }
    }
  #endif
  }

  init() {}
}

struct Chainrpc_BlockEpoch {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  /// The hash of the block.
  var hash: Data = Data()

  /// The height of the block.
  var height: UInt32 = 0

  var unknownFields = SwiftProtobuf.UnknownStorage()

  init() {}
}

// MARK: - Code below here is support for the SwiftProtobuf runtime.

fileprivate let _protobuf_package = "chainrpc"

extension Chainrpc_ConfRequest: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  static let protoMessageName: String = _protobuf_package + ".ConfRequest"
  static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .same(proto: "txid"),
    2: .same(proto: "script"),
    3: .standard(proto: "num_confs"),
    4: .standard(proto: "height_hint"),
  ]

  mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      // The use of inline closures is to circumvent an issue where the compiler
      // allocates stack space for every case branch when no optimizations are
      // enabled. https://github.com/apple/swift-protobuf/issues/1034
      switch fieldNumber {
      case 1: try { try decoder.decodeSingularBytesField(value: &self.txid) }()
      case 2: try { try decoder.decodeSingularBytesField(value: &self.script) }()
      case 3: try { try decoder.decodeSingularUInt32Field(value: &self.numConfs) }()
      case 4: try { try decoder.decodeSingularUInt32Field(value: &self.heightHint) }()
      default: break
      }
    }
  }

  func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    if !self.txid.isEmpty {
      try visitor.visitSingularBytesField(value: self.txid, fieldNumber: 1)
    }
    if !self.script.isEmpty {
      try visitor.visitSingularBytesField(value: self.script, fieldNumber: 2)
    }
    if self.numConfs != 0 {
      try visitor.visitSingularUInt32Field(value: self.numConfs, fieldNumber: 3)
    }
    if self.heightHint != 0 {
      try visitor.visitSingularUInt32Field(value: self.heightHint, fieldNumber: 4)
    }
    try unknownFields.traverse(visitor: &visitor)
  }

  static func ==(lhs: Chainrpc_ConfRequest, rhs: Chainrpc_ConfRequest) -> Bool {
    if lhs.txid != rhs.txid {return false}
    if lhs.script != rhs.script {return false}
    if lhs.numConfs != rhs.numConfs {return false}
    if lhs.heightHint != rhs.heightHint {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}

extension Chainrpc_ConfDetails: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  static let protoMessageName: String = _protobuf_package + ".ConfDetails"
  static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .standard(proto: "raw_tx"),
    2: .standard(proto: "block_hash"),
    3: .standard(proto: "block_height"),
    4: .standard(proto: "tx_index"),
  ]

  mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      // The use of inline closures is to circumvent an issue where the compiler
      // allocates stack space for every case branch when no optimizations are
      // enabled. https://github.com/apple/swift-protobuf/issues/1034
      switch fieldNumber {
      case 1: try { try decoder.decodeSingularBytesField(value: &self.rawTx) }()
      case 2: try { try decoder.decodeSingularBytesField(value: &self.blockHash) }()
      case 3: try { try decoder.decodeSingularUInt32Field(value: &self.blockHeight) }()
      case 4: try { try decoder.decodeSingularUInt32Field(value: &self.txIndex) }()
      default: break
      }
    }
  }

  func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    if !self.rawTx.isEmpty {
      try visitor.visitSingularBytesField(value: self.rawTx, fieldNumber: 1)
    }
    if !self.blockHash.isEmpty {
      try visitor.visitSingularBytesField(value: self.blockHash, fieldNumber: 2)
    }
    if self.blockHeight != 0 {
      try visitor.visitSingularUInt32Field(value: self.blockHeight, fieldNumber: 3)
    }
    if self.txIndex != 0 {
      try visitor.visitSingularUInt32Field(value: self.txIndex, fieldNumber: 4)
    }
    try unknownFields.traverse(visitor: &visitor)
  }

  static func ==(lhs: Chainrpc_ConfDetails, rhs: Chainrpc_ConfDetails) -> Bool {
    if lhs.rawTx != rhs.rawTx {return false}
    if lhs.blockHash != rhs.blockHash {return false}
    if lhs.blockHeight != rhs.blockHeight {return false}
    if lhs.txIndex != rhs.txIndex {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}

extension Chainrpc_Reorg: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  static let protoMessageName: String = _protobuf_package + ".Reorg"
  static let _protobuf_nameMap = SwiftProtobuf._NameMap()

  mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let _ = try decoder.nextFieldNumber() {
    }
  }

  func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    try unknownFields.traverse(visitor: &visitor)
  }

  static func ==(lhs: Chainrpc_Reorg, rhs: Chainrpc_Reorg) -> Bool {
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}

extension Chainrpc_ConfEvent: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  static let protoMessageName: String = _protobuf_package + ".ConfEvent"
  static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .same(proto: "conf"),
    2: .same(proto: "reorg"),
  ]

  mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      // The use of inline closures is to circumvent an issue where the compiler
      // allocates stack space for every case branch when no optimizations are
      // enabled. https://github.com/apple/swift-protobuf/issues/1034
      switch fieldNumber {
      case 1: try {
        var v: Chainrpc_ConfDetails?
        if let current = self.event {
          try decoder.handleConflictingOneOf()
          if case .conf(let m) = current {v = m}
        }
        try decoder.decodeSingularMessageField(value: &v)
        if let v = v {self.event = .conf(v)}
      }()
      case 2: try {
        var v: Chainrpc_Reorg?
        if let current = self.event {
          try decoder.handleConflictingOneOf()
          if case .reorg(let m) = current {v = m}
        }
        try decoder.decodeSingularMessageField(value: &v)
        if let v = v {self.event = .reorg(v)}
      }()
      default: break
      }
    }
  }

  func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    // The use of inline closures is to circumvent an issue where the compiler
    // allocates stack space for every case branch when no optimizations are
    // enabled. https://github.com/apple/swift-protobuf/issues/1034
    switch self.event {
    case .conf?: try {
      guard case .conf(let v)? = self.event else { preconditionFailure() }
      try visitor.visitSingularMessageField(value: v, fieldNumber: 1)
    }()
    case .reorg?: try {
      guard case .reorg(let v)? = self.event else { preconditionFailure() }
      try visitor.visitSingularMessageField(value: v, fieldNumber: 2)
    }()
    case nil: break
    }
    try unknownFields.traverse(visitor: &visitor)
  }

  static func ==(lhs: Chainrpc_ConfEvent, rhs: Chainrpc_ConfEvent) -> Bool {
    if lhs.event != rhs.event {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}

extension Chainrpc_Outpoint: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  static let protoMessageName: String = _protobuf_package + ".Outpoint"
  static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .same(proto: "hash"),
    2: .same(proto: "index"),
  ]

  mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      // The use of inline closures is to circumvent an issue where the compiler
      // allocates stack space for every case branch when no optimizations are
      // enabled. https://github.com/apple/swift-protobuf/issues/1034
      switch fieldNumber {
      case 1: try { try decoder.decodeSingularBytesField(value: &self.hash) }()
      case 2: try { try decoder.decodeSingularUInt32Field(value: &self.index) }()
      default: break
      }
    }
  }

  func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    if !self.hash.isEmpty {
      try visitor.visitSingularBytesField(value: self.hash, fieldNumber: 1)
    }
    if self.index != 0 {
      try visitor.visitSingularUInt32Field(value: self.index, fieldNumber: 2)
    }
    try unknownFields.traverse(visitor: &visitor)
  }

  static func ==(lhs: Chainrpc_Outpoint, rhs: Chainrpc_Outpoint) -> Bool {
    if lhs.hash != rhs.hash {return false}
    if lhs.index != rhs.index {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}

extension Chainrpc_SpendRequest: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  static let protoMessageName: String = _protobuf_package + ".SpendRequest"
  static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .same(proto: "outpoint"),
    2: .same(proto: "script"),
    3: .standard(proto: "height_hint"),
  ]

  mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      // The use of inline closures is to circumvent an issue where the compiler
      // allocates stack space for every case branch when no optimizations are
      // enabled. https://github.com/apple/swift-protobuf/issues/1034
      switch fieldNumber {
      case 1: try { try decoder.decodeSingularMessageField(value: &self._outpoint) }()
      case 2: try { try decoder.decodeSingularBytesField(value: &self.script) }()
      case 3: try { try decoder.decodeSingularUInt32Field(value: &self.heightHint) }()
      default: break
      }
    }
  }

  func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    if let v = self._outpoint {
      try visitor.visitSingularMessageField(value: v, fieldNumber: 1)
    }
    if !self.script.isEmpty {
      try visitor.visitSingularBytesField(value: self.script, fieldNumber: 2)
    }
    if self.heightHint != 0 {
      try visitor.visitSingularUInt32Field(value: self.heightHint, fieldNumber: 3)
    }
    try unknownFields.traverse(visitor: &visitor)
  }

  static func ==(lhs: Chainrpc_SpendRequest, rhs: Chainrpc_SpendRequest) -> Bool {
    if lhs._outpoint != rhs._outpoint {return false}
    if lhs.script != rhs.script {return false}
    if lhs.heightHint != rhs.heightHint {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}

extension Chainrpc_SpendDetails: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  static let protoMessageName: String = _protobuf_package + ".SpendDetails"
  static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .standard(proto: "spending_outpoint"),
    2: .standard(proto: "raw_spending_tx"),
    3: .standard(proto: "spending_tx_hash"),
    4: .standard(proto: "spending_input_index"),
    5: .standard(proto: "spending_height"),
  ]

  mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      // The use of inline closures is to circumvent an issue where the compiler
      // allocates stack space for every case branch when no optimizations are
      // enabled. https://github.com/apple/swift-protobuf/issues/1034
      switch fieldNumber {
      case 1: try { try decoder.decodeSingularMessageField(value: &self._spendingOutpoint) }()
      case 2: try { try decoder.decodeSingularBytesField(value: &self.rawSpendingTx) }()
      case 3: try { try decoder.decodeSingularBytesField(value: &self.spendingTxHash) }()
      case 4: try { try decoder.decodeSingularUInt32Field(value: &self.spendingInputIndex) }()
      case 5: try { try decoder.decodeSingularUInt32Field(value: &self.spendingHeight) }()
      default: break
      }
    }
  }

  func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    if let v = self._spendingOutpoint {
      try visitor.visitSingularMessageField(value: v, fieldNumber: 1)
    }
    if !self.rawSpendingTx.isEmpty {
      try visitor.visitSingularBytesField(value: self.rawSpendingTx, fieldNumber: 2)
    }
    if !self.spendingTxHash.isEmpty {
      try visitor.visitSingularBytesField(value: self.spendingTxHash, fieldNumber: 3)
    }
    if self.spendingInputIndex != 0 {
      try visitor.visitSingularUInt32Field(value: self.spendingInputIndex, fieldNumber: 4)
    }
    if self.spendingHeight != 0 {
      try visitor.visitSingularUInt32Field(value: self.spendingHeight, fieldNumber: 5)
    }
    try unknownFields.traverse(visitor: &visitor)
  }

  static func ==(lhs: Chainrpc_SpendDetails, rhs: Chainrpc_SpendDetails) -> Bool {
    if lhs._spendingOutpoint != rhs._spendingOutpoint {return false}
    if lhs.rawSpendingTx != rhs.rawSpendingTx {return false}
    if lhs.spendingTxHash != rhs.spendingTxHash {return false}
    if lhs.spendingInputIndex != rhs.spendingInputIndex {return false}
    if lhs.spendingHeight != rhs.spendingHeight {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}

extension Chainrpc_SpendEvent: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  static let protoMessageName: String = _protobuf_package + ".SpendEvent"
  static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .same(proto: "spend"),
    2: .same(proto: "reorg"),
  ]

  mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      // The use of inline closures is to circumvent an issue where the compiler
      // allocates stack space for every case branch when no optimizations are
      // enabled. https://github.com/apple/swift-protobuf/issues/1034
      switch fieldNumber {
      case 1: try {
        var v: Chainrpc_SpendDetails?
        if let current = self.event {
          try decoder.handleConflictingOneOf()
          if case .spend(let m) = current {v = m}
        }
        try decoder.decodeSingularMessageField(value: &v)
        if let v = v {self.event = .spend(v)}
      }()
      case 2: try {
        var v: Chainrpc_Reorg?
        if let current = self.event {
          try decoder.handleConflictingOneOf()
          if case .reorg(let m) = current {v = m}
        }
        try decoder.decodeSingularMessageField(value: &v)
        if let v = v {self.event = .reorg(v)}
      }()
      default: break
      }
    }
  }

  func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    // The use of inline closures is to circumvent an issue where the compiler
    // allocates stack space for every case branch when no optimizations are
    // enabled. https://github.com/apple/swift-protobuf/issues/1034
    switch self.event {
    case .spend?: try {
      guard case .spend(let v)? = self.event else { preconditionFailure() }
      try visitor.visitSingularMessageField(value: v, fieldNumber: 1)
    }()
    case .reorg?: try {
      guard case .reorg(let v)? = self.event else { preconditionFailure() }
      try visitor.visitSingularMessageField(value: v, fieldNumber: 2)
    }()
    case nil: break
    }
    try unknownFields.traverse(visitor: &visitor)
  }

  static func ==(lhs: Chainrpc_SpendEvent, rhs: Chainrpc_SpendEvent) -> Bool {
    if lhs.event != rhs.event {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}

extension Chainrpc_BlockEpoch: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  static let protoMessageName: String = _protobuf_package + ".BlockEpoch"
  static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .same(proto: "hash"),
    2: .same(proto: "height"),
  ]

  mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      // The use of inline closures is to circumvent an issue where the compiler
      // allocates stack space for every case branch when no optimizations are
      // enabled. https://github.com/apple/swift-protobuf/issues/1034
      switch fieldNumber {
      case 1: try { try decoder.decodeSingularBytesField(value: &self.hash) }()
      case 2: try { try decoder.decodeSingularUInt32Field(value: &self.height) }()
      default: break
      }
    }
  }

  func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    if !self.hash.isEmpty {
      try visitor.visitSingularBytesField(value: self.hash, fieldNumber: 1)
    }
    if self.height != 0 {
      try visitor.visitSingularUInt32Field(value: self.height, fieldNumber: 2)
    }
    try unknownFields.traverse(visitor: &visitor)
  }

  static func ==(lhs: Chainrpc_BlockEpoch, rhs: Chainrpc_BlockEpoch) -> Bool {
    if lhs.hash != rhs.hash {return false}
    if lhs.height != rhs.height {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}
