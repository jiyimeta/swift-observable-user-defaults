import SwiftSyntax

extension AttributeListSyntax.Element {
    var attribute: AttributeSyntax? {
        switch self {
        case let .attribute(attribute): attribute
        case .ifConfigDecl: nil
        }
    }
}
