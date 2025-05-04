import SwiftUI

struct WelcomeView: View {
    @Binding var navigateToPromo: Bool
    @Binding var authToken: String

    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()
            Image("inicio")
                .resizable()
                .scaledToFit()
                .frame(width: 200, height: 200)
        }
        .onAppear {
            Task {
                await loginAndNavigate()
            }
        }
    }

    func loginAndNavigate() async {
        do {
            _ = try await LoginService.login(username: "", password: "")
            if let token = TokenService.shared.getStoredToken() {
                authToken = token
                print("🔐 Token obtenido y guardado: \(token)")
            } else {
                print("❌ No se obtuvo el token")
            }
        } catch {
            print("❌ Error obteniendo: \(error)")
        }

        // Esto se usará si quieres cambiar a promo antes del delay central
        try? await Task.sleep(nanoseconds: 8_000_000_000)
        navigateToPromo = true
    }
}
