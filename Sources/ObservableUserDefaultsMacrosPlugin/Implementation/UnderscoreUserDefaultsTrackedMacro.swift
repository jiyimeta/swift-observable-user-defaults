import SwiftCompilerPlugin
import SwiftDiagnostics
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

public struct UnderscoreUserDefaultsTrackedMacro {}

extension UnderscoreUserDefaultsTrackedMacro: PeerMacro {
    public static func expansion(
        of node: AttributeSyntax,
        providingPeersOf declaration: some DeclSyntaxProtocol,
        in context: some MacroExpansionContext
    ) throws -> [DeclSyntax] {
        guard
            let name = declaration.as(VariableDeclSyntax.self)?
                .bindings
                .first?
                .pattern
                .as(IdentifierPatternSyntax.self)?
                .identifier
                .text
        else {
            throw DiagnosticsError.unknown(at: node)
        }

        return [
            """
            private var _observationTask_\(raw: name): Task<Void, Never>?
            """,
        ]
    }
}

extension UnderscoreUserDefaultsTrackedMacro: AccessorMacro {
    public static func expansion(
        of node: AttributeSyntax,
        providingAccessorsOf declaration: some DeclSyntaxProtocol,
        in context: some MacroExpansionContext
    ) throws -> [AccessorDeclSyntax] {
        guard
            let name = declaration.as(VariableDeclSyntax.self)?
                .bindings
                .first?
                .pattern
                .as(IdentifierPatternSyntax.self)?
                .identifier
                .text,
                let observedUserDefaultsVariableName = node.argumentList?
                    .first?
                    .expression
                    .as(KeyPathExprSyntax.self)?
                    .components
                    .toString()
                    .removingPrefix("."),
                    let propertyKeyPathComponents = node.argumentList?
                        .last?
                        .expression
                        .as(KeyPathExprSyntax.self)?
                        .components
        else {
            throw DiagnosticsError.unknown(at: node)
        }

        let propertyName = propertyKeyPathComponents.toString().removingPrefix(".")

        return [
            """
            get {
                if _observationTask_\(raw: name) == nil {
                    _observationTask_\(raw: name) = Task {
                        for await _ in \(raw: observedUserDefaultsVariableName).stream(for: "\(raw: propertyName)") {
                            withMutation(keyPath: \\.\(raw: name)) {}
                        }
                    }
                }
                access(keyPath: \\.\(raw: name))

                return \(raw: observedUserDefaultsVariableName)\(raw: propertyKeyPathComponents)
            }
            """,
            """
            set {
                \(raw: observedUserDefaultsVariableName)\(raw: propertyKeyPathComponents) = newValue
            }
            """,
        ]
    }
}
