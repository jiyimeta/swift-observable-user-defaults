import SwiftSyntax

extension AttributeSyntax {
    var name: String? {
        attributeName.as(IdentifierTypeSyntax.self)?.name.text
    }

    var argumentList: LabeledExprListSyntax? {
        switch arguments {
        case let .argumentList(argumentList): argumentList
        default: nil
        }
    }
}
