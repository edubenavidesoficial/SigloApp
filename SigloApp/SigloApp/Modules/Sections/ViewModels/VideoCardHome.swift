import SwiftUI

struct VideoCardHome: View {
    let video: SectionVideo
    let allVideos: [SectionVideo]
    let articleActionHelper: ArticleActionHelper
    @EnvironmentObject var articleViewModel: ArticleViewModel

    @State private var showPlayer = false

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            ZStack {
                if let cover = video.cover,
                   let coverURL = URL(string: cover) {
                    AsyncImage(url: coverURL) { image in
                        image
                            .resizable()
                            .aspectRatio(4/3, contentMode: .fill) // más cuadradito
                    } placeholder: {
                        Color.gray.opacity(0.3)
                    }
                    .frame(width: 280, height: 200) // más cuadrado
                    .clipped()
                    .cornerRadius(12)
                }

                // Botón Play
                Button(action: { showPlayer = true }) {
                    Circle()
                        .fill(Color.black.opacity(0.6))
                        .frame(width: 50, height: 50)
                        .overlay(
                            Image(systemName: "play.fill")
                                .foregroundColor(.white)
                                .font(.system(size: 24, weight: .bold))
                        )
                }
            }
            .frame(width: 280, height: 200)
            .cornerRadius(12)

            // Título del video + menú
            HStack(alignment: .top, spacing: 8) {
                Text(video.titulo ?? "Sin título")
                    .font(.title3)
                    .bold()
                    .foregroundColor(.primary)
                    .lineLimit(3)
                    .frame(maxWidth: .infinity, alignment: .leading)

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

            Divider() // línea divisoria

            // Pie de tarjeta: sección + hora
            HStack {
                Text(video.seccion ?? "SIGLO TV")
                    .font(.caption)
                    .bold()
                    .foregroundColor(.primary)
                    .lineLimit(1)
                    .truncationMode(.tail)

                Spacer()

                HStack(spacing: 4) {
                    Image(systemName: "clock")
                        .font(.caption2)
                    Text(video.fechaformato ?? "")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }

        }
        .padding(.all, 12)           // padding interno más cómodo
        .padding(.bottom, 10)        // espacio adicional al final
        .frame(width: 280)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
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
}
