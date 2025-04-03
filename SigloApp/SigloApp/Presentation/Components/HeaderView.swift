import SwiftUI

struct HeaderView: View {
    var isLoggedIn: Bool // Determina si el usuario está logueado
    var showBack: Bool = true
    var action: (() -> Void)? = nil
    
    @State private var showMenu = false
    @State private var showLogoutAlert = false

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                // Botón de menú
                Button(action: {
                    showMenu.toggle()
                }) {
                    Image(systemName: "line.horizontal.3")
                        .font(.title2)
                        .foregroundColor(.black)
                }

                Spacer()

                // Logo de la app
                Image("titulo")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 30)

                Spacer()

                // Si está logueado, muestra el icono de cerrar sesión
                if isLoggedIn {
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
                    }
                } else {
                    // Si no está logueado, muestra el icono de búsqueda
                    Button(action: {
                        // Acción de búsqueda
                    }) {
                        Image(systemName: "magnifyingglass")
                            .font(.title2)
                            .foregroundColor(.black)
                    }
                }
            }
            .padding(.horizontal)
            .padding(.top, 15)

            Divider()
                .frame(height: 0.5)
                .background(Color.black)
        }
        .sheet(isPresented: $showMenu) {
            SideMenuView()
        }
    }

    func logout() {
        UserDefaults.standard.set(false, forKey: "isLoggedIn") // Marcar como deslogueado
        print("🔴 Sesión cerrada")
    }
}
