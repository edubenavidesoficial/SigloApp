import SwiftUI
import AVKit
import WebKit

struct VideoListPlayerView: View {
    let videos: [SectionVideo]
    let currentVideo: SectionVideo?  // Video con el que inicia

    @State private var currentVideoURL: URL?
    @State private var currentVideoSelected: SectionVideo?

    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()

            VStack(spacing: 0) {
                if let video = currentVideoSelected ?? firstVideo() {
                    if let urlString = video.url {
                        if urlString.contains("youtube.com") || urlString.contains("youtu.be") || urlString.contains("facebook.com") {
                            // Mostrar WebView con URL embebida
                            WebVideoView(urlString: urlString)
                                .frame(height: 250)
                                .cornerRadius(12)
                                .padding()
                        } else if let url = URL(string: urlString) {
                            VideoPlayer(player: AVPlayer(url: url))
                                .frame(height: 250)
                                .cornerRadius(12)
                                .padding()
                        } else {
                            Text("URL inválida")
                                .frame(height: 250)
                                .padding()
                                .foregroundColor(.white)
                        }
                    }

                    // Mostrar título y contenido
                    VStack(alignment: .leading, spacing: 8) {
                        Text(video.titulo ?? "Sin título")
                            .font(.headline)
                            .foregroundColor(.white)

                        if let contenido = video.contenido {
                            Text(contenido)
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                        HStack {
                            Text(video.seccion ?? "SIGLO")
                                .font(.caption)
                                .bold()
                                .foregroundColor(.white)
                                .shadow(radius: 2)
                                .padding(.leading)

                            Spacer()

                            HStack {
                                Image(systemName: "clock")
                                    .foregroundColor(.white.opacity(0.8))
                                Text(video.fechaformato ?? "00:00")
                                    .font(.caption)
                                    .foregroundColor(.white.opacity(0.8))
                            }
                            .padding(.trailing)
                        }
                    }
                    .padding(.horizontal)
                } else {
                    Text("No hay video para reproducir")
                        .frame(height: 250)
                        .padding()
                        .foregroundColor(.white)
                }

                Divider()

                // ScrollView de videos relacionados
                ScrollView {
                    VStack(spacing: 12) {
                        if let current = currentVideoSelected ?? firstVideo() {
                            ForEach(relatedVideos(for: current), id: \.id) { video in
                                Button(action: {
                                    currentVideoSelected = video
                                    if let urlString = video.url, let url = URL(string: urlString) {
                                        currentVideoURL = url
                                    }
                                }) {
                                    HStack {
                                        if let cover = video.cover, let coverURL = URL(string: cover) {
                                            ZStack(alignment: .bottomLeading) {
                                                AsyncImage(url: coverURL) { image in
                                                    image
                                                        .resizable()
                                                        .aspectRatio(contentMode: .fill)
                                                } placeholder: {
                                                    Color.gray.opacity(0.3)
                                                }

                                                Circle()
                                                    .fill(Color.black.opacity(1))
                                                    .frame(width: 20, height: 20)
                                                    .overlay(
                                                        Image(systemName: "play.fill")
                                                            .foregroundColor(.white)
                                                            .font(.system(size: 12, weight: .bold))
                                                    )
                                                    .padding(6)
                                            }
                                            .frame(width: 100, height: 56)
                                            .clipped()
                                            .cornerRadius(1)
                                        } else {
                                            Color.gray.frame(width: 100, height: 56)
                                                .cornerRadius(1)
                                        }

                                        VStack {
                                            Text(video.titulo ?? "Sin título")
                                                .font(.custom("FiraSansCondensed-Medium", size: 15))
                                                .foregroundColor(.white)
                                            HStack {
                                                Text(video.seccion ?? "SIGLO")
                                                    .font(.custom("FiraSansCondensed-Medium", size: 14))
                                                    .bold()
                                                    .foregroundColor(.white)
                                                    .shadow(radius: 2)
                                                    .padding(.leading)

                                                Spacer()

                                                HStack {
                                                    Image(systemName: "clock")
                                                        .foregroundColor(.white.opacity(0.8))
                                                    Text(video.fechaformato ?? "00:00")
                                                        .font(.custom("FiraSansCondensed-Regular", size: 14))
                                                        .foregroundColor(.white.opacity(0.8))
                                                }
                                                .padding(.trailing)
                                            }
                                        }
                                        Spacer()
                                    }
                                    .padding(.horizontal)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                    }
                    .padding(.vertical)
                }

            }
        }
        .navigationTitle("Videos")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            if currentVideoSelected == nil {
                currentVideoSelected = currentVideo ?? firstVideo()
            }
        }
    }

    private func firstVideo() -> SectionVideo? {
        videos.first
    }

    // Función para obtener videos relacionados según la sección del video actual
    private func relatedVideos(for video: SectionVideo) -> [SectionVideo] {
        guard let seccion = video.seccion else { return [] }
        return videos
            .filter { $0.id != video.id && $0.seccion == seccion }
            .prefix(5) // Limitar a 5 videos
            .map { $0 }
    }
}

// WebView para cargar URLs web en SwiftUI
struct WebVideoView: UIViewRepresentable {
    let urlString: String

    func makeUIView(context: Context) -> WKWebView {
        let webview = WKWebView()
        webview.scrollView.isScrollEnabled = false
        return webview
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        if let url = URL(string: urlString) {
            let request = URLRequest(url: url)
            uiView.load(request)
        }
    }
}
