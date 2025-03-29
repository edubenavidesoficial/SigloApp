import SwiftUI

struct NewsRow: View {
    var article: SavedArticle

    //let article: SavedArticle

    var body: some View {
        Text(article.title)
            .padding()
        HStack(alignment: .top, spacing: 12) {
            // Imagen con ícono de bookmark
            ZStack(alignment: .topTrailing) {
                Image(article.imageName)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 120, height: 80)
                    .clipped()
                    .cornerRadius(8)

                Image(systemName: "bookmark.fill")
                    .foregroundColor(.black)
                    .padding(6)
            }

            VStack(alignment: .leading, spacing: 6) {
                // Etiqueta roja
                Text(article.category.uppercased())
                    .font(.caption)
                    .foregroundColor(.red)

                // Título
                Text(article.title)
                    .font(.headline)
                    .foregroundColor(.primary)
                    .lineLimit(2)

                // Autor
                Text(article.author)
                    .font(.caption)
                    .foregroundColor(.gray)

                // Ubicación y hora
                HStack(spacing: 8) {
                    Text(article.location.uppercased())
                        .foregroundColor(.red)
                        .font(.caption)

                    Label(article.time, systemImage: "clock")
                        .foregroundColor(.secondary)
                        .font(.caption)
                }
            }
        }
        .padding() // Agregar padding para separar el contenido
    }
}
