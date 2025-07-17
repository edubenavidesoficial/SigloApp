import SwiftUI

struct NewsDetailView: View {
    let idNoticia: Int
    @Environment(\.presentationMode) var presentationMode

    @State private var noticia: NewsArticle?
    @State private var errorMessage: String?
    @State private var isLoading = true

    var body: some View {
        ZStack(alignment: .top) {
            VStack(spacing: 0) {
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
                            .padding(.top, 30)

                            // Datos del autor y fecha
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

                                Label("+99", systemImage: "text.bubble")
                                    .font(.caption)
                                    .foregroundColor(.black)
                            }

                            // Imagen con pie de foto
                            VStack(spacing: 2) {
                                ForEach(noticia.fotos.compactMap { $0.url_foto }, id: \.self) { urlString in
                                    if let url = URL(string: urlString) {
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
                                    }
                                }

                                // Si quieres mostrar solo la primera foto con su pie de foto:
                                if let firstPhoto = noticia.fotos.first,
                                   let urlString = firstPhoto.url_foto,
                                   let url = URL(string: urlString) {
                                    VStack {
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
                                        if let pie = firstPhoto.pie_foto, !pie.isEmpty {
                                            Text(pie)
                                                .font(.caption)
                                                .foregroundColor(.gray)
                                                .frame(maxWidth: .infinity, alignment: .trailing)
                                        }
                                    }
                                }
                            }
                            Spacer()
                            // Autor
                            Text(noticia.autor ?? "")
                                .font(.subheadline)
                                .foregroundColor(.gray)

                            // Contenido
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

            // ✅ Top bar seguro con iOS 17
            CustomTopBar {
                presentationMode.wrappedValue.dismiss()
            }
            .padding(.top, -20)
            .background(.white)
            .shadow(radius: 4)
            .safeAreaInset(edge: .top) {
                Color.clear.frame(height: 0) // ocupa espacio pero no dibuja nada
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
    }

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
