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
                    VStack(spacing: 0) {
                        ScrollView {
                            VStack(spacing: 0) {
                                HeaderView(
                                    selectedOption: $selectedOption,
                                    isMenuOpen: $isMenuOpen,
                                    isLoggedIn: isLoggedIn
                                )

                                if viewModel.isLoading && viewModel.secciones.isEmpty {
                                    ProgressView("Cargando...")
                                } else if let errorMessage = viewModel.errorMessage {
                                    ErrorView(errorType: getErrorType(from: errorMessage)) {
                                        viewModel.cargarPortada()
                                    }
                                } else {
                                    ForEach(viewModel.secciones.filter { $0.seccion == "Portada" }, id: \.seccion) { seccion in
                                        let notas = seccion.notas ?? []
                                        TabView {
                                            ForEach(notas, id: \.id) { nota in
                                                NoticiaView(nota: nota)
                                            }
                                        }
                                        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                                        .frame(height: 450)
                                    }

                                    SeccionesHomeView(viewModel: viewModel, articleViewModel: articleViewModel)

                                    // Indicador de carga al final
                                    if viewModel.isLoading {
                                        ProgressView("Cargando más...")
                                            .padding()
                                    }

                                    // Detector para cargar más al llegar al final
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
                            }
                            .offset(y: -8)
                        }
                    }
                }
            }
            .navigationBarHidden(true)
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

    /// Método para mapear un mensaje de error a un tipo de ErrorType
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
