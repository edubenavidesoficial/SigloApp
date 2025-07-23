import SwiftUI
let label = UILabel()

struct SeccionesHomeView: View {
    @ObservedObject var viewModel: HomeViewModel
    @ObservedObject var articleViewModel: ArticleViewModel
    @StateObject var articleActionHelper: ArticleActionHelper
    
    init(viewModel: HomeViewModel, articleViewModel: ArticleViewModel) {
        self.viewModel = viewModel
        self.articleViewModel = articleViewModel
        _articleActionHelper = StateObject(wrappedValue: ArticleActionHelper(articleViewModel: articleViewModel))
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                if let portada = viewModel.secciones.first(where: { $0.seccion == "Portada" }) {
                    let notas = Array((portada.notas ?? []).dropFirst().prefix(4))
                    
                    ForEach(notas, id: \.id) { nota in
                        NotaRow(nota: nota, seccion: "Portada", articleActionHelper: articleActionHelper)
                    }
                } else {
                    Text("No hay notas disponibles en la Portada.")
                        .foregroundColor(.gray)
                        .padding()
                }
            }
            
            VStack(spacing: 16) {
                if let sinSeccion = viewModel.secciones.first(where: { $0.seccion == nil }),
                   let notaRandom = sinSeccion.notas?.shuffled().first {
                    NotaDestacadaView(nota: notaRandom)
                }
                
                if let foquitos = viewModel.secciones.first(where: { $0.seccion == "Foquitos" }) {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 16) {
                            ForEach(foquitos.notas ?? [], id: \.id) { nota in
                                NotaCarruselCard(nota: nota)
                            }
                        }
                        .padding(.horizontal)
                    }
                    .padding(.bottom)
                }
                
                if let soft = viewModel.secciones.first(where: { $0.seccion == "Portada Soft" }) {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 16) {
                            ForEach(soft.notas ?? [], id: \.id) { nota in
                                SoftCarruselCard(nota: nota, articleActionHelper: articleActionHelper)
                            }
                        }
                        .padding(.horizontal)
                    }
                    .padding(.bottom)
                }
                
                if let tv = viewModel.secciones.first(where: { $0.seccion == "Siglo TV" }) {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 16) {
                            ForEach(tv.notas ?? [], id: \.id) { nota in
                                TVCarruselCard(nota: nota, articleActionHelper: articleActionHelper)
                            }
                        }
                        .padding(.horizontal)
                    }
                    .padding(.bottom)
                }else {
                    Text("No hay notas disponibles en la Siglo TV.")
                        .foregroundColor(.gray)
                        .padding()
                }
                
                if let data = viewModel.secciones.first(where: { $0.seccion == "Siglo Data" }) {
                    if let randomImage = data.notas?.compactMap({ $0.fotos.first }).randomElement() {
                        NotaImageView(
                            foto: randomImage,
                            size: CGSize(width: UIScreen.main.bounds.width, height: 200),
                            fecha: nil
                        )
                    }
                    
                     let notas = Array((data.notas ?? []).dropFirst().prefix(4))
                    ForEach(notas, id: \.id) { nota in
                        SigloDataView(nota: nota, seccion: "Siglo Data", articleActionHelper: articleActionHelper)
                    }
                } else {
                    Text("No hay notas disponibles en la Siglo Data.")
                        .foregroundColor(.gray)
                        .padding()
                }

                    
                }
            }
             .sheet(isPresented: $articleActionHelper.showShareSheet) {
                ActivityView(activityItems: articleActionHelper.shareContent)
            }
        }
    }
    
    
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
                                    Text(nota.fecha_formato)
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
                    .frame(width: 270, height: 400)
                }
            }
            .frame(width: 270)
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
                            Text(nota.fecha_formato)
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
                                Text(nota.fecha_formato)
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
                                .font(.system(size: 18))  // <-- más grande
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
            .padding(.horizontal)
            .padding(.vertical, 8)
        }
    }
}
