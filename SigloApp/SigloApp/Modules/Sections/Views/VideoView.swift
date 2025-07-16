import SwiftUI

struct VideoView: View {
    let video: SectionVideo

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            if let cover = video.cover, let url = URL(string: cover) {
                AsyncImage(url: url) { image in
                    image.resizable().aspectRatio(contentMode: .fill)
                } placeholder: {
                    Color.gray.opacity(0.3)
                }
                .frame(height: 200)
                .clipped()
                .cornerRadius(8)
            }

            Text(video.titulo ?? "Sin título")
                .font(.headline)

            if let contenido = video.contenido {
                Text(contenido)
                    .font(.subheadline)
                    .lineLimit(3)
            }

            if let videoURL = video.url, let url = URL(string: videoURL) {
                Link("Ver video", destination: url)
                    .foregroundColor(.blue)
            }

            Divider()
        }
        .padding()
    }
}
