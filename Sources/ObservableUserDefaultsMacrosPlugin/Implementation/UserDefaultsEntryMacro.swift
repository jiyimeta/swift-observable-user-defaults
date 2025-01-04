import SwiftCompilerPlugin
import SwiftDiagnostics
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

public struct UserDefaultsEntryMacro {}

extension UserDefaultsEntryMacro: AccessorMacro {
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

        guard let defaultValue = variableDecl.bindings.first?.defaultValue else {
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
                guard \(raw: propertyName) != newValue else { return }

                userDefaults.set(typedValue: newValue, for: "\(raw: keyName)")
                notifyChange(for: "\(raw: propertyName)")
            }
            """,
        ]
    }
}

extension UserDefaultsEntryMacro: PeerMacro {
    public static func expansion(
        of node: AttributeSyntax,
        providingPeersOf declaration: some DeclSyntaxProtocol,
        in context: some MacroExpansionContext
    ) throws -> [DeclSyntax] {
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

        return [
            """
            func reset\(raw: propertyName.capitalizingFirstLetter())() {
                userDefaults.removeObject(forKey: "\(raw: keyName)")
                notifyChange(for: "\(raw: propertyName)")
            }
            """,
        ]
    }
}

// MARK: - Private methods

extension PatternBindingSyntax {
    fileprivate var defaultValue: String? {
        if let explicitDefaultValue = initializer?
            .value
            .toString()
        {
            return explicitDefaultValue
        }

        if let type = typeAnnotation?.type,
           type.is(OptionalTypeSyntax.self)
        {
            return "nil"
        }

        return nil
    }
}
