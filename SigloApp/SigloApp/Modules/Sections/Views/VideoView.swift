import SwiftUI

struct VideoView: View {
    let video: SectionVideo

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            if let cover = video.cover,
               let url = URL(string: cover),
               let videoURL = video.url,
               let linkURL = URL(string: videoURL) {

                ZStack {
                    AsyncImage(url: url) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    } placeholder: {
                        Color.gray.opacity(0.3)
                    }
                    .frame(height: 200)
                    .clipped()
                    .cornerRadius(12)

                    Link(destination: linkURL) {
                        Circle()
                            .fill(Color.black.opacity(0.4))
                            .frame(width: 60, height: 60)
                            .overlay(
                                Image(systemName: "play.fill")
                                    .foregroundColor(.white)
                                    .font(.system(size: 28, weight: .bold))
                            )
                            .shadow(radius: 5)
                    }
                }
            }

            Text(video.titulo ?? "Sin título")
                .font(.headline)

            if let contenido = video.contenido {
                Text(contenido)
                    .font(.subheadline)
                    .lineLimit(3)
            }

            Divider()
        }
        .padding()
    }
}
