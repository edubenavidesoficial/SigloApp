import SwiftUI

struct WriteHeaderView: View {
    var nombreSeccion: String
    @Binding var selectedOption: MenuOption?
    @Binding var isMenuOpen: Bool
    var isLoggedIn: Bool
    var showBack: Bool = true
    var action: (() -> Void)? = nil

    @State private var showMenu = false
    @State private var showLogoutAlert = false
    @State private var isSearchViewPresented = false
    @State private var mostrarSectionsFullscreen = false

    var body: some View {
        ZStack(alignment: .leading) {
            VStack(spacing: 0) {
                HStack {
                    // Menú o volver
                    Button(action: {
                        if selectedOption != nil {
                            selectedOption = nil
                        } else {
                            mostrarSectionsFullscreen = true
                        }
                    }) {
                        Image(systemName: selectedOption != nil ? "chevron.left" : "line.horizontal.3")
                            .imageScale(.large)
                            .foregroundColor(.white)
                            .shadow(color: .black, radius: 1, x: 0.5, y: 0.5)
                    }

                    // Centro con título e íconos
                    HStack(spacing: 8) {
                        Image(systemName: "chevron.left")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 15, height: 15)
                            .foregroundColor(.white)
                            .shadow(color: .black, radius: 1, x: 0.5, y: 0.5)

                        Image("ico_siglo")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 20, height: 20)

                        Text(nombreSeccion.uppercased())
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.white)
                            .shadow(color: .black, radius: 1, x: 0.5, y: 0.5)

                        Image(systemName: "chevron.right")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 15, height: 15)
                            .foregroundColor(.white)
                            .shadow(color: .black, radius: 1, x: 0.5, y: 0.5)
                    }
                    .frame(maxWidth: .infinity)

                    // Búsqueda
                    Button(action: {
                        isSearchViewPresented = true
                    }) {
                        Image(systemName: "magnifyingglass")
                            .font(.title2)
                            .foregroundColor(.white)
                            .shadow(color: .black, radius: 1, x: 0.5, y: 0.5)
                    }
                }
                .padding(.horizontal)
                .padding(.top, 26) 
                .padding(.bottom, 10)

                Divider()
                    .frame(height: 0.5)
                    .background(Color.white.opacity(0.5))
            }
            .background(Color.clear)
            .blur(radius: isMenuOpen ? 8 : 0)
            .disabled(isMenuOpen)

            // Fondo oscuro del menú
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
        }
        .fullScreenCover(isPresented: $mostrarSectionsFullscreen) {
            SectionsView()
        }
        .background(
            NavigationLink(
                destination: SearchFrontView(),
                isActive: $isSearchViewPresented,
                label: { EmptyView() }
            )
            .hidden()
        )
    }

    private var safeAreaTop: CGFloat {
        UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .first?.windows.first?.safeAreaInsets.top ?? 44 // fallback a 44 si no se puede obtener
    }
}
