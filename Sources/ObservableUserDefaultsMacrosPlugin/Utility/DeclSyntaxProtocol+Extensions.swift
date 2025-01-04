import SwiftDiagnostics
import SwiftSyntax

extension DeclSyntaxProtocol {
    func asVariable(at node: some SyntaxProtocol) throws -> VariableDeclSyntax {
        guard let variableDecl = self.as(VariableDeclSyntax.self) else {
            throw DiagnosticsError(
                "This macro can be attached only to variable declarations.",
                at: node
            )
        }

        return variableDecl
    }

    func asClass(at node: some SyntaxProtocol) throws -> ClassDeclSyntax {
        guard let classDecl = self.as(ClassDeclSyntax.self) else {
            throw DiagnosticsError(
                "This macro can be attached only to class declarations.",
                at: node
            )
        }

        return classDecl
    }
}
