import SwiftUI

struct HeaderView: View {
    @Binding var selectedOption: MenuOption?
    @Binding var isMenuOpen: Bool
    var isLoggedIn: Bool // Determina si el usuario está logueado
    var showBack: Bool = true
    var action: (() -> Void)? = nil

    @State private var showMenu = false
    @State private var showLogoutAlert = false
    @State private var isSearchViewPresented = false // Para presentar la SearchView

    var body: some View {
        ZStack(alignment: .leading) {
            // Contenido principal
            VStack(spacing: 0) {
                HStack {
                    Button(action: {
                        if selectedOption != nil {
                            selectedOption = nil // Volver atrás
                        } else {
                            isMenuOpen.toggle()
                        }
                    }) {
                        Image(systemName: selectedOption != nil ? "chevron.left" : "line.horizontal.3")
                            .imageScale(.large)
                    }

                    Spacer()

                    // Logo
                    Image("titulo")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 30)

                    Spacer()

                    // Dependiendo del estado de login, mostramos un botón u otro
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
                            isSearchViewPresented = true
                        }) {
                            Image(systemName: "magnifyingglass")
                                .font(.title2)
                                .foregroundColor(.black)
                        }

                        // NavigationLink oculto que navega cuando isSearchViewPresented es true
                        NavigationLink(
                            destination: SearchView(),
                            isActive: $isSearchViewPresented,
                            label: {
                                EmptyView() // No muestra nada
                            })
                            .hidden()
                    }
                }
                .padding(.horizontal)
                .padding(.top, 15)

                Divider()
                    .frame(height: 0.5)
                    .background(Color.black)
            }
            .blur(radius: isMenuOpen ? 8 : 0)
            .disabled(isMenuOpen)

            if isMenuOpen {
                Color.black.opacity(0.4)
                    .edgesIgnoringSafeArea(.all)
                    .onTapGesture {
                        withAnimation {
                            isMenuOpen = false
                        }
                    }
                    .zIndex(1)
            }

            // Menú lateral
            if isMenuOpen {
                SideMenuView(selectedOption: $selectedOption, isMenuOpen: $isMenuOpen)
                    .frame(width: 250)
                    .transition(.move(edge: .leading))
                    .zIndex(2)
            }

            // Este código ahora es gestionado por el NavigationView principal
        }
    }

    func logout() {
        UserDefaults.standard.set(false, forKey: "isLoggedIn")
        print("🔴 Sesión cerrada")
    }
}
