import SwiftUI

struct NotesView: View {
    @StateObject private var viewModel = HomeViewModel()
    @StateObject private var articleViewModel = ArticleViewModel() // Inicializa ArticleViewModel
    @AppStorage("isLoggedIn") var isLoggedIn: Bool = false
    @State private var token: String? = nil
    var title: String
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                HeaderView(isLoggedIn: isLoggedIn) // Se actualiza dinámicamente
                ScrollView {
                    VStack(spacing: 0) {
                        if viewModel.isLoading {
                            ProgressView("Cargando...")
                        } else if let errorMessage = viewModel.errorMessage {
                            Text("Error: \(errorMessage)").foregroundColor(.black)
                        } else {
                            ForEach(viewModel.secciones.filter { $0.seccion == "\(title)" }, id: \.seccion) { seccion in
                                let notas = seccion.notas ?? [] // Asegura que no sea nil
                                TabView {
                                    ForEach(notas, id: \.id) { nota in
                                        NoticiaView(nota: nota)
                                    }
                                }
                                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
                                .frame(height: 450)
                            }
                            let sectionTitle = "\(title)" // O cualquier otra variable de tipo String
                            SeccionsNotesView(viewModel: viewModel, articleViewModel: articleViewModel, title: sectionTitle)
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

