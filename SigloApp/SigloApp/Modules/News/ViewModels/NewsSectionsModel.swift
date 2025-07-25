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
                        } else {
                            NewsRelaRow(nota: relacionadas[index], articleActionHelper: articleActionHelper)
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
            .padding(.horizontal, 14)
        }
    }
}

struct NewsSmallHorizontalRow: View {
    let nota: Nota
    let articleActionHelper: ArticleActionHelper
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            // Encabezado con barra roja, texto y menú
            HStack {
                Rectangle()
                    .fill(Color.red)
                    .frame(width: 4, height: 14)
                
                Text(nota.localizador)
                    .font(.caption)
                    .foregroundColor(.red)
                
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
                }
            }
            .padding([.horizontal, .top])
            
            // Contenido de la nota
            VStack(alignment: .leading, spacing: 4) {
                Text(nota.titulo)
                    .font(.custom("FiraSansCondensed-Regular", size: 14))
                    .foregroundColor(.primary)
                    .lineLimit(2)
                
                Text(nota.balazo ?? "")
                    .font(.custom("FiraSansCondensed-Regular", size: 12))
                    .foregroundColor(.primary)
                    .lineLimit(2)
            }
            .padding(.horizontal)
            
            Spacer()
            
            // Footer
            HStack {
                Text(nota.autor)
                    .font(.caption)
                    .bold()
                    .foregroundColor(.brown)
                
                Spacer()
                
                HStack(spacing: 4) {
                    Image(systemName: "clock")
                        .foregroundColor(.gray)
                    Text(nota.fecha_formato ?? "")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }
            .padding(.horizontal, 8)
            .padding(.vertical, 6)
        }
        .frame(width: 240)
        .background(Color.white)
        .cornerRadius(10)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.gray.opacity(0.2), lineWidth: 1)
        )
        .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
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
            .padding(.horizontal, 14)
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
            .padding(.horizontal, 14)
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
                if let foto = foto, let urlString = foto.url_foto, let url = URL(string: urlString), !urlString.isEmpty {
                    AsyncImage(url: url) { phase in
                        switch phase {
                        case .success(let image):
                            image
                                .resizable()
                                .scaledToFill()
                        case .failure(_):
                            Color.gray.opacity(0.2)
                        case .empty:
                            ProgressView()
                        @unknown default:
                            Color.gray.opacity(0.2)
                        }
                    }
                    .frame(width: size.width, height: size.height)
                    .clipped()
                    .cornerRadius(8)
                } else {
                    Color.gray.opacity(0.1)
                        .frame(width: size.width, height: size.height)
                        .cornerRadius(8)
                }
            }
            
             if let pie = foto?.pie_foto, !pie.isEmpty {
                Text(pie)
                    .font(.caption2)
                    .foregroundColor(.gray)
                    .frame(width: size.width, alignment: .leading)
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


struct NewsGallery: View {
    let galleryImageUrl: String
    let galleryCount: Int
    @Binding var showComments: Bool 

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("HURACÁN JOHN: LOS DAÑOS QUE DEJA TRAS SU PASO EN GUERRERO")
                .font(.headline)
                .padding(.horizontal)

            ZStack(alignment: .bottomLeading) {
                ImageLoaderView(imageURL: galleryImageUrl)
                    .aspectRatio(contentMode: .fill)
                    .frame(height: 200)
                    .clipped()

                
                Rectangle()
                    .fill(Color.black.opacity(0.4))
                    .frame(height: 200)

                Text("+\(galleryCount)")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding()
                    .offset(x: UIScreen.main.bounds.width * 0.5 - 50, y: 0)

            }
            .cornerRadius(8)
            .padding(.horizontal)

            Button(action: {
                showComments = true
            }) {
                Text("LEER COMENTARIOS")
                    .font(.headline)
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                    )
            }
            .padding(.horizontal)
            .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
        }
    }
}

struct ImageLoaderView: View {
    let imageURL: String
    @State private var image: UIImage? = nil
    @State private var isLoading: Bool = false
    @State private var error: Error? = nil

    var body: some View {
        Group {
            if let image = image {
                Image(uiImage: image)
                    .resizable()
            } else if isLoading {
                ProgressView()
            } else {
                Image(systemName: "photo")
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(.gray)
            }
        }
        .onAppear(perform: loadImage)
    }

    private func loadImage() {
        guard image == nil && !isLoading else { return }

        isLoading = true
        guard let url = URL(string: imageURL) else {
            error = URLError(.badURL)
            isLoading = false
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                self.isLoading = false
                if let data = data, let uiImage = UIImage(data: data) {
                    self.image = uiImage
                } else if let error = error {
                    self.error = error
                    print("Error loading image: \(error.localizedDescription)")
                }
            }
        }.resume()
    }
}

