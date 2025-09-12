import SwiftUI

struct NewsDetailView: View {
    let idNoticia: Int
    @StateObject private var viewModel = HomeViewModel()
    @StateObject private var articleViewModel: ArticleViewModel
    @StateObject private var articleActionHelper: ArticleActionHelper

    @Environment(\.presentationMode) var presentationMode

    @State private var noticia: NewsArticle?
    @State private var errorMessage: String?
    @State private var isLoading = true

    // MARK: - Init
    init(idNoticia: Int, articleViewModel: ArticleViewModel) {
        self.idNoticia = idNoticia
        _articleViewModel = StateObject(wrappedValue: articleViewModel)
        _articleActionHelper = StateObject(wrappedValue: ArticleActionHelper(articleViewModel: articleViewModel))
    }

    var body: some View {
        ZStack(alignment: .top) {
            VStack(spacing: 0) {
                if isLoading {
                    Spacer()
                    ProgressView("Cargando...")
                    Spacer()
                } else if let noticia = noticia {
                    ScrollView {
                        VStack(alignment: .leading, spacing: 15) {
                            // Categoría y título
                            VStack(alignment: .leading, spacing: 8) {
                                Text(noticia.localizador)
                                    .font(.caption)
                                    .foregroundColor(.red)
                                    .bold()
                                Text(noticia.titulo)
                                    .font(.title3)
                                    .fontWeight(.bold)
                                Text(noticia.balazo ?? "")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                            .padding(.horizontal, 16)
                            .padding(.top, 60)

                            // Autor y fecha
                            HStack(spacing: 3) {
                                VStack(alignment: .leading, spacing: 2) {
                                    Text("AGENCIA")
                                        .font(.caption)
                                        .bold()
                                    Text("Publicado el \(noticia.fechamod)")
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                }
                                Spacer()
                            }
                            .padding(.horizontal, 16)

                            // Fotos
                            VStack(spacing: 2) {
                                ForEach(noticia.fotos) { foto in
                                    if let urlString = foto.url_foto, let url = URL(string: urlString) {
                                        AsyncImage(url: url) { phase in
                                            switch phase {
                                            case .empty:
                                                ProgressView()
                                                    .frame(height: 250)
                                            case .success(let image):
                                                image
                                                    .resizable()
                                                    .aspectRatio(contentMode: .fit)
                                                    .cornerRadius(8)
                                            case .failure:
                                                Image(systemName: "photo")
                                                    .resizable()
                                                    .aspectRatio(contentMode: .fit)
                                                    .foregroundColor(.gray)
                                            @unknown default:
                                                EmptyView()
                                            }
                                        }
                                        .padding(.horizontal, 16)

                                        if let pie = foto.pie_foto, !pie.isEmpty {
                                            Text(pie)
                                                .font(.caption)
                                                .foregroundColor(.gray)
                                                .frame(maxWidth: .infinity, alignment: .trailing)
                                                .padding(.horizontal, 16)
                                        }
                                    }
                                }
                            }

                            // Contenido HTML
                            HTMLWebView(htmlContent: formatContenido(noticia.contenido))
                                .frame(minHeight: 600)
                                .padding(.horizontal, 5)
                        }
                        .padding(.bottom, 20)
                    }
                } else {
                    Text(errorMessage ?? "Error al cargar la noticia")
                        .foregroundColor(.red)
                        .padding()
                }
            }

            // Barra superior con botones de acción
            if let noticia = noticia {
                let nota = mapNoticiaToNota(noticia)

                CustomTopBar(
                    onBack: { presentationMode.wrappedValue.dismiss() },
                    nota: nota,
                    articleActionHelper: articleActionHelper
                )
                .padding(.top, -20)
                .background(Color.black)
                .shadow(radius: 4)
            }
        }
        .navigationBarBackButtonHidden(true)
        .onAppear {
            NewsService.shared.obtenerNoticia(idNoticia: idNoticia) { result in
                switch result {
                case .success(let noticia):
                    self.noticia = noticia
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                }
                self.isLoading = false
            }
        }
        // Sheet para compartir nota
        .sheet(isPresented: $articleActionHelper.showShareSheet) {
            ActivityView(activityItems: articleActionHelper.shareContent)
        }
    }

    // MARK: - Helpers

    func formatContenido(_ contenido: Any?) -> String {
        if let texto = contenido as? String {
            return texto
        } else if let parrafos = contenido as? [String] {
            return parrafos.joined(separator: "<br><br>")
        } else {
            return "<p>Contenido no disponible</p>"
        }
    }

    func mapNoticiaToNota(_ noticia: NewsArticle) -> Nota {
        let fotosConvertidas: [Foto] = noticia.fotos.map { foto in
            Foto(
                id: UUID(),
                url_foto: foto.url_foto,
                pie_foto: foto.pie_foto
            )
        }

        return Nota(
            id: noticia.sid,
            fecha: noticia.fecha,
            fechamod: noticia.fechamod,
            fecha_formato: noticia.fecha_formato,
            titulo: noticia.titulo,
            localizador: noticia.localizador,
            balazo: noticia.balazo,
            autor: noticia.autor,
            ciudad: noticia.ciudad,
            contenido: noticia.contenido,
            fotos: fotosConvertidas
        )
    }
}
