import SwiftCompilerPlugin
import SwiftDiagnostics
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

public struct UserDefaultsEntryMacro: AccessorMacro {
    public static func expansion(
        of node: AttributeSyntax,
        providingAccessorsOf declaration: some DeclSyntaxProtocol,
        in context: some MacroExpansionContext
    ) throws -> [AccessorDeclSyntax] {
        let variableDecl = try declaration.asVariable(at: node)

        guard
            let propertyName = variableDecl.bindings
                .first?
                .pattern
                .as(IdentifierPatternSyntax.self)?
                .identifier
                .text
        else {
            throw DiagnosticsError("Unknown error occurred.", at: node)
        }

        let keyName = node.argumentList?
            .first?
            .expression
            .as(StringLiteralExprSyntax.self)?
            .segments
            .toString()
            ?? propertyName

        guard
            let defaultValue = declaration
                .as(VariableDeclSyntax.self)?
                .bindings
                .first?
                .initializer?
                .value
        else {
            throw DiagnosticsError("Default value is needed.", at: node)
        }

        return [
            """
            get {
                userDefaults.typedValue(for: "\(raw: keyName)", defaultValue: \(raw: defaultValue))
            }
            """,
            """
            set {
                guard count != newValue else { return }

                userDefaults.set(typedValue: newValue, for: "\(raw: keyName)")
                notifyChange(for: "\(raw: propertyName)")
            }
            """,
        ]
    }
}
