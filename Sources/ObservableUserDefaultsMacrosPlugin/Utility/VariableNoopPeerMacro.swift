import SwiftSyntax
import SwiftSyntaxMacros

public protocol VariableNoopPeerMacro: PeerMacro {}

extension VariableNoopPeerMacro {
    public static func expansion(
        of node: AttributeSyntax,
        providingPeersOf declaration: some DeclSyntaxProtocol,
        in context: some MacroExpansionContext
    ) throws -> [DeclSyntax] {
        _ = try declaration.asVariable(at: node)

        return []
    }
}
