import ObservableUserDefaults
import ObservableUserDefaultsMacros
import SwiftUI

@ObservableWithUserDefaults
@MainActor
final class ChildViewModel {
    @UserDefaultsTracked(\.count) var count: Int
    @UserDefaultsTracked(\.fooCount) var quxCount: Int
    var localCount = 0
    @ObservationIgnored var ignoredCount = 0

    @UserDefaultsTracked(\.title) var title: String?

    // Dependency
    @ObservedUserDefaults
    var fooObservableUserDefaults: ObservableUserDefaults = .standard

    func resetCount() {
        fooObservableUserDefaults.resetCount()
    }

    func resetQuxCount() {
        fooObservableUserDefaults.resetFooCount()
    }

    func resetLocalCount() {
        localCount = 0
    }

    func resetIgnoredCount() {
        ignoredCount = 0
    }
}

struct ChildView: View {
    @State var viewModel: ChildViewModel

    var body: some View {
        Text("Child")
            .font(.headline)
            .padding()

        IncrementRow(label: "count", count: $viewModel.count, reset: viewModel.resetCount)
        IncrementRow(label: "qux", count: $viewModel.quxCount, reset: viewModel.resetQuxCount)
        IncrementRow(label: "local", count: $viewModel.localCount, reset: viewModel.resetLocalCount)
        IncrementRow(label: "ignored", count: $viewModel.ignoredCount, reset: viewModel.resetIgnoredCount)

        RandomStringRow(string: $viewModel.title)
    }
}
