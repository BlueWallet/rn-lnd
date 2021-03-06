// DO NOT EDIT.
// swift-format-ignore-file
//
// Generated by the Swift generator plugin for the protocol buffer compiler.
// Source: lnclipb/lncli.proto
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

struct Lnclipb_VersionResponse {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  /// The version information for lncli.
  var lncli: Verrpc_Version {
    get {return _storage._lncli ?? Verrpc_Version()}
    set {_uniqueStorage()._lncli = newValue}
  }
  /// Returns true if `lncli` has been explicitly set.
  var hasLncli: Bool {return _storage._lncli != nil}
  /// Clears the value of `lncli`. Subsequent reads from it will return its default value.
  mutating func clearLncli() {_uniqueStorage()._lncli = nil}

  /// The version information for lnd.
  var lnd: Verrpc_Version {
    get {return _storage._lnd ?? Verrpc_Version()}
    set {_uniqueStorage()._lnd = newValue}
  }
  /// Returns true if `lnd` has been explicitly set.
  var hasLnd: Bool {return _storage._lnd != nil}
  /// Clears the value of `lnd`. Subsequent reads from it will return its default value.
  mutating func clearLnd() {_uniqueStorage()._lnd = nil}

  var unknownFields = SwiftProtobuf.UnknownStorage()

  init() {}

  fileprivate var _storage = _StorageClass.defaultInstance
}

// MARK: - Code below here is support for the SwiftProtobuf runtime.

fileprivate let _protobuf_package = "lnclipb"

extension Lnclipb_VersionResponse: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  static let protoMessageName: String = _protobuf_package + ".VersionResponse"
  static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .same(proto: "lncli"),
    2: .same(proto: "lnd"),
  ]

  fileprivate class _StorageClass {
    var _lncli: Verrpc_Version? = nil
    var _lnd: Verrpc_Version? = nil

    static let defaultInstance = _StorageClass()

    private init() {}

    init(copying source: _StorageClass) {
      _lncli = source._lncli
      _lnd = source._lnd
    }
  }

  fileprivate mutating func _uniqueStorage() -> _StorageClass {
    if !isKnownUniquelyReferenced(&_storage) {
      _storage = _StorageClass(copying: _storage)
    }
    return _storage
  }

  mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    _ = _uniqueStorage()
    try withExtendedLifetime(_storage) { (_storage: _StorageClass) in
      while let fieldNumber = try decoder.nextFieldNumber() {
        // The use of inline closures is to circumvent an issue where the compiler
        // allocates stack space for every case branch when no optimizations are
        // enabled. https://github.com/apple/swift-protobuf/issues/1034
        switch fieldNumber {
        case 1: try { try decoder.decodeSingularMessageField(value: &_storage._lncli) }()
        case 2: try { try decoder.decodeSingularMessageField(value: &_storage._lnd) }()
        default: break
        }
      }
    }
  }

  func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    try withExtendedLifetime(_storage) { (_storage: _StorageClass) in
      if let v = _storage._lncli {
        try visitor.visitSingularMessageField(value: v, fieldNumber: 1)
      }
      if let v = _storage._lnd {
        try visitor.visitSingularMessageField(value: v, fieldNumber: 2)
      }
    }
    try unknownFields.traverse(visitor: &visitor)
  }

  static func ==(lhs: Lnclipb_VersionResponse, rhs: Lnclipb_VersionResponse) -> Bool {
    if lhs._storage !== rhs._storage {
      let storagesAreEqual: Bool = withExtendedLifetime((lhs._storage, rhs._storage)) { (_args: (_StorageClass, _StorageClass)) in
        let _storage = _args.0
        let rhs_storage = _args.1
        if _storage._lncli != rhs_storage._lncli {return false}
        if _storage._lnd != rhs_storage._lnd {return false}
        return true
      }
      if !storagesAreEqual {return false}
    }
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}
