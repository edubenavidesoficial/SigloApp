import SwiftUI
import CryptoKit

struct WelcomeView: View {
    @State private var navigateToHome = false
    @AppStorage("authToken") private var authToken: String = ""

    var body: some View {
        NavigationStack {
            ZStack {
                Color.white
                    .edgesIgnoringSafeArea(.all)

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
            .navigationDestination(isPresented: $navigateToHome) {
                HomeView()
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

        // Esperar 8 segundos antes de navegar
        try? await Task.sleep(nanoseconds: 8_000_000_000)
        navigateToHome = true
    }
}
