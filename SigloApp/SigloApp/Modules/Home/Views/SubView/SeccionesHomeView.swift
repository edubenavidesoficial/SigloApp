import SwiftUI

struct SeccionesHomeView: View {
    @ObservedObject var viewModel: HomeViewModel
    @ObservedObject var articleViewModel: ArticleViewModel
    @StateObject var articleActionHelper: ArticleActionHelper // Usamos ArticleActionHelper

    init(viewModel: HomeViewModel, articleViewModel: ArticleViewModel) {
        self.viewModel = viewModel
        self.articleViewModel = articleViewModel
        _articleActionHelper = StateObject(wrappedValue: ArticleActionHelper(articleViewModel: articleViewModel)) // Inicializamos el helper
    }
    
    var body: some View {
        VStack {
            ForEach(viewModel.secciones.filter { $0.seccion == "México, EUA y Mundo" }, id: \.seccion) { seccion in
                Section {
                    let notas = seccion.notas ?? []
                    ForEach(notas, id: \.id) { nota in
                        HStack(alignment: .top, spacing: 12) {
                            VStack(alignment: .leading, spacing: 6) {
                                HStack {
                                    Rectangle()
                                        .fill(Color.red)
                                        .frame(width: 4, height: 14)

                                    Text(nota.localizador)
                                        .font(.caption)
                                        .foregroundColor(.red)

                                    Spacer()

                                    Menu {
                                        Button(action: {
                                            articleActionHelper.compartirNota(nota) // Usamos la función compartirNota del helper
                                        }) {
                                            Label("Compartir", systemImage: "square.and.arrow.up")
                                        }

                                        Button(action: {
                                            articleActionHelper.guardarNota(nota) // Usamos la función guardarNota del helper
                                        }) {
                                            Label("Guardar", systemImage: "bookmark")
                                        }
                                    } label: {
                                        Image(systemName: "ellipsis")
                                            .foregroundColor(.gray)
                                            .padding(.trailing, 8)
                                    }
                                }

                                Text(nota.titulo)
                                    .font(.headline)
                                    .foregroundColor(.primary)
                                    .lineLimit(2)

                                Text(nota.autor)
                                    .font(.caption)
                                    .foregroundColor(.gray)

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
                                        .frame(width: 100, height: 100)
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
            }
            
            ForEach(articleViewModel.savedArticles, id: \.title) { article in
                NewsRow(article: article)  // Pasamos un solo artículo
            }

        }
    }
}
