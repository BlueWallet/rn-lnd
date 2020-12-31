// DO NOT EDIT.
// swift-format-ignore-file
//
// Generated by the Swift generator plugin for the protocol buffer compiler.
// Source: signrpc/signer.proto
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

struct Signrpc_KeyLocator {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  /// The family of key being identified.
  var keyFamily: Int32 = 0

  /// The precise index of the key being identified.
  var keyIndex: Int32 = 0

  var unknownFields = SwiftProtobuf.UnknownStorage()

  init() {}
}

struct Signrpc_KeyDescriptor {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  ///
  ///The raw bytes of the key being identified. Either this or the KeyLocator
  ///must be specified.
  var rawKeyBytes: Data = Data()

  ///
  ///The key locator that identifies which key to use for signing. Either this
  ///or the raw bytes of the target key must be specified.
  var keyLoc: Signrpc_KeyLocator {
    get {return _keyLoc ?? Signrpc_KeyLocator()}
    set {_keyLoc = newValue}
  }
  /// Returns true if `keyLoc` has been explicitly set.
  var hasKeyLoc: Bool {return self._keyLoc != nil}
  /// Clears the value of `keyLoc`. Subsequent reads from it will return its default value.
  mutating func clearKeyLoc() {self._keyLoc = nil}

  var unknownFields = SwiftProtobuf.UnknownStorage()

  init() {}

  fileprivate var _keyLoc: Signrpc_KeyLocator? = nil
}

struct Signrpc_TxOut {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  /// The value of the output being spent.
  var value: Int64 = 0

  /// The script of the output being spent.
  var pkScript: Data = Data()

  var unknownFields = SwiftProtobuf.UnknownStorage()

  init() {}
}

struct Signrpc_SignDescriptor {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  ///
  ///A descriptor that precisely describes *which* key to use for signing. This
  ///may provide the raw public key directly, or require the Signer to re-derive
  ///the key according to the populated derivation path.
  ///
  ///Note that if the key descriptor was obtained through walletrpc.DeriveKey,
  ///then the key locator MUST always be provided, since the derived keys are not
  ///persisted unlike with DeriveNextKey.
  var keyDesc: Signrpc_KeyDescriptor {
    get {return _keyDesc ?? Signrpc_KeyDescriptor()}
    set {_keyDesc = newValue}
  }
  /// Returns true if `keyDesc` has been explicitly set.
  var hasKeyDesc: Bool {return self._keyDesc != nil}
  /// Clears the value of `keyDesc`. Subsequent reads from it will return its default value.
  mutating func clearKeyDesc() {self._keyDesc = nil}

  ///
  ///A scalar value that will be added to the private key corresponding to the
  ///above public key to obtain the private key to be used to sign this input.
  ///This value is typically derived via the following computation:
  ///
  /// derivedKey = privkey + sha256(perCommitmentPoint || pubKey) mod N
  var singleTweak: Data = Data()

  ///
  ///A private key that will be used in combination with its corresponding
  ///private key to derive the private key that is to be used to sign the target
  ///input. Within the Lightning protocol, this value is typically the
  ///commitment secret from a previously revoked commitment transaction. This
  ///value is in combination with two hash values, and the original private key
  ///to derive the private key to be used when signing.
  ///
  /// k = (privKey*sha256(pubKey || tweakPub) +
  ///tweakPriv*sha256(tweakPub || pubKey)) mod N
  var doubleTweak: Data = Data()

  ///
  ///The full script required to properly redeem the output.  This field will
  ///only be populated if a p2wsh or a p2sh output is being signed.
  var witnessScript: Data = Data()

  ///
  ///A description of the output being spent. The value and script MUST be
  ///provided.
  var output: Signrpc_TxOut {
    get {return _output ?? Signrpc_TxOut()}
    set {_output = newValue}
  }
  /// Returns true if `output` has been explicitly set.
  var hasOutput: Bool {return self._output != nil}
  /// Clears the value of `output`. Subsequent reads from it will return its default value.
  mutating func clearOutput() {self._output = nil}

