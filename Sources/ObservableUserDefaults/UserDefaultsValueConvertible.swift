import Foundation

public protocol UserDefaultsValueConvertible {
    associatedtype UserDefaultsValue

    init(userDefaultsValue: UserDefaultsValue)
    var userDefaultsValue: UserDefaultsValue { get }
}

extension UserDefaults {
    public func typedValue<T: UserDefaultsValueConvertible>(for key: String, defaultValue: T) -> T {
        T(userDefaultsValue: value(forKey: key) as? T.UserDefaultsValue ?? defaultValue.userDefaultsValue)
    }

    public func set(typedValue: some UserDefaultsValueConvertible, for key: String) {
        set(typedValue.userDefaultsValue, forKey: key)
    }

    public func set(typedValue: (some UserDefaultsValueConvertible)?, for key: String) {
        if let typedValue {
            set(typedValue.userDefaultsValue, forKey: key)
        } else {
            removeObject(forKey: key)
        }
    }
}

// MARK: - Conformances of primitive types

extension UserDefaultsValueConvertible where UserDefaultsValue == Self {
    public init(userDefaultsValue: Self) {
        self = userDefaultsValue
    }

    public var userDefaultsValue: Self {
        self
    }
}

extension Bool: UserDefaultsValueConvertible {
    public typealias UserDefaultsValue = Bool
}

extension Int: UserDefaultsValueConvertible {
    public typealias UserDefaultsValue = Int
}

extension String: UserDefaultsValueConvertible {
    public typealias UserDefaultsValue = String
}

extension Float: UserDefaultsValueConvertible {
    public typealias UserDefaultsValue = Float
}

extension Double: UserDefaultsValueConvertible {
    public typealias UserDefaultsValue = Double
}

extension Data: UserDefaultsValueConvertible {
    public typealias UserDefaultsValue = Data
}

extension Array: UserDefaultsValueConvertible where Element: UserDefaultsValueConvertible {
    public init(userDefaultsValue: [Element.UserDefaultsValue]) {
        self = userDefaultsValue.map(Element.init(userDefaultsValue:))
    }

    public var userDefaultsValue: [Element.UserDefaultsValue] {
        map(\.userDefaultsValue)
    }
}

extension Dictionary: UserDefaultsValueConvertible where Key == String, Value: UserDefaultsValueConvertible {
    public init(userDefaultsValue: [Key: Value.UserDefaultsValue]) {
        self = userDefaultsValue.mapValues(Value.init(userDefaultsValue:))
    }

    public var userDefaultsValue: [Key: Value.UserDefaultsValue] {
        mapValues(\.userDefaultsValue)
    }
}

extension Optional: UserDefaultsValueConvertible where Wrapped: UserDefaultsValueConvertible {
    public init(userDefaultsValue: Wrapped.UserDefaultsValue?) {
        self = userDefaultsValue.map(Wrapped.init(userDefaultsValue:))
    }

    public var userDefaultsValue: Wrapped.UserDefaultsValue? {
        self?.userDefaultsValue
    }
}

// MARK: - Conformance of other basic types

extension CGFloat: UserDefaultsValueConvertible {
    public init(userDefaultsValue: Double) {
        self = CGFloat(userDefaultsValue)
    }

    public var userDefaultsValue: Double {
        Double(self)
    }
}
