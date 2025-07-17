import SwiftUI

struct VideoCard: View {
    let video: SectionVideo

    var body: some View {
        // Validamos que tenga cover y url para el video
        if let cover = video.cover,
           let coverURL = URL(string: cover),
           let videoURL = video.url,
           let linkURL = URL(string: videoURL) {

            ZStack {
                // Imagen de portada
                AsyncImage(url: coverURL) { image in
                    image
                        .resizable()
                        .aspectRatio(16/9, contentMode: .fill)
                } placeholder: {
                    Color.gray.opacity(0.3)
                }
                .frame(width: 280, height: 160)
                .clipped()
                .cornerRadius(12)

                // Botón play con fondo semitransparente tipo glass
                Link(destination: linkURL) {
                    Circle()
                        .fill(Color.black.opacity(0.4))
                        .frame(width: 50, height: 50)
                        .overlay(
                            Image(systemName: "play.fill")
                                .foregroundColor(.white)
                                .font(.system(size: 24, weight: .bold))
                        )
                }
            }
            .frame(width: 280)
        } else {
            // Si no tiene cover o url, mostramos nada o un placeholder vacío
            EmptyView()
        }
    }
}
