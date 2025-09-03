import SwiftUI

struct ImpresoView: View {
    @StateObject private var printVM = PrintViewModel()
    @StateObject private var subVM = UserSubscriptionViewModel()
    @EnvironmentObject var userManager: UserManager
    @State private var pushNotificationsEnabled = true
    @AppStorage("isLoggedIn") var isLoggedIn: Bool = false
    @State private var isMenuOpen: Bool = false
    @State private var selectedOption: MenuOption? = nil
    

    var body: some View {
        ZStack(alignment: .bottom) {
            NavigationView {
                ScrollView {
                    VStack(spacing: 0) {

                        // Header con menú
                        HeaderView(
                            selectedOption: $selectedOption,
                            isMenuOpen: $isMenuOpen,
                            isLoggedIn: isLoggedIn
                        )

                        if let selected = selectedOption {
                            NotesView(title: selected.title, selectedOption: $selectedOption)
                                .transition(.move(edge: .trailing))
                        } else {
                            // Selector de pestañas
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 20) {
                                    ForEach(TabTypetwo.allCases, id: \.self) { tab in
                                        VStack(spacing: 4) {
                                            Text(tab.rawValue)
                                                .font(.system(size: 14))
                                                .lineLimit(1)
                                                .minimumScaleFactor(0.5)
                                                .fontWeight(printVM.selectedTab == tab ? .bold : .regular)
                                                .foregroundColor(.primary)
                                                .onTapGesture {
                                                    withAnimation {
                                                        printVM.selectedTab = tab
                                                    }
                                                }

                                            Rectangle()
                                                .fill(printVM.selectedTab == tab ? Color.red : Color.clear)
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

                            // Contenido según pestaña
                            Group {
                                if printVM.isLoading {
                                } else {
                                    switch printVM.selectedTab {
                                    case .hemeroteca:
                                        PrintCarouselView(viewModel: printVM)
                                    case .suplementos:
                                        SuplementsView()
                                    case .descargas:
                                        DescargasView(viewModel: printVM)
                                    }
                                }
                            }

                            // Error si lo hay
                            if let errorMessage = printVM.errorMessage {
                                Text(errorMessage)
                                    .foregroundColor(.red)
                                    .padding()
                            }

                            Divider()
                        }
                    }
                }
                
                .onAppear {
                    // Carga la suscripción al aparecer
                    if let userId = userManager.user?.id {
                        subVM.cargarSuscripcion(usuarioId: userId)
                    }
                    // Carga el periódico
                    if !printVM.isNewspaperLoaded {
                        printVM.fetchNewspaper()
                    }
                }
            }

            // Panel inferior para NO suscriptores
            /*
            let estado = subVM.suscripcion?.suscripcionDigital.estado?.lowercased() ?? ""
            let isSubscriber = subVM.suscripcion?.suscriptor == true && estado == "activa"

            if !isLoggedIn || !isSubscriber {
                VStack(spacing: 16) {
                    Text("ESTE CONTENIDO ES SOLO PARA SUSCRIPTORES")
                        .font(.headline)
                        .multilineTextAlignment(.center)

                    // Si no está logueado, mostrar siempre el link fijo
                    if !isLoggedIn {
                        if let url = URL(string: "https://www.elsiglodetorreon.com.mx/suscripcion/") {
                            Link("SUSCRÍBETE", destination: url)
                                .foregroundColor(.white)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.red)
                                .cornerRadius(1)
                        }
                    }
                    // Si está logueado pero no es suscriptor activo, mostrar su URL específica si existe
                   else if estado != "activa" {
                        if let urlString = subVM.suscripcion?.urlSuscribirse,
                           let url = URL(string: urlString) {
                            Link("SUSCRÍBETE", destination: url)
                                .foregroundColor(.white)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.red)
                                .cornerRadius(1)
                        }
                    }

                    Button("YA SOY SUSCRIPTOR") {
                        // Navegar a login o refrescar estado
                    }
                    .underline()
                    
                }
                .padding()
                .background(.ultraThinMaterial)
                .cornerRadius(8)
                .padding()
                .transition(.move(edge: .bottom))
                .animation(.easeInOut, value: isLoggedIn)
            }*/
        }
    }
}
