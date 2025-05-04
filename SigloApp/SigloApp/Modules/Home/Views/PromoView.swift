import SwiftUI

struct PromoView: View {
    @Binding var navigateToHome: Bool

    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()
            Image("promo")
            
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
        }
        .onAppear {
            Task {
                try? await Task.sleep(nanoseconds: 4_000_000_000)
                navigateToHome = true
            }
        }
    }
}
