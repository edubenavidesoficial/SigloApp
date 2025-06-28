import SwiftUI

struct NewsDetailView: View {
    let idNoticia: Int
    @State private var noticia: NewsArticle?
    @State private var errorMessage: String?
    @State private var isLoading = true

    var body: some View {
        Group {
            if isLoading {
                ProgressView("Cargando...")
            } else if let noticia = noticia {
                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        Text(noticia.titulo).font(.title).bold()
                        Text(noticia.autor ?? "").font(.subheadline).foregroundColor(.gray)
                        ForEach(noticia.contenido, id: \.self) {
                            Text($0)
                        }
                    }
                    .padding()
                }
            } else {
                Text(errorMessage ?? "Error")
            }
        }
        .navigationTitle("Detalle")
        .onAppear {
            NewsService.shared.obtenerNoticia(idNoticia: idNoticia) { result in
                switch result {
                case .success(let noticia): self.noticia = noticia
                case .failure(let error): self.errorMessage = error.localizedDescription
                }
                self.isLoading = false
            }
        }
    }
}

