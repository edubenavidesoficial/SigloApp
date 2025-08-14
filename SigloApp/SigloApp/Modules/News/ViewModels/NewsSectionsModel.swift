import SwiftUI

struct NewsSectionsModel: View {
    let relacionadas: [Nota]
    let mas_notas: [Nota]
    @ObservedObject var articleViewModel: ArticleViewModel
    @StateObject var articleActionHelper: ArticleActionHelper
    @State private var showCommentsSheet = false  

    init(relacionadas: [Nota], mas_notas: [Nota], articleViewModel: ArticleViewModel) {
        self.relacionadas = relacionadas
        self.mas_notas = mas_notas
        self.articleViewModel = articleViewModel
        _articleActionHelper = StateObject(wrappedValue: ArticleActionHelper(articleViewModel: articleViewModel))
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            
            // --- Gallery Section ---
            let galleryUrl = relacionadas.first?.fotos.first?.url_foto ?? mas_notas.first?.fotos.first?.url_foto ?? ""
            NewsGallery(
                galleryImageUrl: galleryUrl,
                galleryCount: relacionadas.count + mas_notas.count,
                showComments: $showCommentsSheet
            )

            // --- Noticias Relacionadas ---
            if !relacionadas.isEmpty {
                Text("NOTICIAS RELACIONADAS")
                    .font(.headline)
                    .padding(.horizontal)
                
                VStack(spacing: 12) {
                    
                    ForEach(relacionadas.indices, id: \.self) { index in
                        if index == 0 {
                            NewsBigImageRow(nota: relacionadas[index], articleActionHelper: articleActionHelper)
                                .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
                        } else {
                            NewsRelaRow(nota: relacionadas[index], articleActionHelper: articleActionHelper)
                                .background(Color(.systemBackground))
                                .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
                        }
                    }
                }
            }
            
            // --- Más Noticias de Nacional ---
            if !mas_notas.isEmpty {
                Text("MÁS NOTICIAS DE NACIONAL")
                    .font(.headline)
                    .padding(.horizontal)
                
                VStack(spacing: 12) {
                    // Primera noticia grande
                    if let first = mas_notas.first {
                        NewsBigImageRow(nota: first, articleActionHelper: articleActionHelper)
                    }
                    
                    // Carrusel para siguientes 3
                    if mas_notas.count > 1 {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 16) {
                                ForEach(mas_notas.dropFirst().prefix(3), id: \.id) { nota in
                                    NewsSmallHorizontalRow(nota: nota, articleActionHelper: articleActionHelper)
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                    
                    // Resto con estilo clásico
                    if mas_notas.count > 4 {
                        ForEach(mas_notas.dropFirst(4), id: \.id) { nota in
                            NewsMasRow(nota: nota, articleActionHelper: articleActionHelper)
                                .background(Color(.systemBackground))
                                .cornerRadius(8)
                                .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
                        }
                    }
                }
            }
        }
        .sheet(isPresented: $showCommentsSheet) {
            NewsCommentsSheet()
                .presentationDetents([.fraction(0.8), .large])
        }
    }
}
