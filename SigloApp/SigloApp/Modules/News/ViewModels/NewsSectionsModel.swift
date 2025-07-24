import SwiftUI

struct NewsSectionsModel: View {
    let relacionadas: [Nota]
    let mas_notas: [Nota]
    @ObservedObject var articleViewModel: ArticleViewModel
    @StateObject var articleActionHelper: ArticleActionHelper
    
    init(relacionadas: [Nota], mas_notas: [Nota], articleViewModel: ArticleViewModel) {
        self.relacionadas = relacionadas
        self.mas_notas = mas_notas
        self.articleViewModel = articleViewModel
        _articleActionHelper = StateObject(wrappedValue: ArticleActionHelper(articleViewModel: articleViewModel))
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            
            // --- Noticias Relacionadas ---
            if !relacionadas.isEmpty {
                Text("NOTICIAS RELACIONADAS")
                    .font(.headline)
                    .padding(.horizontal)
                
                VStack(spacing: 12) {
                    ForEach(relacionadas.indices, id: \.self) { index in
                        if index == 0 {
                            NewsBigImageRow(nota: relacionadas[index], articleActionHelper: articleActionHelper)
                        } else {
                            NewsRelaRow(nota: relacionadas[index], articleActionHelper: articleActionHelper)
                        }
                    }
                }
                .padding(.horizontal)
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
                .padding(.horizontal)
            }
        }
    }
}

struct NewsBigImageRow: View {
    let nota: Nota
    let articleActionHelper: ArticleActionHelper
    
    var body: some View {
        NavigationLink(destination: NewsDetailView(idNoticia: nota.id)) {
            VStack(alignment: .leading, spacing: 8) {
                NotaImageView(
                    foto: nota.fotos.first,
                    size: CGSize(width: UIScreen.main.bounds.width - 32, height: 200),
                    fecha: nota.fecha_formato
                )
                Text(nota.titulo)
                    .font(.custom("FiraSansCondensed-Regular", size: 20))
                    .foregroundColor(.primary)
                    .lineLimit(2)
                Text(nota.autor)
                    .font(.caption)
                    .foregroundColor(.gray)
            }
        }
    }
}

struct NewsSmallHorizontalRow: View {
    let nota: Nota
    let articleActionHelper: ArticleActionHelper
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            NewsImageView(
                foto: nota.fotos.first,
                size: CGSize(width: 120, height: 120),
                fecha: nota.fecha_formato
            )
            Text(nota.titulo)
                .font(.custom("FiraSansCondensed-Regular", size: 14))
                .foregroundColor(.primary)
                .lineLimit(2)
        }
        .frame(width: 120)
    }
}

struct NewsRelaRow: View {
    let nota: Nota
    let articleActionHelper: ArticleActionHelper
    
    var body: some View {
        NavigationLink(destination: NewsDetailView(idNoticia: nota.id)) {
            HStack(alignment: .top, spacing: 12) {
                VStack(alignment: .leading, spacing: 6) {
                    HStack {
                        Rectangle().fill(Color.red).frame(width: 4, height: 14)
                        Text(nota.localizador).font(.caption).foregroundColor(.red)
                        Spacer()
                        Menu {
                            Button { articleActionHelper.compartirNota(nota) } label: {
                                Label("Compartir", systemImage: "square.and.arrow.up")
                            }
                            Button { articleActionHelper.guardarNota(nota) } label: {
                                Label("Guardar", systemImage: "bookmark")
                            }
                        } label: {
                            Image(systemName: "ellipsis")
                                .foregroundColor(.gray)
                                .padding(.trailing, 10)
                        }
                    }
                    
                    Text(nota.titulo)
                        .font(.custom("FiraSansCondensed-Regular", size: 18))
                        .foregroundColor(.primary)
                        .lineLimit(2)
                    
                    Text(nota.autor)
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                
                Spacer()
                
                NewsImageView(foto: nota.fotos.first,
                              size: CGSize(width: 100, height: 100),
                              fecha: nota.fecha_formato)
            }
            .padding(.horizontal)
            .padding(.vertical, 8)
        }
    }
}

struct NewsMasRow: View {
    let nota: Nota
    let articleActionHelper: ArticleActionHelper
    
    var body: some View {
        NavigationLink(destination: NewsDetailView(idNoticia: nota.id)) {
            HStack(alignment: .top, spacing: 12) {
                VStack(alignment: .leading, spacing: 6) {
                    HStack {
                        Rectangle().fill(Color.red).frame(width: 4, height: 14)
                        Text(nota.localizador).font(.caption).foregroundColor(.red)
                        Spacer()
                        Menu {
                            Button { articleActionHelper.compartirNota(nota) } label: {
                                Label("Compartir", systemImage: "square.and.arrow.up")
                            }
                            Button { articleActionHelper.guardarNota(nota) } label: {
                                Label("Guardar", systemImage: "bookmark")
                            }
                        } label: {
                            Image(systemName: "ellipsis")
                                .foregroundColor(.gray)
                                .padding(.trailing, 10)
                        }
                    }
                    
                    Text(nota.titulo)
                        .font(.custom("FiraSansCondensed-Regular", size: 18))
                        .foregroundColor(.primary)
                        .lineLimit(2)
                    
                    Text(nota.autor)
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                
                Spacer()
                
                NewsImageView(foto: nota.fotos.first,
                              size: CGSize(width: 100, height: 100),
                              fecha: nota.fecha_formato)
            }
            .padding(.horizontal)
            .padding(.vertical, 8)
        }
    }
}



struct NewsImageView: View {
    let foto: Foto?
    let size: CGSize
    let fecha: String?
    
    var body: some View {
        VStack(alignment: .trailing, spacing: 4) {
            ZStack {
                if let foto = foto {
                    AsyncImage(url: URL(string: foto.url_foto ?? "")) { phase in
                        switch phase {
                        case .success(let image):
                            image.resizable()
                        case .failure(_):
                            Color.gray.opacity(0.2)
                        default:
                            ProgressView()
                        }
                    }
                    .scaledToFill()
                    .frame(width: size.width, height: size.height)
                    .clipped()
                    .cornerRadius(8)
                }
                else {
                    Color.gray.opacity(0.1)
                        .frame(width: size.width, height: size.height)
                        .cornerRadius(8)
                }
            }
            
            if let fecha = fecha {
                HStack {
                    Spacer()
                    Label("\(fecha) hrs", systemImage: "clock")
                        .foregroundColor(.black)
                        .font(.caption)
                        .padding(4)
                        .cornerRadius(6)
                }
                .frame(width: size.width)
            }
        }
    }
}
