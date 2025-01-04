extension Dictionary {
    mutating func value(for key: Key, orSetting newValue: Value) -> Value {
        if let value = self[key] {
            return value
        } else {
            self[key] = newValue
            return newValue
        }
    }
}
