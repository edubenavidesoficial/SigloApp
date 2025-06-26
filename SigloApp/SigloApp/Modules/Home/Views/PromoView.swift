import SwiftUI

struct PromoView: View {
    @Binding var navigateToHome: Bool
    @State private var isAnimating = false

    var body: some View {
        VStack {
            Spacer()

            Image(systemName: "arrow.2.circlepath.circle")
                .resizable()
                .frame(width: 80, height: 80)
                .rotationEffect(.degrees(isAnimating ? 360 : 0))
                .animation(.linear(duration: 1).repeatForever(autoreverses: false), value: isAnimating)
                .foregroundColor(.gray)

            Text("Cargando promociones...")
                .font(.headline)
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
