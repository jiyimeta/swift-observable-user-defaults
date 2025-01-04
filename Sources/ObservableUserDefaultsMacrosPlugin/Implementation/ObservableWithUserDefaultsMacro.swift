import SwiftCompilerPlugin
import SwiftDiagnostics
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

public struct ObservableWithUserDefaultsMacro {}

extension ObservableWithUserDefaultsMacro: MemberMacro {
    public static func expansion(
        of node: AttributeSyntax,
        providingMembersOf declaration: some DeclGroupSyntax,
        in context: some MacroExpansionContext
    ) throws -> [DeclSyntax] {
        let className = try declaration.asClass(at: node).name

        return [
            """
            @ObservationIgnored private let _$observationRegistrar = Observation.ObservationRegistrar()
            """,
            """
            internal nonisolated func access<Member>(
                keyPath: KeyPath<\(raw: className), Member>
            ) {
                _$observationRegistrar.access(self, keyPath: keyPath)
            }
            """,
            """
            internal nonisolated func withMutation<Member, MutationResult>(
                keyPath: KeyPath<\(raw: className), Member>,
                _ mutation: () throws -> MutationResult
            ) rethrows -> MutationResult {
                try _$observationRegistrar.withMutation(of: self, keyPath: keyPath, mutation)
            }
            """,
        ]
    }
}

extension ObservableWithUserDefaultsMacro: MemberAttributeMacro {
    public static func expansion(
        of node: AttributeSyntax,
        attachedTo declaration: some DeclGroupSyntax,
        providingAttributesFor member: some DeclSyntaxProtocol,
        in context: some MacroExpansionContext
    ) throws -> [AttributeSyntax] {
        let className = try declaration.asClass(at: node).name.text

        guard
            let variableDecl = member.as(VariableDeclSyntax.self),
            !variableDecl.attributes
                .compactMap(\.attribute?.name)
                .contains(where: { ["ObservationIgnored", "ObservedUserDefaults"].contains($0) })
        else {
            return []
        }

        guard let keyPath = variableDecl
            .attributes
            .compactMap(\.attribute)
            .first(where: { $0.name == "UserDefaultsTracked" })?
            .argumentList?
            .first
        else {
            return ["@ObservationTracked"]
        }

        let observedUserDefaultsVariableDecls = declaration.memberBlock.members
            .compactMap { $0.decl.as(VariableDeclSyntax.self) }
            .filter { $0.attributes.compactMap(\.attribute?.name).contains("ObservedUserDefaults") }

        guard observedUserDefaultsVariableDecls.count == 1 else {
            throw DiagnosticsError("There must be just one variable with `@ObservedUserDefaults` macro.", at: node)
        }

        guard let observedUserDefaultsVariableName = observedUserDefaultsVariableDecls[0]
            .bindings
            .first?
            .pattern
            .as(IdentifierPatternSyntax.self)?
            .identifier
            .text
        else {
            throw DiagnosticsError("Unknown error occurred", at: node)
        }

        return [
            "@_UserDefaultsTracked(\\\(raw: className).\(raw: observedUserDefaultsVariableName), \(raw: keyPath))",
        ]
    }
}

extension ObservableWithUserDefaultsMacro: ExtensionMacro {
    public static func expansion(
        of node: AttributeSyntax,
        attachedTo declaration: some DeclGroupSyntax,
        providingExtensionsOf type: some TypeSyntaxProtocol,
        conformingTo protocols: [TypeSyntax],
        in context: some MacroExpansionContext
    ) throws -> [ExtensionDeclSyntax] {
        guard let typeName = declaration.as(ClassDeclSyntax.self)?.name else {
            throw DiagnosticsError("The type needs to be a class.", at: node)
        }

        let decl: DeclSyntax =
            """
            extension \(raw: typeName): Observable {}
            """

        guard let extensionDecl = decl.as(ExtensionDeclSyntax.self) else {
            return []
        }

        return [extensionDecl]
    }
}
