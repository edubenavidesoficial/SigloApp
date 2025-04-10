import SwiftUI

struct NotesView: View {
    var title: String
    @StateObject private var viewModel = HomeViewModel()
    @StateObject private var articleViewModel = ArticleViewModel() // Inicializa ArticleViewModel
    @AppStorage("isLoggedIn") var isLoggedIn: Bool = false
    @State private var isMenuOpen: Bool = false
    @Binding var selectedOption: MenuOption?
    @State private var token: String? = nil
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                HeaderView(
                    selectedOption: $selectedOption,
                    isMenuOpen: $isMenuOpen,
                    isLoggedIn: isLoggedIn
                )
                
                ScrollView {
                    VStack(spacing: 0) {
                        // Mostrar el progreso mientras carga
                        if viewModel.isLoading {
                            ProgressView("Cargando...")
                        }
                        // Mostrar mensaje de error si hay uno
                        else if let errorMessage = viewModel.errorMessage {
                            Text("Error: \(errorMessage)").foregroundColor(.black)
                        }
                        // Si no hay secciones o notas, mostrar el mensaje correspondiente
                        else if viewModel.secciones.isEmpty {
                            Text("No se encontraron notas.")
                                .foregroundColor(.black)
                        }
                        // Mostrar las secciones y notas si están disponibles
                        else {
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
