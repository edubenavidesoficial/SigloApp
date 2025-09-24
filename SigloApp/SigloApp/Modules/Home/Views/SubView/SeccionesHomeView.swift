import SwiftUI
import GoogleMobileAds

struct SeccionesHomeView: View {
    @ObservedObject var viewModel: HomeViewModel
    @ObservedObject var articleViewModel: ArticleViewModel
    @StateObject var articleActionHelper: ArticleActionHelper
    
    init(viewModel: HomeViewModel, articleViewModel: ArticleViewModel) {
        self.viewModel = viewModel
        self.articleViewModel = articleViewModel
        _articleActionHelper = StateObject(wrappedValue: ArticleActionHelper(articleViewModel: articleViewModel))
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                
                // MARK: - Portada
                if let portada = viewModel.secciones.first(where: { $0.seccion == "Portada" }) {
                    let notas = Array((portada.notas ?? []).dropFirst().prefix(4))
                    if !notas.isEmpty {
                        ForEach(notas, id: \.id) { nota in
                            NotaRow(nota: nota, seccion: "Portada", articleActionHelper: articleActionHelper)
                        }
                    } else {
                        Text("No hay notas disponibles en la Portada.")
                            .foregroundColor(.gray)
                            .padding()
                    }
                }

                // MARK: - Sin sección
                if let sinSeccion = viewModel.secciones.first(where: { $0.seccion == nil }),
                   let notaRandom = sinSeccion.notas?.shuffled().first {
                    NotaDestacadaView(nota: notaRandom)
                }
                
                BannerAdView(adUnitID: "ca-app-pub-5687735147948295/8617784591")
                    .frame(width: 360, height: 50)

                // MARK: - Foquitos
                if let foquitos = viewModel.secciones.first(where: { $0.seccion == "Foquitos" }),
                   let notas = foquitos.notas, !notas.isEmpty {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 16) {
                            ForEach(notas, id: \.id) { nota in
                                NotaCarruselCard(nota: nota)
                            }
                        }
                        .padding(.horizontal)
                    }
                    .padding(.bottom)
                }

                BannerAdView(adUnitID: "ca-app-pub-5687735147948295/1437013165")
                    .frame(width: 360, height: 50)

                // MARK: - Portada Soft
                if let soft = viewModel.secciones.first(where: { $0.seccion == "Portada Soft" }),
                   let notas = soft.notas, !notas.isEmpty {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 16) {
                            ForEach(notas, id: \.id) { nota in
                                SoftCarruselCard(nota: nota, articleActionHelper: articleActionHelper)
                            }
                        }
                        .padding(.horizontal)
                    }
                    .padding(.bottom)
                }

                BannerAdView(adUnitID: "ca-app-pub-5687735147948295/7810849826")
                    .frame(width: 360, height: 50)

                // MARK: - Sección SigloTv
                let videos = viewModel.videos

                if viewModel.isLoading {
                    ProgressView("Cargando videos...")
                        .padding()
                } else if videos.isEmpty {
                    Text("No hay videos disponibles")
                        .padding()
                } else {
                    // Mostrar videos
                    if let primerVideo = videos.first {
                        VideoView(video: primerVideo, allVideos: videos)
                    }

                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 16) {
                            ForEach(videos, id: \.id) { video in
                                VideoCard(video: video)
                            }
                        }
                        .padding(.horizontal)
                    }

                    if videos.count > 6 {
                        let videosSeleccionados = Array(videos.dropFirst(6).prefix(4))
                        ForEach(videosSeleccionados, id: \.id) { video in
                            VideoView(video: video, allVideos: videos)
                        }
                    }
                }

                // MARK: - Siglo Data
                if let data = viewModel.secciones.first(where: { $0.seccion == "Siglo Data" }),
                   let notas = data.notas, !notas.isEmpty {
                    if let nota = notas.randomElement() {
                        NewsBigImageRow(nota: nota, articleActionHelper: articleActionHelper)
                            .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
                    }

                    ForEach(notas.prefix(4), id: \.id) { nota in
                        NewsRelaRow(nota: nota, articleActionHelper: articleActionHelper)
                    }
                } else {
                    Text("No hay notas disponibles en la Siglo Data.")
                        .foregroundColor(.gray)
                        .padding()
                }
            }
        }
        .sheet(isPresented: $articleActionHelper.showShareSheet) {
            ActivityView(activityItems: articleActionHelper.shareContent)
        }
    }
}
