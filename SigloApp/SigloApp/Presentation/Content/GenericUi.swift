import SwiftUI

struct NotaRow: View {
    let nota: Nota
    let seccion: String
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
                            Button {
                                articleActionHelper.compartirNota(nota)
                            } label: {
                                Label("Compartir", systemImage: "square.and.arrow.up")
                            }
                            Button {
                                articleActionHelper.guardarNota(nota)
                            } label: {
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
                    
                    Text(seccion)
                        .foregroundColor(.red)
                        .font(.caption)
                }
                
                Spacer()
                
                NotaImageView(foto: nota.fotos.first, size: CGSize(width: 100, height: 100), fecha: nota.fecha_formato)
            }
            .padding(.horizontal)
            .padding(.vertical, 8)
        }
    }
}


struct NotaDestacadaView: View {
    let nota: Nota
    
    var body: some View {
        NavigationLink(destination: NewsDetailView(idNoticia: nota.id)) {
            VStack(alignment: .leading, spacing: 8) {
                NotaImageView(
                    foto: nota.fotos.first,
                    size: CGSize(width: UIScreen.main.bounds.width - 40, height: 200),
                    fecha: nota.fecha_formato
                )
                HStack {
                    Rectangle()
                        .fill(Color.red)
                        .frame(width: 4, height: 14)
                    
                    Text(nota.localizador)
                        .font(.caption)
                        .foregroundColor(.red)
                }
                Text(nota.titulo)
                    .font(.headline)
                    .foregroundColor(.black)
                
                Text(nota.contenido.first ?? "")
                    .font(.system(size: 14))
                    .foregroundColor(.black)
                    .multilineTextAlignment(.leading)
                
                Text(nota.autor)
                    .font(.caption)
                    .foregroundColor(.red)
            }
        }
        .padding(.horizontal)
        .padding(.vertical)
    }
}

