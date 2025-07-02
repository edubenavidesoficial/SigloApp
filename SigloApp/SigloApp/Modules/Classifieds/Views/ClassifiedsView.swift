import SwiftUI

struct ClassifiedsView: View {
    @StateObject private var classifiedsVM = ClassifiedsViewModel()
    @StateObject private var subVM = UserSubscriptionViewModel()
    @EnvironmentObject var userManager: UserManager
    @AppStorage("isLoggedIn") var isLoggedIn: Bool = false
    @State private var isMenuOpen: Bool = false
    @State private var selectedOption: MenuOption? = nil

    var body: some View {
        ZStack(alignment: .bottom) {
            NavigationStack {
                ScrollView {
                    VStack(spacing: 0) {
                        HeaderView(
                            selectedOption: $selectedOption,
                            isMenuOpen: $isMenuOpen,
                            isLoggedIn: isLoggedIn
                        )

                        if let selected = selectedOption {
                            NotesView(title: selected.title, selectedOption: $selectedOption)
                                .transition(.move(edge: .trailing))
                        } else {
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 20) {
                                    ForEach(TabClassifieds.allCases) { tab in
                                        VStack(spacing: 4) {
                                            Text(tab.rawValue)
                                                .font(.system(size: 14))
                                                .lineLimit(1)
                                                .minimumScaleFactor(0.5)
                                                .fontWeight(classifiedsVM.selectedTab == tab ? .bold : .regular)
                                                .foregroundColor(.primary)
                                                .onTapGesture {
                                                    withAnimation {
                                                        classifiedsVM.selectedTab = tab
                                                    }
                                                }

                                            Rectangle()
                                                .fill(classifiedsVM.selectedTab == tab ? Color.red : Color.clear)
                                                .frame(height: 2)
                                        }
                                        .padding(.horizontal, 8)
                                    }
                                }
                                .padding(.horizontal)
                            }
                            .padding()
                            .background(Color(.systemBackground))

                            Divider()

                            Group {
                                switch classifiedsVM.selectedTab {
                                case .avisos:
                                    AvisosCarouselView(viewModel: classifiedsVM)
                                case .desplegados:
                                    AvisosView()
                                case .esquelas:
                                    AvisosView()
                                case .anunciate:
                                    AvisosView()
                                }
                            }

                            if let errorMessage = classifiedsVM.errorMessage {
                                Text(errorMessage)
                                    .foregroundColor(.red)
                                    .padding()
                            }

                            Divider()
                        }
                    }
                }
                .onAppear {
                    if let userId = userManager.user?.id {
                        subVM.cargarSuscripcion(usuarioId: userId)
                    }
                    if !classifiedsVM.isNewspaperLoaded {
                        classifiedsVM.fetchClassifiedCategories()
                    }
                }
            }

            let estado = subVM.suscripcion?.suscripcionDigital.estado?.lowercased() ?? ""
            let isSubscriber = subVM.suscripcion?.suscriptor == true && estado == "activa"

            if !isLoggedIn || !isSubscriber {
                VStack(spacing: 16) {
                    Text("ESTE CONTENIDO ES SOLO PARA SUSCRIPTORES")
                        .font(.headline)
                        .multilineTextAlignment(.center)

                    subscriptionButton

                    Button("YA SOY SUSCRIPTOR") {
                        // Acción para usuarios suscriptores
                    }
                    .underline()
                }
                .padding()
                .background(.ultraThinMaterial)
                .cornerRadius(8)
                .padding()
                .transition(.move(edge: .bottom))
                .animation(.easeInOut, value: isLoggedIn)
            }
        }
    }

    @ViewBuilder
    var subscriptionButton: some View {
        if !isLoggedIn {
            if let url = URL(string: "https://www.elsiglodetorreon.com.mx/suscripcion/") {
                Link("SUSCRÍBETE", destination: url)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.red)
                    .cornerRadius(8)
            }
        } else if (subVM.suscripcion?.suscripcionDigital.estado?.lowercased() ?? "") != "activa" {
            if let urlString = subVM.suscripcion?.urlSuscribirse,
               let url = URL(string: urlString) {
                Link("SUSCRÍBETE", destination: url)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.red)
                    .cornerRadius(8)
            }
        }
    }
}
