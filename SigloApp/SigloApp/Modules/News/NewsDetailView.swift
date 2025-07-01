import SwiftUI

struct NewsDetailView: View {
    let idNoticia: Int
    @Environment(\.presentationMode) var presentationMode

    @State private var noticia: NewsArticle?
    @State private var errorMessage: String?
    @State private var isLoading = true

    var body: some View {
        VStack(spacing: 0) {
            // Barra personalizada
            CustomTopBar {
                presentationMode.wrappedValue.dismiss()
            }

            Divider()

            Group {
                if isLoading {
                    Spacer()
                    ProgressView("Cargando...")
                    Spacer()
                } else if let noticia = noticia {
                    ScrollView {
                        VStack(alignment: .leading, spacing: 16) {

                            // Categoría y Título
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

                            // Datos del autor y fecha
                            HStack(spacing: 8) {
                                VStack(alignment: .leading, spacing: 2) {
                                    Text("AGENCIA")
                                        .font(.caption)
                                        .bold()

                                    Text("Publicado el \(noticia.fechamod)")
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                }

                                Spacer()

                                Label("+99", systemImage: "text.bubble")
                                    .font(.caption)
                                    .foregroundColor(.black)
                            }

                            // Imagen con pie de foto
                            VStack(spacing: 4) {
                                Image("LS")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .cornerRadius(8)

                                Text("Paso de Ciclón John por el Pacífico mexicano")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                                    .frame(maxWidth: .infinity, alignment: .trailing)
                            }

                            // Autor
                            Text(noticia.autor ?? "")
                                .font(.subheadline)
                                .foregroundColor(.gray)

                            // Contenido HTML (flexible entre String y Array)
                            HTMLWebView(htmlContent: formatContenido(noticia.contenido))
                                .frame(minHeight: 600)
                        }
                        .padding()
                    }
                } else {
                    Text(errorMessage ?? "Error al cargar la noticia")
                        .foregroundColor(.red)
                        .padding()
                }
            }
        }
        .ignoresSafeArea(edges: .top)
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
    }

    // MARK: - Helper
    func formatContenido(_ contenido: Any?) -> String {
        if let texto = contenido as? String {
            return texto
        } else if let parrafos = contenido as? [String] {
            return parrafos.joined(separator: "<br><br>")
        } else {
            return "<p>Contenido no disponible</p>"
        }
    }
}
