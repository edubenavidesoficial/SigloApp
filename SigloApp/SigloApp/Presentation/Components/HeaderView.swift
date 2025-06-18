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
    @State private var navigateToSections = false

    var body: some View {
        ZStack(alignment: .leading) {
            VStack(spacing: 0) {
                HStack {
                    Button(action: {
                        if selectedOption != nil {
                            selectedOption = nil
                        } else {
                            navigateToSections = true
                        }
                    }) {
                        Image(systemName: selectedOption != nil ? "chevron.left" : "line.horizontal.3")
                            .imageScale(.large)
                    }

                    // NavigationLink oculto
                    NavigationLink(
                        destination: SectionsView(),
                        isActive: $navigateToSections,
                        label: {
                            EmptyView()
                        }
                    ).hidden()

                    Spacer()

                    Image("titulo")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 30)

                    Spacer()

                    // Ícono de búsqueda siempre visible
                    Button(action: {
                        isSearchViewPresented = true
                    }) {
                        Image(systemName: "magnifyingglass")
                            .font(.title2)
                            .foregroundColor(.black)
                    }

                    // Navegación oculta a vista de búsqueda
                    NavigationLink(
                        destination: SearchFrontView(),
                        isActive: $isSearchViewPresented,
                        label: {
                            EmptyView()
                        }).hidden()
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
    }

    func logout() {
        UserDefaults.standard.set(false, forKey: "isLoggedIn")
        print("🔴 Sesión cerrada")
    }
}
