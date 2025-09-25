import SwiftUI

struct VideoViewHome: View {
    let video: SectionVideo
    let allVideos: [SectionVideo]
    let articleActionHelper: ArticleActionHelper
    @EnvironmentObject var articleViewModel: ArticleViewModel
    @State private var showPlayer = false

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            // Imagen del video
            if let cover = video.cover,
               let url = URL(string: cover) {

                ZStack {
                    AsyncImage(url: url) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    } placeholder: {
                        Color.gray.opacity(0.3)
                    }
                    .frame(width: 120, height: 160) 
                    .clipped()
                    .cornerRadius(8)

                    Button(action: {
                        showPlayer = true
                    }) {
                        Circle()
                            .fill(Color.black.opacity(0.4))
                            .frame(width: 40, height: 40)
                            .overlay(
                                Image(systemName: "play.fill")
                                    .foregroundColor(.white)
                                    .font(.system(size: 20, weight: .bold))
                            )
                            .shadow(radius: 3)
                    }
                }
                .background(
                    NavigationLink(
                        destination: VideoListPlayerView(videos: allVideos, currentVideo: video),
                        isActive: $showPlayer
                    ) {
                        EmptyView()
                    }
                    .hidden()
                )
            }

            VStack(alignment: .leading, spacing: 8) {
                // Título y contenido
                VStack(alignment: .leading, spacing: 4) {
                    Text(video.titulo ?? "Sin título")
                        .font(.headline)
                        .bold() // título en negrita
                    Divider()
                    if let contenido = video.contenido {
                        Text(contenido)
                            .font(.subheadline)
                            .lineLimit(3)
                            .foregroundColor(.secondary)
                    }
                }

                // Sección y menú debajo
                HStack {
                    Text(video.seccion ?? "SIGLO TV")
                        .font(.caption)
                        .bold()
                        .foregroundColor(.red)
                        .lineLimit(1)
                        .truncationMode(.tail)

                    Spacer() // Empuja el menú a la derecha

                    Menu {
                        Button {
                            articleActionHelper.compartirVideo(video)
                        } label: {
                            Label("Compartir", systemImage: "square.and.arrow.up")
                        }
                        Button {
                            articleActionHelper.guardarVideo(video)
                        } label: {
                            Label("Guardar", systemImage: "bookmark")
                        }
                    } label: {
                        Image(systemName: "ellipsis")
                            .foregroundColor(.gray)
                            .padding(10)
                            .background(Color.white.opacity(0.3))
                            .clipShape(Circle())
                            .font(.system(size: 20))
                    }
                }
            }
        }
        .padding()
        .background(Divider(), alignment: .bottom)
    }
}
