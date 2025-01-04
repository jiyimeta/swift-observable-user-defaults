import ObservableUserDefaults
import ObservableUserDefaultsMacros
import SwiftUI

@ObservableWithUserDefaults
@MainActor
final class ChildViewModel {
    @UserDefaultsTracked(\.count) var count = 0
    @UserDefaultsTracked(\.fooCount) var quxCount = 0
    var localCount = 0
    @ObservationIgnored var ignoredCount = 0

    // Dependency
    @ObservedUserDefaults
    var fooObservableUserDefaults: ObservableUserDefaults = .standard
}

struct ChildView: View {
    @State var viewModel: ChildViewModel

    var body: some View {
        Text("Child")
            .font(.headline)
            .padding()
        IncrementRow(label: "count", count: $viewModel.count)
        IncrementRow(label: "qux", count: $viewModel.quxCount)
        IncrementRow(label: "local", count: $viewModel.localCount)
        IncrementRow(label: "ignored", count: $viewModel.ignoredCount)
    }
}
