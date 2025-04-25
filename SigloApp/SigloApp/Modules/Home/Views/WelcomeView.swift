import SwiftUI
import CryptoKit

struct WelcomeView: View {
    @State private var navigateToHome = false
    @AppStorage("authToken") private var authToken: String = ""
    
    // Definir correoHash y passwordHash
    let correoHash = "fd342f795271570137b05f4dc763fb08" // Correo demo hasheado
    let passwordHash = "5f4dcc3b5aa765d61d8327deb882cf99" // Contraseña demo hasheada (por ejemplo: "password")

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
                    do {
                        print("Iniciando proceso de login...")
                        // Realiza el login y usa el valor de retorno
                        let user = try await LoginService.login(username: correoHash, password: passwordHash)
                        
                        // Ahora puedes usar `user` si es necesario
                        print("Login exitoso para el usuario: \(user.nombre) \(user.apellidos)")
                        
                        // Guardar el token en el almacenamiento
                        if let token = TokenService.shared.getStoredToken() {
                            authToken = token
                            print("🔐 Token obtenido y guardado: \(token)")
                        } else {
                            print("❌ No se obtuvo el token")
                        }

                    } catch {
                        print("❌ Error obteniendo el token o realizando el login: \(error)")
                    }

                }

                // Navegar a HomeView después de 8 segundos
                DispatchQueue.main.asyncAfter(deadline: .now() + 8) {
                    print("Navegando a HomeView...")
                    self.navigateToHome = true
                }
            }
            .navigationDestination(isPresented: $navigateToHome) {
                HomeView()
            }
        }
    }
}
