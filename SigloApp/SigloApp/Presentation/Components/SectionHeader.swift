import SwiftUI

struct SectionHeader: View {
    let title: String

    var body: some View {
        HStack {
            Text(title.uppercased())
                .font(.footnote)
                .foregroundColor(.gray)
            Spacer()
        }
    }
}