  ///
  ///The target sighash type that should be used when generating the final
  ///sighash, and signature.
  var sighash: UInt32 = 0

  ///
  ///The target input within the transaction that should be signed.
  var inputIndex: Int32 = 0

  var unknownFields = SwiftProtobuf.UnknownStorage()

  init() {}

  fileprivate var _keyDesc: Signrpc_KeyDescriptor? = nil
  fileprivate var _output: Signrpc_TxOut? = nil
}

struct Signrpc_SignReq {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  /// The raw bytes of the transaction to be signed.
  var rawTxBytes: Data = Data()

  /// A set of sign descriptors, for each input to be signed.
  var signDescs: [Signrpc_SignDescriptor] = []

  var unknownFields = SwiftProtobuf.UnknownStorage()

  init() {}
}

struct Signrpc_SignResp {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  ///
  ///A set of signatures realized in a fixed 64-byte format ordered in ascending
  ///input order.
  var rawSigs: [Data] = []

  var unknownFields = SwiftProtobuf.UnknownStorage()

  init() {}
}

struct Signrpc_InputScript {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  /// The serializes witness stack for the specified input.
  var witness: [Data] = []

  ///
  ///The optional sig script for the specified witness that will only be set if
  ///the input specified is a nested p2sh witness program.
  var sigScript: Data = Data()

  var unknownFields = SwiftProtobuf.UnknownStorage()

  init() {}
}

struct Signrpc_InputScriptResp {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  /// The set of fully valid input scripts requested.
  var inputScripts: [Signrpc_InputScript] = []

  var unknownFields = SwiftProtobuf.UnknownStorage()

  init() {}
}

struct Signrpc_SignMessageReq {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  /// The message to be signed.
  var msg: Data = Data()

  /// The key locator that identifies which key to use for signing.
  var keyLoc: Signrpc_KeyLocator {
    get {return _keyLoc ?? Signrpc_KeyLocator()}
    set {_keyLoc = newValue}
  }
  /// Returns true if `keyLoc` has been explicitly set.
  var hasKeyLoc: Bool {return self._keyLoc != nil}
  /// Clears the value of `keyLoc`. Subsequent reads from it will return its default value.
  mutating func clearKeyLoc() {self._keyLoc = nil}

  var unknownFields = SwiftProtobuf.UnknownStorage()

  init() {}

  fileprivate var _keyLoc: Signrpc_KeyLocator? = nil
}

struct Signrpc_SignMessageResp {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  ///
  ///The signature for the given message in the fixed-size LN wire format.
  var signature: Data = Data()

  var unknownFields = SwiftProtobuf.UnknownStorage()

  init() {}
}

struct Signrpc_VerifyMessageReq {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  /// The message over which the signature is to be verified.
  var msg: Data = Data()

  ///
  ///The fixed-size LN wire encoded signature to be verified over the given
  ///message.
  var signature: Data = Data()

  /// The public key the signature has to be valid for.
  var pubkey: Data = Data()

  var unknownFields = SwiftProtobuf.UnknownStorage()

  init() {}
}

struct Signrpc_VerifyMessageResp {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  /// Whether the signature was valid over the given message.
  var valid: Bool = false

  var unknownFields = SwiftProtobuf.UnknownStorage()

  init() {}
}

struct Signrpc_SharedKeyRequest {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  /// The ephemeral public key to use for the DH key derivation.
  var ephemeralPubkey: Data = Data()

  ///
  ///Deprecated. The optional key locator of the local key that should be used.
  ///If this parameter is not set then the node's identity private key will be
  ///used.
  var keyLoc: Signrpc_KeyLocator {
    get {return _keyLoc ?? Signrpc_KeyLocator()}
    set {_keyLoc = newValue}
  }
  /// Returns true if `keyLoc` has been explicitly set.
  var hasKeyLoc: Bool {return self._keyLoc != nil}
  /// Clears the value of `keyLoc`. Subsequent reads from it will return its default value.
  mutating func clearKeyLoc() {self._keyLoc = nil}

