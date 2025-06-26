import SwiftUI

struct HeaderView: View {
    @Binding var selectedOption: MenuOption?
    @Binding var isMenuOpen: Bool
    var isLoggedIn: Bool
    var showBack: Bool = true
    var action: (() -> Void)? = nil

    @State private var showMenu = false
    @State private var showLogoutAlert = false
    @State private var isSearchViewPresented = false
    @State private var mostrarSectionsFullscreen = false  // <-- aquí

    var body: some View {
        ZStack(alignment: .leading) {
            VStack(spacing: 0) {
                HStack {
                    Button(action: {
                        if selectedOption != nil {
                            selectedOption = nil
                        } else {
                            // En vez de navegar push, presentamos fullscreen
                            mostrarSectionsFullscreen = true
                        }
                    }) {
                        Image(systemName: selectedOption != nil ? "chevron.left" : "line.horizontal.3")
                            .imageScale(.large)
                    }

                    Spacer()

                    Image("titulo")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 30)

                    Spacer()

                    Button(action: {
                        isSearchViewPresented = true
                    }) {
                        Image(systemName: "magnifyingglass")
                            .font(.title2)
                            .foregroundColor(.black)
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

            if isMenuOpen {
                SideMenuView(selectedOption: $selectedOption, isMenuOpen: $isMenuOpen)
                    .frame(width: 250)
                    .transition(.move(edge: .leading))
                    .zIndex(2)
            }
        }
        // Presentación fullscreen de SectionsView
        .fullScreenCover(isPresented: $mostrarSectionsFullscreen) {
            SectionsView()
        }
        // Navegación a búsqueda con NavigationLink como antes
        .background(
            NavigationLink(
                destination: SearchFrontView(),
                isActive: $isSearchViewPresented,
                label: { EmptyView() }
            )
            .hidden()
        )
    }

    func logout() {
        UserDefaults.standard.set(false, forKey: "isLoggedIn")
        print("🔴 Sesión cerrada")
    }
}
