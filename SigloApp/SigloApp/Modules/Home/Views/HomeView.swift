import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    @StateObject var articleViewModel = ArticleViewModel() // Única instancia para toda la HomeView
    @AppStorage("isLoggedIn") private var isLoggedIn: Bool = false // Estado de sesión persistente
    @State private var token: String? = nil

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                ScrollView {
                    VStack(spacing: 0) {
                        HeaderView(isLoggedIn: isLoggedIn) // Se actualiza dinámicamente
                        
                        if viewModel.isLoading {
                            ProgressView("Cargando...")
                        } else if let errorMessage = viewModel.errorMessage {
                            // Mostrar ErrorView con un tipo de error dinámico
                            ErrorView(errorType: getErrorType(from: errorMessage)) {
                                viewModel.cargarPortada() // Reintentar carga al presionar el botón
                            }
                        } else {
                            ForEach(viewModel.secciones.filter { $0.seccion == "Portada" }, id: \.seccion) { seccion in
                                let notas = seccion.notas ?? [] // Asegurarse de que no sea nil
                                TabView {
                                    ForEach(notas, id: \.id) { nota in
                                        NoticiaView(nota: nota)
                                    }
                                }
                                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                                .frame(height: 450)
                            }
                            // Pasar ambos viewModels a SeccionesHomeView
                            SeccionesHomeView(viewModel: viewModel, articleViewModel: articleViewModel)
                        }
                    }
                    .offset(y: -8)
                }
            }
            .navigationBarHidden(true)
            .onAppear {
                viewModel.cargarPortada()
            }
            .task {
                do {
                    let generatedToken = try await TokenService.shared.getToken(correoHash: "")
                    print("✅ Token generado: \(generatedToken)")
                    token = generatedToken
                } catch {
                    print("❌ Error al generar token: \(error.localizedDescription)")
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
