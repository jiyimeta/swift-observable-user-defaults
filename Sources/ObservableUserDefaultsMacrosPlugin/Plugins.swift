import SwiftCompilerPlugin
import SwiftSyntaxMacros

@main
struct MyUtilityMacrosPlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
        UserDefaultsTrackedMacro.self,
        ObservedUserDefaultsMacro.self,
        UnderscoreUserDefaultsTrackedMacro.self,
        ObservableWithUserDefaultsMacro.self,
        UserDefaultsEntryMacro.self,
    ]
}
