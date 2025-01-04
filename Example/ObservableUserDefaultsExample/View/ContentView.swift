import ObservableUserDefaults
import ObservableUserDefaultsMacros
import SwiftUI

@ObservableWithUserDefaults
@MainActor
final class ContentViewModel {
    @UserDefaultsTracked(\.count) var count = 0
    @UserDefaultsTracked(\.fooCount) var bazCount = 0
    var localCount = 0
    @ObservationIgnored var ignoredCount = 0

    @UserDefaultsTracked(\.title) var title: String?

    // Dependency
    @ObservedUserDefaults
    var observableUserDefaults: ObservableUserDefaults = .standard

    @ObservationIgnored var childViewModel = ChildViewModel()
}

struct ContentView: View {
    @State var viewModel = ContentViewModel()

    var body: some View {
        VStack {
            IncrementRow(label: "count", count: $viewModel.count)
            IncrementRow(label: "baz", count: $viewModel.bazCount)
            IncrementRow(label: "local", count: $viewModel.localCount)
            IncrementRow(label: "ignored", count: $viewModel.ignoredCount)

            RandomStringRow(string: $viewModel.title)

            Divider()

            ChildView(viewModel: viewModel.childViewModel)
        }
    }
}

#Preview {
    ContentView()
}
