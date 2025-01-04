import SwiftUI

struct RandomStringRow: View {
    @Binding var string: String?

    var body: some View {
        VStack(spacing: 1) {
            Text(string ?? "nil")

            HStack {
                Button("Generate") {
                    string = UUID().uuidString
                }
                Button("Delete") {
                    string = nil
                }
            }
        }
    }
}
