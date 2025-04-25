import SwiftUI

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
        VStack(spacing: 16) {
            let seccionesExcluidas = ["Siglo Plus", "Foquitos", "Portada Soft", "Contenido Patrocinado", "Portada"]

            let notasFiltradas = viewModel.secciones
                .filter { seccion in
                    guard let nombre = seccion.seccion else { return false }
                    return !seccionesExcluidas.contains(nombre)
                }
                .flatMap { seccion in
                    (seccion.notas ?? []).map { nota in
                        (nota, seccion.seccion ?? "Siglo")
                    }
                }
                .shuffled()
                .prefix(4)

            ForEach(Array(notasFiltradas.enumerated()), id: \.offset) { _, notaYSeccion in
                NotaRow(nota: notaYSeccion.0, seccion: notaYSeccion.1, articleActionHelper: articleActionHelper)
            }

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
}

struct NotaRow: View {
    let nota: Nota
    let seccion: String
    let articleActionHelper: ArticleActionHelper

    var body: some View {
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
                    .font(.headline)
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

            NotaImageView(foto: nota.fotos.first, size: CGSize(width: 100, height: 100))
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
    }
}

struct NotaDestacadaView: View {
    let nota: Nota

    var body: some View {
        VStack(alignment: .leading) {
            NotaImageView(foto: nota.fotos.first, size: CGSize(width: UIScreen.main.bounds.width - 40, height: 200))
            VStack(alignment: .leading, spacing: 8) {
                Text(nota.titulo).font(.headline)
                Text(nota.autor).font(.caption).foregroundColor(.gray)
            }
            .padding(.horizontal)
        }
        .padding(.vertical)
    }
}

struct NotaCarruselCard: View {
    let nota: Nota

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            NotaImageView(foto: nota.fotos.first, size: CGSize(width: 280, height: 360))
            Text(nota.titulo).font(.caption).lineLimit(2)
        }
        .frame(width: 280)
    }
}

struct NotaImageView: View {
    let foto: Foto?
    let size: CGSize

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            if let foto = foto {
                AsyncImage(url: URL(string: foto.url_foto)) { phase in
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

            Label("07:35 hrs", systemImage: "clock")
                .foregroundColor(.secondary)
                .font(.caption)
                .padding(4)
        }
    }
}
