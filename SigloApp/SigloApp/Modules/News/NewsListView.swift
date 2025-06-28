import SwiftUI

struct NewsListView: View {
    @State private var noticias: [NewsArticle] = []
    @State private var isLoading = true
    @State private var errorMessage: String?

    var body: some View {
        NavigationStack {
            List(noticias, id: \.id) { noticia in
                NavigationLink(destination: NewsDetailView(idNoticia: noticia.id)) {
                    Text(noticia.titulo)
                        .lineLimit(2)
                }
            }
            .navigationTitle("Noticias")
            .onAppear(perform: fetchNoticias)
        }
    }

    func fetchNoticias() {
        isLoading = true
        errorMessage = nil
        
        // Reutilizando NewsService para obtener múltiples artículos si tienes endpoint
        // Aquí es solo un ejemplo fijo, reemplaza por el tuyo
        NewsService.shared.obtenerNoticia(idNoticia: 2343332) { result in
            switch result {
            case .success(let noticia):
                self.noticias = [noticia] // Puedes reemplazar esto con un array real
            case .failure(let error):
                self.errorMessage = error.localizedDescription
            }
            self.isLoading = false
        }
    }
}
