import SwiftUI

struct SavedView: View {
    @ObservedObject var articleActionHelper: ArticleActionHelper
    @StateObject private var viewModel = HomeViewModel()
    @StateObject private var articleViewModel = ArticleViewModel()
    @AppStorage("isLoggedIn") var isLoggedIn: Bool = false
    @State private var token: String? = nil

    init(articleActionHelper: ArticleActionHelper) {
        self.articleActionHelper = articleActionHelper
    }

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                if !isLoggedIn {
                    HomeHeaderView()
                }
                ScrollView {
                    VStack(spacing: 0) {
                        if viewModel.isLoading {
                            ProgressView("Cargando...")
                        } else if let errorMessage = viewModel.errorMessage {
                            Text("Error: \(errorMessage)").foregroundColor(.black)
                        } else {
                            ForEach(viewModel.secciones.filter { $0.seccion == "Portada" }, id: \.seccion) { seccion in
                                let notas = seccion.notas ?? []
                                TabView {
                                    ForEach(notas, id: \.id) { nota in
                                        NoticiaView(nota: nota)
                                    }
                                }
                                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
                                .frame(height: 450)
                            }
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
