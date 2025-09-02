import SwiftUI

struct CoversView: View {
    @StateObject private var viewModel = SectionDetailViewModel()
    @StateObject var articleViewModel = ArticleViewModel()
    @AppStorage("isLoggedIn") private var isLoggedIn: Bool = false
    @State private var isMenuOpen: Bool = false
    @State private var selectedOption: MenuOption? = nil
    @State private var token: String? = nil
    @State private var didLoad: Bool = false
    @State private var showTokenError = false

    @State private var notas: [Noticia] = []
    @State private var isLoading = false
    @State private var errorMessage: String?

    var body: some View {
        ZStack(alignment: .top) {
            ScrollView {
                VStack(spacing: 0) {
                    // Espacio para header transparente
                    Color.clear.frame(height: headerHeight)

                    if isLoading {
                        ProgressView("Cargando...")
                            .padding()
                    } else if let error = errorMessage {
                        Text("Error: \(error)")
                            .foregroundColor(.red)
                            .padding()
                    } else if !notas.isEmpty {
                        TabView {
                            ForEach(notas, id: \.id) { nota in
                                NewsView(nota: nota)
                            }
                        }
                        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                        .frame(height: 550)
                        .padding(.top, -102)

                        ForEach(notas.dropFirst().prefix(5), id: \.id) { nota in
                            SectionDestacadaView(nota: nota)
                        }
                    } else {
                        Text("No hay notas disponibles.")
                            .foregroundColor(.gray)
                            .padding()
                    }
                }
            }

            // Header fijo, transparente
            WriteHeaderView(
                nombreSeccion: "Minuto a minuto",
                selectedOption: $selectedOption,
                isMenuOpen: $isMenuOpen,
                isLoggedIn: isLoggedIn
            )
            .padding(.top)
            .background(Color.clear)
        }
        .edgesIgnoringSafeArea(.top)
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
        .onAppear {
            if !didLoad {
                cargarNotas()
                didLoad = true
            }
        }
    }

    // Altura del header
    private var headerHeight: CGFloat {
        let safeTop = UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .first?.windows.first?.safeAreaInsets.top ?? 44
        return safeTop + 55
    }

    private func cargarNotas() {
        isLoading = true
        CoversService.shared.obtenerPortadaMinutos { result in
            DispatchQueue.main.async {
                isLoading = false
                switch result {
                case .success(let payload):
                    notas = payload.notas ?? []
                    errorMessage = nil
                case .failure(let error):
                    errorMessage = error.localizedDescription
                    notas = []
                }
            }
        }
    }

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
