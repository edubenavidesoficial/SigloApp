import SwiftUI

struct PromoView: View {
    @Binding var navigateToHome: Bool
    @State private var isAnimating = false

    var body: some View {
        VStack {
            Spacer()

            Image(systemName: "globe")
                .resizable()
                .frame(width: 20, height: 20)
                .rotationEffect(.degrees(isAnimating ? 360 : 0))
                .animation(.linear(duration: 1).repeatForever(autoreverses: false), value: isAnimating)
                .foregroundColor(.gray)

            Text("5687735147948295/3338923985")
                .font(.subheadline)
                .padding()

            Spacer()
        }
        .onAppear {
            isAnimating = true
            Task {
                try? await Task.sleep(nanoseconds: 4_000_000_000)
                navigateToHome = true
            }
        }
    }
}
