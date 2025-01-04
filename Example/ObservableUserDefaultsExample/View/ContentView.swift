import ObservableUserDefaults
import ObservableUserDefaultsMacros
import SwiftUI

@ObservableWithUserDefaults
@MainActor
final class ContentViewModel {
    @UserDefaultsTracked(\.count) var count: Int
    @UserDefaultsTracked(\.fooCount) var bazCount: Int
    var localCount = 0
    @ObservationIgnored var ignoredCount = 0

    @UserDefaultsTracked(\.title) var title: String?

    // Dependency
    @ObservedUserDefaults
    var observableUserDefaults: ObservableUserDefaults = .standard

    @ObservationIgnored var childViewModel = ChildViewModel()

    func resetCount() {
        observableUserDefaults.resetCount()
    }

    func resetBazCount() {
        observableUserDefaults.resetFooCount()
    }

    func resetLocalCount() {
        localCount = 0
    }

    func resetIgnoredCount() {
        ignoredCount = 0
    }

    func resetUserDefaults() {
        observableUserDefaults.resetAll()
    }
}

struct ContentView: View {
    @State var viewModel = ContentViewModel()

    var body: some View {
        VStack {
            IncrementRow(label: "count", count: $viewModel.count, reset: viewModel.resetCount)
            IncrementRow(label: "baz", count: $viewModel.bazCount, reset: viewModel.resetBazCount)
            IncrementRow(label: "local", count: $viewModel.localCount, reset: viewModel.resetLocalCount)
            IncrementRow(label: "ignored", count: $viewModel.ignoredCount, reset: viewModel.resetIgnoredCount)

            RandomStringRow(string: $viewModel.title)

            Button("Reset userDefaults", action: viewModel.resetUserDefaults)
                .padding(.top, 12)

            Divider()

            ChildView(viewModel: viewModel.childViewModel)
        }
    }
}

#Preview {
    ContentView()
}
