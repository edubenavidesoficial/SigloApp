import SwiftUI

struct ErrorSectionView: View {
    var message: String
    var reloadAction: () -> Void

    var body: some View {
        ErrorView(errorType: getErrorType(from: message)) {
            reloadAction()
        }
    }

    private func getErrorType(from message: String) -> ErrorType {
        if message.contains("404") { return .notFound }
        else if message.contains("mantenimiento") { return .maintenance }
        else if message.contains("conexión") { return .connection }
        else { return .unexpected }
    }
}

struct VideoSectionView: View {
    var videos: [SectionVideo] // ⚡ aquí estaba el error, no es Video

    var body: some View {
        VStack(spacing: 16) {
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
    }
}

struct NewsSectionView: View {
    var noticias: [Noticia] // Tu modelo real

    var body: some View {
        VStack(spacing: 16) {
            TabView {
                ForEach(noticias, id: \.id) { noticia in
                    NewsView(nota: noticia) // ✅ label corregido
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            .frame(height: 550)
            .padding(.top, -102)

            ForEach(noticias.dropFirst().prefix(5), id: \.id) { noticia in
                SectionDestacadaView(nota: noticia) // ⚡ también aquí
            }
        }
    }
}
