import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    @StateObject var articleViewModel = ArticleViewModel()
    @AppStorage("isLoggedIn") private var isLoggedIn: Bool = false
    @State private var isMenuOpen: Bool = false
    @State private var selectedOption: MenuOption? = nil
    @State private var token: String? = nil
    @State private var didLoad: Bool = false
    @State private var showTokenError = false

    var body: some View {
        NavigationView {
            ZStack {
                if let selected = selectedOption {
                    NotesView(title: selected.title, selectedOption: $selectedOption)
                        .transition(.move(edge: .trailing))
                } else {
                    ScrollView {
                        VStack(spacing: 0) {
                            HeaderView(
                                selectedOption: $selectedOption,
                                isMenuOpen: $isMenuOpen,
                                isLoggedIn: isLoggedIn
                            )

                            // MARK: Noticias - Primera nota de Portada
                            if let seccion = viewModel.secciones.first(where: { $0.seccion == "Portada" }),
                               let nota = seccion.notas?.first {
                                let helper = ArticleActionHelper(articleViewModel: articleViewModel)
                                NoticiaView(nota: nota, articleActionHelper: helper)
                                    .environmentObject(articleViewModel)
                                    .frame(height: 520)
                                    .padding(.top, -10)
                            } else {
                                Text("No hay noticias disponibles")
                                    .foregroundColor(.gray)
                                    .padding()
                            }

                            // MARK: Otras secciones
                            SeccionesHomeView(viewModel: viewModel, articleViewModel: articleViewModel)

                            // MARK: Carga adicional
                            if viewModel.isLoading {
                                ProgressView("Cargando más...")
                                    .padding()
                            }

                            // Trigger scroll para cargar más
                            GeometryReader { geometry in
                                Color.clear
                                    .onAppear {
                                        let screenHeight = UIScreen.main.bounds.height
                                        if geometry.frame(in: .global).maxY < screenHeight + 100 {
                                            viewModel.cargarPortada()
                                        }
                                    }
                            }
                            .frame(height: 50)
                        }
                        .offset(y: 2)
                    }
                }
            }
            .navigationBarHidden(true)
            .navigationBarBackButtonHidden(true)
            .onAppear {
                if !didLoad {
                    viewModel.cargarPortada()
                    didLoad = true
                }
            }
            .task {
                if !didLoad {
                    do {
                        let correoHash = TokenService.shared.getStoredCorreoHash() ?? ""
                        let generatedToken = try await TokenService.shared.getToken(correoHash: correoHash)
                        print("✅ Token generado: \(generatedToken)")
                        token = generatedToken
                        viewModel.cargarPortada()
                        didLoad = true
                    } catch {
                        print("❌ Error al generar token: \(error.localizedDescription)")
                        showTokenError = true
                    }
                }
            }
        }
    }
    
    // MARK: Función para mapear mensaje a tipo de error
    private func getErrorType(from message: String) -> ErrorType {
        if message.contains("404") {
            return .notFound
        } else if message.contains("mantenimiento") {
            return .maintenance
        } else if message.contains("conexión") {
            return .connection
        } else {
            return .unexpected
        }
    }
}
