import Foundation
import ObservableUserDefaults

@attached(peer)
public macro ObservedUserDefaults() = #externalMacro(
    module: "ObservableUserDefaultsMacrosPlugin",
    type: "ObservedUserDefaultsMacro"
)

@attached(peer)
public macro UserDefaultsTracked<T>(
    _ keyPath: WritableKeyPath<ObservableUserDefaults, T>
) = #externalMacro(
    module: "ObservableUserDefaultsMacrosPlugin",
    type: "UserDefaultsTrackedMacro"
)

@attached(accessor)
@attached(peer, names: prefixed(_observationTask_))
public macro _UserDefaultsTracked<Parent, T>(
    _ observableUserDefaultsKeyPath: KeyPath<Parent, ObservableUserDefaults>,
    _ keyPath: WritableKeyPath<ObservableUserDefaults, T>
) = #externalMacro(
    module: "ObservableUserDefaultsMacrosPlugin",
    type: "UnderscoreUserDefaultsTrackedMacro"
)

@attached(
    member,
    names: named(_$observationRegistrar),
    named(access),
    named(withMutation)
)
@attached(memberAttribute)
@attached(extension, conformances: Observable)
public macro ObservableWithUserDefaults() = #externalMacro(
    module: "ObservableUserDefaultsMacrosPlugin",
    type: "ObservableWithUserDefaultsMacro"
)

@attached(accessor)
public macro UserDefaultsEntry(_ key: String? = nil) = #externalMacro(
    module: "ObservableUserDefaultsMacrosPlugin",
    type: "UserDefaultsEntryMacro"
)
