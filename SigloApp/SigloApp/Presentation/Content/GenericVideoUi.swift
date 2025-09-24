import SwiftUI

struct ErrorSectionView: View {
    let message: String
    var reloadAction: (() -> Void)? = nil
    
    var body: some View {
        VStack(spacing: 12) {
            Text(message)
                .foregroundColor(.red)
                .multilineTextAlignment(.center)
            
            if let reload = reloadAction {
                Button(action: reload) {
                    Text("Reintentar")
                        .fontWeight(.bold)
                        .padding()
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(1)
                }
            }
        }
        .padding()
    }
}

struct VideoSectionView: View {
    var videos: [SectionVideo] 

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
