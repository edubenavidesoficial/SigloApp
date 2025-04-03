import SwiftUI

import SwiftUI

struct PrintCarouselView: View {
    @ObservedObject var viewModel: PrintViewModel

    var body: some View {
        TabView {
            ForEach(viewModel.articlesForCurrentTab()) { article in
                VStack {
                    // Verifica si la imagen es remota o local
                    AsyncImage(url: URL(string: article.imageName)) { phase in
                        if let image = phase.image {
                            image.resizable()
                                 .scaledToFit()
                                 .cornerRadius(12)
                                 .shadow(color: .black.opacity(0.4), radius: 8, x: 0, y: 5) // Sombreado en la imagen
                        } else if phase.error != nil {
                            // Imagen predeterminada si hay un error
                            Image(systemName: "exclamationmark.triangle.fill")
                                .resizable()
                                .scaledToFit()
                                .cornerRadius(12)
                                .shadow(color: .black.opacity(0.4), radius: 8, x: 0, y: 5) // Sombreado en la imagen
                        } else {
                            ProgressView() // Indicador de carga
                                .progressViewStyle(CircularProgressViewStyle(tint: .gray))
                        }
                    }

                    HStack {
                        Text(article.date)
                            .font(.caption2)
                            .foregroundColor(.gray)

                            .padding(.leading, 2)
                        // Icono de descarga
                        Image(systemName: "arrow.down.circle.fill")
                            .foregroundColor(.black)
                            .font(.caption2)
                    }
                    .padding(.top, 4)
                }
            }
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never)) // Eliminar los indicadores de página
        .frame(height: 470) // Limita la altura total del carrusel
    }
}
