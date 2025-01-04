# swift-observable-user-defaults

This library enables us to observe userDefaults easily.
It can be managed in Package.swift or Xcode project.

## Usage

In order to observe userDefaults, we have to define properties with `@UserDefaultsEntry` macro in an extension of `ObservableUserDefaults`.

```swift
import ObservableUserDefaults
import ObservableUserDefaultsMacros

extension ObservableUserDefaults {
    // If no argument is passed, the property name `count` is used as a userDefaults key name.
    @UserDefaultsEntry var count = 0

    // If a string is passed, it is used as a userDefaults key name.
    @UserDefaultsEntry("namedTitle") var title: String?
}
```

A view model is implemented like the following code:

```swift
import ObservableUserDefaults
import ObservableUserDefaultsMacros

// Attach `@ObservableWithUserDefaults` to an observed class, instead of `@Observation`.
// Note: APIs in Observation like `@ObservationTracked` and `@ObservationIgnored` still can be used.
@ObservableWithUserDefaults
@MainActor
final class ContentViewModel {
    // Attach `@UserDefaultsTracked` to a variable to track with userDefaults.
    @UserDefaultsTracked(\.count) var count = 0
    @UserDefaultsTracked(\.title) var title: String?

    // Attach `@ObservedUserDefaults` to a variable with type `ObservableUserDefaults`.
    @ObservedUserDefaults
    var observableUserDefaults: ObservableUserDefaults = .standard
}
```

If we want to observe a custom type with saving userDefaults, it is enough making the type conform to `UserDefaultsValueConvertible` protocol, like the following code:

```swift
extension CustomString: UserDefaultsValueConvertible {
    init(userDefaultsValue: String) {
        self = CustomString(userDefaultsValue)
    }

    var userDefaultsValue: String {
        self.string
    }
}

extension ObservableUserDefaults {
    @UserDefaultsEntry var customString = CustomString("")
}
```

## Quick start

Make sure that xcodegen has been installed, and run the following commands.

```
$ cd Example
$ xcodegen
$ open ObservableUserDefaultsExample.xcodeproj
```

You can run the example app by Xcode.

## License

This library is released under the MIT license. See [LICENSE](LICENSE) for details.

## TODO

- Create unit tests
- Add documentation comments
