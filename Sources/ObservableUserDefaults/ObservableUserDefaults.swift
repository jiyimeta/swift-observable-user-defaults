import Foundation

public final class ObservableUserDefaults {
    private var distributors: [String: AsyncStreamDistributor<Void>] = [:]

    public let userDefaults: UserDefaults

    public init(userDefaults: UserDefaults) {
        self.userDefaults = userDefaults
    }

    public func stream(for key: String) -> AsyncStream<Void> {
        distributors
            .value(for: key, orSetting: .init())
            .makeStream()
    }

    public func notifyChange(for key: String) {
        distributors[key]?.yield(())
    }
}

extension ObservableUserDefaults {
    public static let standard = ObservableUserDefaults(userDefaults: .standard)
}
