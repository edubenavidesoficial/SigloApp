import SwiftUI

struct SeccionesHomeView: View {
    @ObservedObject var viewModel: HomeViewModel
    @ObservedObject var articleViewModel: ArticleViewModel

    var body: some View {
        ForEach(viewModel.secciones.filter { $0.seccion == "México, EUA y Mundo" }, id: \.seccion) { seccion in
            Section {
                let notas = seccion.notas ?? []
                TabView {
                    ForEach(notas, id: \.id) { nota in
                        HStack(alignment: .top, spacing: 12) {
                            VStack(alignment: .leading, spacing: 6) {
                                // Línea roja antes del texto
                                HStack {
                                    Rectangle()
                                        .fill(Color.red)
                                        .frame(width: 4, height: 14)

                                    Text(nota.localizador)
                                        .font(.caption)
                                        .foregroundColor(.red)

                                    Spacer()

                                    // Botón de menú con los tres puntos
                                    Menu {
                                        Button(action: {
                                            compartirNota(nota)
                                        }) {
                                            Label("Compartir", systemImage: "square.and.arrow.up")
                                        }

                                        Button(action: {
                                            guardarNota(nota)
                                        }) {
                                            Label("Guardar", systemImage: "bookmark")
                                        }
                                    } label: {
                                        Image(systemName: "ellipsis")
                                            .foregroundColor(.gray)
                                            .padding(.trailing, 8)
                                    }
                                }

                                // Título en negrita
                                Text(nota.titulo)
                                    .font(.headline)
                                    .foregroundColor(.primary)
                                    .lineLimit(2)

                                // Autor en gris
                                Text(nota.autor)
                                    .font(.caption)
                                    .foregroundColor(.gray)

                                // Sección en rojo
                                HStack(spacing: 8) {
                                    Text(seccion.seccion ?? "Siglo")
                                        .foregroundColor(.red)
                                        .font(.caption)
                                }
                            }

                            Spacer()

                            ZStack(alignment: .bottomTrailing) {
                                if let foto = nota.fotos.first {
                                    FotoView(foto: foto)
                                        .scaledToFill()
                                        .frame(width: 100, height: 100) // Tamaño cuadrado
                                        .clipped()
                                        .cornerRadius(8)
                                }

                                Label("07:35 hrs", systemImage: "clock")
                                    .foregroundColor(.secondary)
                                    .font(.caption)
                                    .padding(4)
                            }
                        }
                        .padding()
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
                .frame(height: 160)
            }
        }

        // Mostrar los artículos guardados
        VStack {
            Text("Artículos Guardados")
                .font(.headline)
            ForEach(articleViewModel.savedArticles, id: \.title) { article in
                Text(article.title)
                    .padding()
            }
        }
    }

    func compartirNota(_ nota: Nota) {
        print("Compartir: \(nota.titulo)")
        // Aquí puedes implementar el sistema de compartir
    }

    func guardarNota(_ nota: Nota) {
        print("Guardar: \(nota.titulo)")

        // Crear y guardar el artículo
        let savedArticle = SavedArticle(
            category: "Nacional",
            title: nota.titulo,
            author: nota.autor,
            location: "Desconocido",
            time: "Hace 1h",
            imageName: "ejemplo",
            description: nil
        )

        // Guardar el artículo en el ArticleViewModel
        articleViewModel.saveArticle(savedArticle)
    }
}
