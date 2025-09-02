import SwiftUI

struct NotesView: View {
    var title: String
    @StateObject private var viewModel = HomeViewModel()
    @StateObject private var articleViewModel: ArticleViewModel
    @StateObject private var articleActionHelper: ArticleActionHelper
    @AppStorage("isLoggedIn") var isLoggedIn: Bool = false
    @State private var isMenuOpen: Bool = false
    @Binding var selectedOption: MenuOption?
    @State private var token: String? = nil

    // 👇 Inicializador personalizado para inyectar correctamente dependencias
    init(title: String, selectedOption: Binding<MenuOption?>) {
        self.title = title
        self._selectedOption = selectedOption

        let articleVM = ArticleViewModel()
        _articleViewModel = StateObject(wrappedValue: articleVM)
        _articleActionHelper = StateObject(wrappedValue: ArticleActionHelper(articleViewModel: articleVM))
    }

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
                        if viewModel.isLoading {
                            ProgressView("Cargando...")
                        } else if let errorMessage = viewModel.errorMessage {
                            Text("Error: \(errorMessage)").foregroundColor(.black)
                        } else if viewModel.secciones.isEmpty {
                            Text("No se encontraron notas.")
                                .foregroundColor(.black)
                        } else {
                            ForEach(viewModel.secciones.filter { $0.seccion == "\(title)" }, id: \.seccion) { seccion in
                                let notas = seccion.notas ?? []
                                TabView {
                                    ForEach(notas, id: \.id) { nota in
                                        NoticiaView(nota: nota)
                                    }
                                }
                                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
                                .frame(height: 450)
                            }

                            let sectionTitle = "\(title)"
                            SeccionsNotesView(
                                viewModel: viewModel,
                                articleViewModel: articleViewModel,
                                articleActionHelper: articleActionHelper,
                                title: sectionTitle
                            )
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
