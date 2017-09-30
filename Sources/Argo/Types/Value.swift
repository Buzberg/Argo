import Foundation

/// A type safe representation of a weakly typed object.
public enum Value {
    case object([String: Value])
    case array([Value])
    case string(String)
    case number(NSNumber)
    case bool(Bool)
    case null
}

public extension Value {
    /**
     Transform an `Any` instance into `Value`.

     This is used to move from a loosely typed object (like those returned from
     `NSJSONSerialization`) to the strongly typed `Value` tree structure.

     - parameter value: A loosely typed object
     */
    init(_ value: Any) {
        switch value {

        case let v as [Any]:
            self = .array(v.map(Value.init))

        case let v as [String: Any]:
            self = .object(v.map(Value.init))

        case let v as String:
            self = .string(v)

        case let v as NSNumber:
            if v.isBool {
                self = .bool(v.boolValue)
            } else {
                self = .number(v)
            }

        default:
            self = .null
        }
    }
}

extension Value: Decodable {
    /**
     Decode `Value` into `Decoded<Value>`.

     This simply wraps the provided `Value` in `.Success`. This is useful because
     it means we can use `Value`s with the `<|` family of operators to pull
     out sub-keys.

     - parameter value: The `Value` to decode

     - returns: The provided `Value` wrapped in `.Success`
     */
    public static func decode(_ value: Value) -> Decoded<Value> {
        return pure(value)
    }
}

extension Value: CustomStringConvertible {
    public var description: String {
        switch self {
        case let .string(v): return "String(\(v))"
        case let .number(v): return "Number(\(v))"
        case let .bool(v): return "Bool(\(v))"
        case let .array(a): return "Array(\(a.description))"
        case let .object(o): return "Object(\(o.description))"
        case .null: return "Null"
        }
    }
}

extension Value: Equatable {}

public func == (lhs: Value, rhs: Value) -> Bool {
    switch (lhs, rhs) {
    case let (.string(l), .string(r)): return l == r
    case let (.number(l), .number(r)): return l == r
    case let (.bool(l), .bool(r)): return l == r
    case let (.array(l), .array(r)): return l == r
    case let (.object(l), .object(r)): return l == r
    case (.null, .null): return true
    default: return false
    }
}

/// MARK: Deprecations

extension Value {
    @available(*, deprecated: 3.0, renamed: "init")
    static func parse(_ json: Any) -> Value {
        return Value(json)
    }
}