  ///
  ///A key descriptor describes the key used for performing ECDH. Either a key
  ///locator or a raw public key is expected, if neither is supplied, defaults to
  ///the node's identity private key.
  var keyDesc: Signrpc_KeyDescriptor {
    get {return _keyDesc ?? Signrpc_KeyDescriptor()}
    set {_keyDesc = newValue}
  }
  /// Returns true if `keyDesc` has been explicitly set.
  var hasKeyDesc: Bool {return self._keyDesc != nil}
  /// Clears the value of `keyDesc`. Subsequent reads from it will return its default value.
  mutating func clearKeyDesc() {self._keyDesc = nil}

  var unknownFields = SwiftProtobuf.UnknownStorage()

  init() {}

  fileprivate var _keyLoc: Signrpc_KeyLocator? = nil
  fileprivate var _keyDesc: Signrpc_KeyDescriptor? = nil
}

struct Signrpc_SharedKeyResponse {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  /// The shared public key, hashed with sha256.
  var sharedKey: Data = Data()

  var unknownFields = SwiftProtobuf.UnknownStorage()

  init() {}
}

// MARK: - Code below here is support for the SwiftProtobuf runtime.

fileprivate let _protobuf_package = "signrpc"

extension Signrpc_KeyLocator: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  static let protoMessageName: String = _protobuf_package + ".KeyLocator"
  static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .standard(proto: "key_family"),
    2: .standard(proto: "key_index"),
  ]

  mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      // The use of inline closures is to circumvent an issue where the compiler
      // allocates stack space for every case branch when no optimizations are
      // enabled. https://github.com/apple/swift-protobuf/issues/1034
      switch fieldNumber {
      case 1: try { try decoder.decodeSingularInt32Field(value: &self.keyFamily) }()
      case 2: try { try decoder.decodeSingularInt32Field(value: &self.keyIndex) }()
      default: break
      }
    }
  }

  func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    if self.keyFamily != 0 {
      try visitor.visitSingularInt32Field(value: self.keyFamily, fieldNumber: 1)
    }
    if self.keyIndex != 0 {
      try visitor.visitSingularInt32Field(value: self.keyIndex, fieldNumber: 2)
    }
    try unknownFields.traverse(visitor: &visitor)
  }

  static func ==(lhs: Signrpc_KeyLocator, rhs: Signrpc_KeyLocator) -> Bool {
    if lhs.keyFamily != rhs.keyFamily {return false}
    if lhs.keyIndex != rhs.keyIndex {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}

extension Signrpc_KeyDescriptor: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  static let protoMessageName: String = _protobuf_package + ".KeyDescriptor"
  static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .standard(proto: "raw_key_bytes"),
    2: .standard(proto: "key_loc"),
  ]

  mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      // The use of inline closures is to circumvent an issue where the compiler
      // allocates stack space for every case branch when no optimizations are
      // enabled. https://github.com/apple/swift-protobuf/issues/1034
      switch fieldNumber {
      case 1: try { try decoder.decodeSingularBytesField(value: &self.rawKeyBytes) }()
      case 2: try { try decoder.decodeSingularMessageField(value: &self._keyLoc) }()
      default: break
      }
    }
  }

  func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    if !self.rawKeyBytes.isEmpty {
      try visitor.visitSingularBytesField(value: self.rawKeyBytes, fieldNumber: 1)
    }
    if let v = self._keyLoc {
      try visitor.visitSingularMessageField(value: v, fieldNumber: 2)
    }
    try unknownFields.traverse(visitor: &visitor)
  }

  static func ==(lhs: Signrpc_KeyDescriptor, rhs: Signrpc_KeyDescriptor) -> Bool {
    if lhs.rawKeyBytes != rhs.rawKeyBytes {return false}
    if lhs._keyLoc != rhs._keyLoc {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}

extension Signrpc_TxOut: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  static let protoMessageName: String = _protobuf_package + ".TxOut"
  static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .same(proto: "value"),
    2: .standard(proto: "pk_script"),
  ]

  mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      // The use of inline closures is to circumvent an issue where the compiler
      // allocates stack space for every case branch when no optimizations are
      // enabled. https://github.com/apple/swift-protobuf/issues/1034
      switch fieldNumber {
      case 1: try { try decoder.decodeSingularInt64Field(value: &self.value) }()
      case 2: try { try decoder.decodeSingularBytesField(value: &self.pkScript) }()
      default: break
      }
    }
  }

  func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    if self.value != 0 {
      try visitor.visitSingularInt64Field(value: self.value, fieldNumber: 1)
    }
    if !self.pkScript.isEmpty {
      try visitor.visitSingularBytesField(value: self.pkScript, fieldNumber: 2)
    }
    try unknownFields.traverse(visitor: &visitor)
  }

  static func ==(lhs: Signrpc_TxOut, rhs: Signrpc_TxOut) -> Bool {
    if lhs.value != rhs.value {return false}
    if lhs.pkScript != rhs.pkScript {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}

extension Signrpc_SignDescriptor: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  static let protoMessageName: String = _protobuf_package + ".SignDescriptor"
  static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .standard(proto: "key_desc"),
    2: .standard(proto: "single_tweak"),
    3: .standard(proto: "double_tweak"),
    4: .standard(proto: "witness_script"),
    5: .same(proto: "output"),
    7: .same(proto: "sighash"),
    8: .standard(proto: "input_index"),
  ]

  mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      // The use of inline closures is to circumvent an issue where the compiler
      // allocates stack space for every case branch when no optimizations are
      // enabled. https://github.com/apple/swift-protobuf/issues/1034
      switch fieldNumber {
      case 1: try { try decoder.decodeSingularMessageField(value: &self._keyDesc) }()
      case 2: try { try decoder.decodeSingularBytesField(value: &self.singleTweak) }()
      case 3: try { try decoder.decodeSingularBytesField(value: &self.doubleTweak) }()
      case 4: try { try decoder.decodeSingularBytesField(value: &self.witnessScript) }()
      case 5: try { try decoder.decodeSingularMessageField(value: &self._output) }()
      case 7: try { try decoder.decodeSingularUInt32Field(value: &self.sighash) }()
      case 8: try { try decoder.decodeSingularInt32Field(value: &self.inputIndex) }()
      default: break
      }
    }
  }

  func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    if let v = self._keyDesc {
      try visitor.visitSingularMessageField(value: v, fieldNumber: 1)
    }
    if !self.singleTweak.isEmpty {
      try visitor.visitSingularBytesField(value: self.singleTweak, fieldNumber: 2)
    }
    if !self.doubleTweak.isEmpty {
      try visitor.visitSingularBytesField(value: self.doubleTweak, fieldNumber: 3)
    }
    if !self.witnessScript.isEmpty {
      try visitor.visitSingularBytesField(value: self.witnessScript, fieldNumber: 4)
    }
    if let v = self._output {
      try visitor.visitSingularMessageField(value: v, fieldNumber: 5)
    }
    if self.sighash != 0 {
      try visitor.visitSingularUInt32Field(value: self.sighash, fieldNumber: 7)
    }
    if self.inputIndex != 0 {
      try visitor.visitSingularInt32Field(value: self.inputIndex, fieldNumber: 8)
    }
    try unknownFields.traverse(visitor: &visitor)
  }

  static func ==(lhs: Signrpc_SignDescriptor, rhs: Signrpc_SignDescriptor) -> Bool {
    if lhs._keyDesc != rhs._keyDesc {return false}
    if lhs.singleTweak != rhs.singleTweak {return false}
    if lhs.doubleTweak != rhs.doubleTweak {return false}
    if lhs.witnessScript != rhs.witnessScript {return false}
    if lhs._output != rhs._output {return false}
    if lhs.sighash != rhs.sighash {return false}
    if lhs.inputIndex != rhs.inputIndex {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}

extension Signrpc_SignReq: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  static let protoMessageName: String = _protobuf_package + ".SignReq"
  static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .standard(proto: "raw_tx_bytes"),
    2: .standard(proto: "sign_descs"),
  ]

  mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      // The use of inline closures is to circumvent an issue where the compiler
      // allocates stack space for every case branch when no optimizations are
      // enabled. https://github.com/apple/swift-protobuf/issues/1034
      switch fieldNumber {
      case 1: try { try decoder.decodeSingularBytesField(value: &self.rawTxBytes) }()
      case 2: try { try decoder.decodeRepeatedMessageField(value: &self.signDescs) }()
      default: break
      }
    }
  }

  func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    if !self.rawTxBytes.isEmpty {
      try visitor.visitSingularBytesField(value: self.rawTxBytes, fieldNumber: 1)
    }
    if !self.signDescs.isEmpty {
      try visitor.visitRepeatedMessageField(value: self.signDescs, fieldNumber: 2)
    }
    try unknownFields.traverse(visitor: &visitor)
  }

  static func ==(lhs: Signrpc_SignReq, rhs: Signrpc_SignReq) -> Bool {
    if lhs.rawTxBytes != rhs.rawTxBytes {return false}
    if lhs.signDescs != rhs.signDescs {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}

extension Signrpc_SignResp: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  static let protoMessageName: String = _protobuf_package + ".SignResp"
  static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .standard(proto: "raw_sigs"),
  ]

  mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      // The use of inline closures is to circumvent an issue where the compiler
      // allocates stack space for every case branch when no optimizations are
      // enabled. https://github.com/apple/swift-protobuf/issues/1034
      switch fieldNumber {
      case 1: try { try decoder.decodeRepeatedBytesField(value: &self.rawSigs) }()
      default: break
      }
    }
  }

  func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    if !self.rawSigs.isEmpty {
      try visitor.visitRepeatedBytesField(value: self.rawSigs, fieldNumber: 1)
    }
    try unknownFields.traverse(visitor: &visitor)
  }

  static func ==(lhs: Signrpc_SignResp, rhs: Signrpc_SignResp) -> Bool {
    if lhs.rawSigs != rhs.rawSigs {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}

extension Signrpc_InputScript: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  static let protoMessageName: String = _protobuf_package + ".InputScript"
  static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .same(proto: "witness"),
    2: .standard(proto: "sig_script"),
  ]

  mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      // The use of inline closures is to circumvent an issue where the compiler
      // allocates stack space for every case branch when no optimizations are
      // enabled. https://github.com/apple/swift-protobuf/issues/1034
      switch fieldNumber {
      case 1: try { try decoder.decodeRepeatedBytesField(value: &self.witness) }()
      case 2: try { try decoder.decodeSingularBytesField(value: &self.sigScript) }()
      default: break
      }
    }
  }

  func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    if !self.witness.isEmpty {
      try visitor.visitRepeatedBytesField(value: self.witness, fieldNumber: 1)
    }
    if !self.sigScript.isEmpty {
      try visitor.visitSingularBytesField(value: self.sigScript, fieldNumber: 2)
    }
    try unknownFields.traverse(visitor: &visitor)
  }

  static func ==(lhs: Signrpc_InputScript, rhs: Signrpc_InputScript) -> Bool {
    if lhs.witness != rhs.witness {return false}
    if lhs.sigScript != rhs.sigScript {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}

extension Signrpc_InputScriptResp: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  static let protoMessageName: String = _protobuf_package + ".InputScriptResp"
  static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .standard(proto: "input_scripts"),
  ]

  mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      // The use of inline closures is to circumvent an issue where the compiler
      // allocates stack space for every case branch when no optimizations are
      // enabled. https://github.com/apple/swift-protobuf/issues/1034
      switch fieldNumber {
      case 1: try { try decoder.decodeRepeatedMessageField(value: &self.inputScripts) }()
      default: break
      }
    }
  }

  func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    if !self.inputScripts.isEmpty {
      try visitor.visitRepeatedMessageField(value: self.inputScripts, fieldNumber: 1)
    }
    try unknownFields.traverse(visitor: &visitor)
  }

  static func ==(lhs: Signrpc_InputScriptResp, rhs: Signrpc_InputScriptResp) -> Bool {
    if lhs.inputScripts != rhs.inputScripts {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}

extension Signrpc_SignMessageReq: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  static let protoMessageName: String = _protobuf_package + ".SignMessageReq"
  static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .same(proto: "msg"),
    2: .standard(proto: "key_loc"),
  ]

  mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      // The use of inline closures is to circumvent an issue where the compiler
      // allocates stack space for every case branch when no optimizations are
      // enabled. https://github.com/apple/swift-protobuf/issues/1034
      switch fieldNumber {
      case 1: try { try decoder.decodeSingularBytesField(value: &self.msg) }()
      case 2: try { try decoder.decodeSingularMessageField(value: &self._keyLoc) }()
      default: break
      }
    }
  }

  func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    if !self.msg.isEmpty {
      try visitor.visitSingularBytesField(value: self.msg, fieldNumber: 1)
    }
    if let v = self._keyLoc {
      try visitor.visitSingularMessageField(value: v, fieldNumber: 2)
    }
    try unknownFields.traverse(visitor: &visitor)
  }

  static func ==(lhs: Signrpc_SignMessageReq, rhs: Signrpc_SignMessageReq) -> Bool {
    if lhs.msg != rhs.msg {return false}
    if lhs._keyLoc != rhs._keyLoc {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}

extension Signrpc_SignMessageResp: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  static let protoMessageName: String = _protobuf_package + ".SignMessageResp"
  static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .same(proto: "signature"),
  ]

  mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      // The use of inline closures is to circumvent an issue where the compiler
      // allocates stack space for every case branch when no optimizations are
      // enabled. https://github.com/apple/swift-protobuf/issues/1034
      switch fieldNumber {
      case 1: try { try decoder.decodeSingularBytesField(value: &self.signature) }()
      default: break
      }
    }
  }

  func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    if !self.signature.isEmpty {
      try visitor.visitSingularBytesField(value: self.signature, fieldNumber: 1)
    }
    try unknownFields.traverse(visitor: &visitor)
  }

  static func ==(lhs: Signrpc_SignMessageResp, rhs: Signrpc_SignMessageResp) -> Bool {
    if lhs.signature != rhs.signature {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}

extension Signrpc_VerifyMessageReq: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  static let protoMessageName: String = _protobuf_package + ".VerifyMessageReq"
  static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .same(proto: "msg"),
    2: .same(proto: "signature"),
    3: .same(proto: "pubkey"),
  ]

  mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      // The use of inline closures is to circumvent an issue where the compiler
      // allocates stack space for every case branch when no optimizations are
      // enabled. https://github.com/apple/swift-protobuf/issues/1034
      switch fieldNumber {
      case 1: try { try decoder.decodeSingularBytesField(value: &self.msg) }()
      case 2: try { try decoder.decodeSingularBytesField(value: &self.signature) }()
      case 3: try { try decoder.decodeSingularBytesField(value: &self.pubkey) }()
      default: break
      }
    }
  }

  func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    if !self.msg.isEmpty {
      try visitor.visitSingularBytesField(value: self.msg, fieldNumber: 1)
    }
    if !self.signature.isEmpty {
      try visitor.visitSingularBytesField(value: self.signature, fieldNumber: 2)
    }
    if !self.pubkey.isEmpty {
      try visitor.visitSingularBytesField(value: self.pubkey, fieldNumber: 3)
    }
    try unknownFields.traverse(visitor: &visitor)
  }

  static func ==(lhs: Signrpc_VerifyMessageReq, rhs: Signrpc_VerifyMessageReq) -> Bool {
    if lhs.msg != rhs.msg {return false}
    if lhs.signature != rhs.signature {return false}
    if lhs.pubkey != rhs.pubkey {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}

extension Signrpc_VerifyMessageResp: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  static let protoMessageName: String = _protobuf_package + ".VerifyMessageResp"
  static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .same(proto: "valid"),
  ]

  mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      // The use of inline closures is to circumvent an issue where the compiler
      // allocates stack space for every case branch when no optimizations are
      // enabled. https://github.com/apple/swift-protobuf/issues/1034
      switch fieldNumber {
      case 1: try { try decoder.decodeSingularBoolField(value: &self.valid) }()
      default: break
      }
    }
  }

  func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    if self.valid != false {
      try visitor.visitSingularBoolField(value: self.valid, fieldNumber: 1)
    }
    try unknownFields.traverse(visitor: &visitor)
  }

  static func ==(lhs: Signrpc_VerifyMessageResp, rhs: Signrpc_VerifyMessageResp) -> Bool {
    if lhs.valid != rhs.valid {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}

extension Signrpc_SharedKeyRequest: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  static let protoMessageName: String = _protobuf_package + ".SharedKeyRequest"
  static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .standard(proto: "ephemeral_pubkey"),
    2: .standard(proto: "key_loc"),
    3: .standard(proto: "key_desc"),
  ]

  mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      // The use of inline closures is to circumvent an issue where the compiler
      // allocates stack space for every case branch when no optimizations are
      // enabled. https://github.com/apple/swift-protobuf/issues/1034
      switch fieldNumber {
      case 1: try { try decoder.decodeSingularBytesField(value: &self.ephemeralPubkey) }()
      case 2: try { try decoder.decodeSingularMessageField(value: &self._keyLoc) }()
      case 3: try { try decoder.decodeSingularMessageField(value: &self._keyDesc) }()
      default: break
      }
    }
  }

  func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    if !self.ephemeralPubkey.isEmpty {
      try visitor.visitSingularBytesField(value: self.ephemeralPubkey, fieldNumber: 1)
    }
    if let v = self._keyLoc {
      try visitor.visitSingularMessageField(value: v, fieldNumber: 2)
    }
    if let v = self._keyDesc {
      try visitor.visitSingularMessageField(value: v, fieldNumber: 3)
    }
    try unknownFields.traverse(visitor: &visitor)
  }

  static func ==(lhs: Signrpc_SharedKeyRequest, rhs: Signrpc_SharedKeyRequest) -> Bool {
    if lhs.ephemeralPubkey != rhs.ephemeralPubkey {return false}
    if lhs._keyLoc != rhs._keyLoc {return false}
    if lhs._keyDesc != rhs._keyDesc {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}

extension Signrpc_SharedKeyResponse: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  static let protoMessageName: String = _protobuf_package + ".SharedKeyResponse"
  static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .standard(proto: "shared_key"),
  ]

  mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      // The use of inline closures is to circumvent an issue where the compiler
      // allocates stack space for every case branch when no optimizations are
      // enabled. https://github.com/apple/swift-protobuf/issues/1034
      switch fieldNumber {
      case 1: try { try decoder.decodeSingularBytesField(value: &self.sharedKey) }()
      default: break
      }
    }
  }

  func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    if !self.sharedKey.isEmpty {
      try visitor.visitSingularBytesField(value: self.sharedKey, fieldNumber: 1)
    }
    try unknownFields.traverse(visitor: &visitor)
  }

  static func ==(lhs: Signrpc_SharedKeyResponse, rhs: Signrpc_SharedKeyResponse) -> Bool {
    if lhs.sharedKey != rhs.sharedKey {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}
