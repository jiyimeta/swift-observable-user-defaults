import SwiftDiagnostics
import SwiftSyntax
import SwiftSyntaxMacros

extension DiagnosticsError {
    init(
        _ message: String,
        at node: some SyntaxProtocol
    ) {
        self.init(
            diagnostics: [
                Diagnostic(
                    node: node,
                    message: MacroExpansionErrorMessage(message)
                ),
            ]
        )
    }

    static func unknown(at node: some SyntaxProtocol) -> DiagnosticsError {
        DiagnosticsError("Unknown error occurred.", at: node)
    }
}
