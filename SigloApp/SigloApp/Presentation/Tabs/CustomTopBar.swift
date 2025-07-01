import SwiftUI

struct CustomTopBar: View {
    let onBack: () -> Void

    var body: some View {
        HStack {
            Button(action: {
                onBack()
            }) {
                Image(systemName: "chevron.left")
                    .foregroundColor(.white)
                    .font(.system(size: 18, weight: .medium))
            }

            Text("NACIONAL")
                .foregroundColor(.white)
                .font(.system(size: 16, weight: .semibold))
                .padding(.leading, 4)

            Spacer()

            HStack(spacing: 24) {
                Button(action: {}) {
                    Image(systemName: "headphones")
                        .foregroundColor(.white)
                }
                Button(action: {}) {
                    Image(systemName: "square.and.arrow.up")
                        .foregroundColor(.white)
                }
                Button(action: {}) {
                    Image(systemName: "bookmark")
                        .foregroundColor(.white)
                }
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 12)
        .background(Color.black)
    }
}