struct NotaImageView: View {
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
                } else {
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


struct NotaCarruselCard: View {
    let nota: Nota
    
    var body: some View {
        NavigationLink(destination: NewsDetailView(idNoticia: nota.id)) {
            VStack(alignment: .leading, spacing: 2) {
                ZStack(alignment: .bottomLeading) {
                    NotaImageView(
                        foto: nota.fotos.first,
                        size: CGSize(width: 280, height: 360),
                        fecha: nil
                    )
                    
                    VStack(alignment: .leading, spacing: 4) {
                        HStack(spacing: 4) {
                            Rectangle()
                                .fill(Color.white)
                                .frame(width: 4, height: 14)
                            
                            Text(nota.localizador)
                                .font(.caption)
                                .foregroundColor(.white)
                                .shadow(radius: 2)
                        }
                        
                        Text(nota.titulo)
                            .font(.subheadline) // Tamaño más grande que .caption
                            .fontWeight(.bold)  // Negrilla
                            .foregroundColor(.white)
                            .shadow(radius: 2)
                            .multilineTextAlignment(.leading)
                        
                        HStack(spacing: 6) {
                            Text(nota.autor.uppercased())
                                .font(.caption)
                                .foregroundColor(.white)
                            
                            // Aumentamos tamaño del ícono con Label
                            Label {
                                Text(nota.fecha_formato ?? "")
                                    .font(.caption)
                                    .foregroundColor(.white)
                            } icon: {
                                Image(systemName: "clock")
                                    .foregroundColor(.white)
                                    .font(.system(size: 12))
                            }
                        }
                    }
                    .padding(15)
                }
                .frame(width: 300, height: 400)
            }
        }
        .frame(width: 300)
    }
}


struct SoftCarruselCard: View {
    let nota: Nota
    let articleActionHelper: ArticleActionHelper
    
    var body: some View {
        NavigationLink(destination: NewsDetailView(idNoticia: nota.id)) {
            VStack(alignment: .leading, spacing: 8) {
                // Imagen arriba
                NotaImageView(
                    foto: nota.fotos.first,
                    size: CGSize(width: 260, height: 160),
                    fecha: nil
                )
                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                .padding(.top, 8)
                .padding(.horizontal, 8)
                
                // Título
                Text(nota.titulo)
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                    .multilineTextAlignment(.leading)
                    .lineLimit(3)
                    .padding(.horizontal, 12)
                
                // --- Espacio adicional entre título e indicador ---
                Spacer().frame(height: 6)
                
                // Indicador (•••)
                HStack {
                    Spacer()
                    
                    Menu {
                        Button {
                            articleActionHelper.compartirNota(nota)
                        } label: {
                            Label("Compartir", systemImage: "square.and.arrow.up")
                        }
                        Button {
                            articleActionHelper.guardarNota(nota)
                        } label: {
                            Label("Guardar", systemImage: "bookmark")
                        }
                    } label: {
                        Image(systemName: "ellipsis")
                            .foregroundColor(.gray)
                            .padding(.trailing, 10)
                            .frame(width: 6)
                            .font(.system(size: 30))
                    }
                }
                .padding(.horizontal, 12)
                
                // --- Línea divisoria ---
                Divider()
                    .padding(.horizontal, 12)
                    .padding(.top, 4)
                
                // Barra inferior
                HStack {
                    Text("EL SIGLO DE TORREÓN")
                        .font(.caption)
                        .foregroundColor(.gray)
                    
                    Spacer()
                    
                    Label {
                        Text(nota.fecha_formato ?? "")
                            .font(.caption)
                            .foregroundColor(.gray)
                    } icon: {
                        Image(systemName: "clock")
                            .font(.caption2)
                            .foregroundColor(.gray)
                    }
                }
                .padding([.horizontal, .bottom], 12)
            }
            .background(Color.white)
            .cornerRadius(14)
            .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
            .frame(width: 300)
        }
        .buttonStyle(PlainButtonStyle())
    }
}


struct TVCarruselCard: View {
    let nota: Nota
    let articleActionHelper: ArticleActionHelper
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("SIGLO TV")
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(.black)
                .multilineTextAlignment(.leading)
                .lineLimit(3)
                .padding(.horizontal, 12)
            
            NavigationLink(destination: NewsDetailView(idNoticia: nota.id)) {
                VStack(alignment: .leading, spacing: 8) {
                    // Imagen arriba
                    NotaImageView(
                        foto: nota.fotos.first,
                        size: CGSize(width: 260, height: 160),
                        fecha: nil
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                    .padding(.top, 8)
                    .padding(.horizontal, 8)
                    
                    // Título
                    Text(nota.titulo)
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                        .multilineTextAlignment(.leading)
                        .lineLimit(3)
                        .padding(.horizontal, 12)
                    
                    // --- Espacio adicional entre título e indicador ---
                    Spacer().frame(height: 6)
                    
                    // Indicador (•••)
                    HStack {
                        Spacer()
                        
                        Menu {
                            Button {
                                articleActionHelper.compartirNota(nota)
                            } label: {
                                Label("Compartir", systemImage: "square.and.arrow.up")
                            }
                            Button {
                                articleActionHelper.guardarNota(nota)
                            } label: {
                                Label("Guardar", systemImage: "bookmark")
                            }
                        } label: {
                            Image(systemName: "ellipsis")
                                .foregroundColor(.gray)
                                .padding(.trailing, 10)
                                .frame(width: 6)
                                .font(.system(size: 30))
                        }
                    }
                    .padding(.horizontal, 12)
                    
                    // --- Línea divisoria ---
                    Divider()
                        .padding(.horizontal, 12)
                        .padding(.top, 4)
                    
                    // Barra inferior
                    HStack {
                        Text("EL SIGLO DE TORREÓN")
                            .font(.caption)
                            .foregroundColor(.gray)
                        
                        Spacer()
                        
                        Label {
                            Text(nota.fecha_formato ?? "")
                                .font(.caption)
                                .foregroundColor(.gray)
                        } icon: {
                            Image(systemName: "clock")
                                .font(.caption2)
                                .foregroundColor(.gray)
                        }
                    }
                    .padding([.horizontal, .bottom], 12)
                }
                .background(Color.white)
                .cornerRadius(14)
                .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
                .frame(width: 270)
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct SigloDataView: View {
let nota: Nota
let seccion: String
let articleActionHelper: ArticleActionHelper

var body: some View {
    NavigationLink(destination: NewsDetailView(idNoticia: nota.id)) {
        HStack(alignment: .top, spacing: 12) {
            
            // --- Contenido textual de la nota ---
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
                        Button {
                            articleActionHelper.compartirNota(nota)
                        } label: {
                            Label("Compartir", systemImage: "square.and.arrow.up")
                        }
                        Button {
                            articleActionHelper.guardarNota(nota)
                        } label: {
                            Label("Guardar", systemImage: "bookmark")
                        }
                    } label: {
                        Image(systemName: "ellipsis")
                            .foregroundColor(.gray)
                            .font(.system(size: 18))
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
                
                Text(seccion)
                    .foregroundColor(.red)
                    .font(.caption)
            }
            
            Spacer()
            
            // Imagen pequeña lateral de la nota
            NotaImageView(
                foto: nota.fotos.first,
                size: CGSize(width: 100, height: 100),
                fecha: nota.fecha_formato
            )
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 8)
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

