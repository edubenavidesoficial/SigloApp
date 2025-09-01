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

            // Banner de Google Ads
            //BannerAdView(adUnitID: "ca-app-pub-5687735147948295/3338923985")
                .frame(width: 320, height: 50)

            Spacer()
        }
        .onAppear {
            isAnimating = true
            Task {
                try? await Task.sleep(nanoseconds: 4_000_000_000) // 4 segundos
                navigateToHome = true
            }
        }
    }
}
