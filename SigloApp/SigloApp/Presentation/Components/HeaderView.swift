import SwiftUI

struct HeaderView: View {
    var showBack: Bool = true
    var isLogin: Bool = false
    var action: (() -> Void)? = nil

    @State private var showLogoutAlert = false

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                // Botón de retroceso o menú lateral
                if showBack {
                    Button(action: {
                        action?()
                    }) {
                        Image("chevronleft")
                            .resizable()
                            .frame(width: 30, height: 30)
                    }
                } else {
                    Button(action: {
                        // Acción para el menú lateral
                    }) {
                        Image(systemName: "line.horizontal.3")
                            .font(.title2)
                    }
                }

                Spacer()

                // Logo o título de la app
                Image("titulo")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 30)

                Spacer()

                // Opción de cerrar sesión si está logueado
                if showBack {
                    Button(action: {
                        showLogoutAlert = true
                    }) {
                        Image(systemName: "person.circle.fill")
                            .resizable()
                            .frame(width: 24, height: 24)
                            .foregroundColor(.black)
                    }
                    .confirmationDialog("¿Quieres cerrar sesión?", isPresented: $showLogoutAlert, titleVisibility: .visible) {
                        Button("Cerrar sesión", role: .destructive) {
                            logout()
                        }
                        Button("Cancelar", role: .cancel) {}
                    }
                } else {
                    // Icono de búsqueda si no está logueado
                    Button(action: {
                        // Acción de búsqueda
                    }) {
                        Image(systemName: "magnifyingglass")
                            .font(.title2)
                    }
                }
            }
            .padding(.horizontal)
            .padding(.top, 15)

            Divider()
                .frame(height: 0.5)
                .background(Color.black)
        }
    }

    func logout() {
        UserDefaults.standard.set(false, forKey: "isLoggedIn") // Marcar como deslogueado
        print("🔴 Sesión cerrada")
    }
}
