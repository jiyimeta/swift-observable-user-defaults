import SwiftUI

struct IncrementRow: View {
    var label: String
    @Binding var count: Int
    var reset: () -> Void

    var body: some View {
        HStack(spacing: 0) {
            Text("\(label): ")
                .frame(width: 100, alignment: .trailing)
            Text("\(count)")
                .frame(width: 30, alignment: .leading)

            Button("+") {
                count += 1
            }
            .font(.headline)
            .frame(width: 20)

            Button("Reset", action: reset)
                .frame(width: 50, height: 0)
        }
    }
}
