import SwiftUI

struct SectionDetailView: View {
    @StateObject private var viewModel = SectionDetailViewModel()
    @StateObject var articleViewModel = ArticleViewModel()
    @AppStorage("isLoggedIn") private var isLoggedIn: Bool = false
    @State private var isMenuOpen: Bool = false
    @State private var selectedOption: MenuOption? = nil
    @State private var token: String? = nil
    @State private var didLoad: Bool = false
    @State private var showTokenError = false

    let payload: SectionPayload
    @State private var contenido: SectionPayload?

    var body: some View {
        ZStack(alignment: .top) {
            ScrollView {
                VStack(spacing: 0) {
                    // Esto crea espacio debajo del header para que no tape contenido
                    Color.clear.frame(height: headerHeight)

                    if let errorMessage = viewModel.errorMessage {
                        ErrorView(errorType: getErrorType(from: errorMessage)) {
                            viewModel.cargarPortada(idSeccion: payload.sectionId ?? 0)
                        }
                    } else if let seccion = viewModel.secciones.first {
                        let notas = seccion.notas ?? []
                        TabView {
                            ForEach(notas, id: \.id) { nota in
                                NewsView(nota: nota)
                            }
                        }
                        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                        .frame(height: 550)
                        .padding(.top, -75)

                        ForEach(notas.dropFirst().prefix(5), id: \.id) { nota in
                            SectionDestacadaView(nota: nota)
                        }

                        if viewModel.isLoading {
                            ProgressView("Cargando más...")
                                .padding()
                        }
                    } 
                }
            }

            // Header transparente y fijo encima
            WriteHeaderView(
                nombreSeccion: payload.nombre,
                selectedOption: $selectedOption,
                isMenuOpen: $isMenuOpen,
                isLoggedIn: isLoggedIn
            )
            .background(Color.clear)
        }
        .edgesIgnoringSafeArea(.top)
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
        .onAppear {
            if !didLoad {
                viewModel.cargarPortada(idSeccion: payload.sectionId ?? 0)
                didLoad = true
            }
        }
    }

    // Altura total estimada del header (incluye safe area top + barra)
    private var headerHeight: CGFloat {
        let safeTop = UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .first?.windows.first?.safeAreaInsets.top ?? 44
        return safeTop + 55 // 55 es la altura estimada del contenido del header
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
