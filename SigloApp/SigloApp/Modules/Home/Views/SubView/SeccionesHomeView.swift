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
            }
        }
        // 👇 Esta parte es la que te faltaba
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
