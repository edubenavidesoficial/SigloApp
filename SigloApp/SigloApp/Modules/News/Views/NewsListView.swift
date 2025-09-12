import SwiftUI

struct NewsListView: View {
    @EnvironmentObject var articleViewModel: ArticleViewModel
    @State private var noticias: [NewsArticle] = []
    @State private var isLoading = true
    @State private var errorMessage: String?

    var body: some View {
        NavigationStack {
            if isLoading {
                ProgressView("Cargando noticias...")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if let error = errorMessage {
                Text("Error: \(error)")
                    .foregroundColor(.red)
                    .multilineTextAlignment(.center)
                    .padding()
            } else {
                List(noticias, id: \.id) { noticia in
                    NavigationLink(
                        destination: NewsDetailView(idNoticia: noticia.sid, articleViewModel: articleViewModel)
                    ) {
                        Text(noticia.titulo)
                            .lineLimit(2)
                            .font(.headline)
                    }
                }
                .listStyle(PlainListStyle())
                .navigationTitle("Noticias")
            }
        }
        .onAppear(perform: fetchNoticias)
    }

    func fetchNoticias() {
        isLoading = true
        errorMessage = nil
        
        // Aquí obtienes varias noticias; ejemplo usando un id de prueba
        NewsService.shared.obtenerNoticia(idNoticia: 2343332) { result in
            switch result {
            case .success(let noticia):
                self.noticias = [noticia] // Puedes reemplazarlo por un array real
            case .failure(let error):
                self.errorMessage = error.localizedDescription
            }
            self.isLoading = false
        }
    }
}
