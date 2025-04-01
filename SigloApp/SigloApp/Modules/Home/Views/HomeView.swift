import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    @StateObject var articleViewModel = ArticleViewModel() // Única instancia para toda la HomeView
    @AppStorage("isLoggedIn") var isLoggedIn: Bool = false
    @State private var token: String? = nil

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                if isLoggedIn {
                    HomeHeaderView()
                } else {
                     HomeView()
                }
                ScrollView {
                    VStack(spacing: 0) {
                        if viewModel.isLoading {
                            ProgressView("Cargando...")
                        } else if let errorMessage = viewModel.errorMessage {
                            Text("Error: \(errorMessage)")
                                .foregroundColor(.black)
                        } else {
                            ForEach(viewModel.secciones.filter { $0.seccion == "Portada" }, id: \.seccion) { seccion in
                                let notas = seccion.notas ?? [] // Asegurarse de que no sea nil
                                TabView {
                                    ForEach(notas, id: \.id) { nota in
                                        NoticiaView(nota: nota)
                                    }
                                }
                                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
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
}
