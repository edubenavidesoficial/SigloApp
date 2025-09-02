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
                    // Espacio para el header
                    Color.clear.frame(height: headerHeight)

                    if let errorMessage = viewModel.errorMessage {
                        ErrorView(errorType: getErrorType(from: errorMessage)) {
                            viewModel.cargarPortada(idSeccion: payload.sectionId ?? 0)
                        }

                    } else if payload.sectionId == 903 {
                        if let videos = viewModel.videos, !videos.isEmpty {
                            // Mostrar solo el primer video, pasando la lista completa
                            if let primerVideo = videos.first {
                                VideoView(video: primerVideo, allVideos: videos)
                            }

                            // Carrusel horizontal con todos los videos
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 16) {
                                    ForEach(videos, id: \.id) { video in
                                        VideoCard(video: video)
                                    }
                                }
                                .padding(.horizontal)
                            }

                            // Mostrar videos del 7º al 10º
                            if videos.count > 6 {
                                let videosSeleccionados = Array(videos.dropFirst(6).prefix(4))
                                ForEach(videosSeleccionados, id: \.id) { video in
                                    VideoView(video: video, allVideos: videos)
                                }
                            }
                        } else if viewModel.isLoading {
                            ProgressView("Cargando videos...")
                                .padding()
                        } else {
                            Text("No hay videos disponibles")
                                .padding()
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
                        .padding(.top, -102)

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

            // Header según sección
            if payload.sectionId == 903 {
                BlackHeaderView(
                    nombreSeccion: payload.nombre,
                    selectedOption: $selectedOption,
                    isMenuOpen: $isMenuOpen,
                    isLoggedIn: isLoggedIn
                )
                .padding(.top)
                .background(Color.clear)
            } else {
                WriteHeaderView(
                    nombreSeccion: payload.nombre,
                    selectedOption: $selectedOption,
                    isMenuOpen: $isMenuOpen,
                    isLoggedIn: isLoggedIn
                )
                .padding(.top)
                .background(Color.clear)
            }
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

    // Altura del header
    private var headerHeight: CGFloat {
        let safeTop = UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .first?.windows.first?.safeAreaInsets.top ?? 44
        return safeTop + 55
    }

    // Tipo de error
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
