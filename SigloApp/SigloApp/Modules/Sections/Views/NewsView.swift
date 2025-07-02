import SwiftUI

struct NewsView: View {
    let nota: Noticia

    var body: some View {
        ZStack(alignment: .bottomLeading) {
            if let foto = nota.fotos?.first {
                GeometryReader { geometry in
                    PhotoView(foto: foto)
                        .scaledToFill()
                        .frame(width: geometry.size.width, height: geometry.size.height)
                        .clipped()
                        .overlay(
                            LinearGradient(
                                gradient: Gradient(colors: [Color.black.opacity(0.9), Color.clear]),
                                startPoint: .bottom,
                                endPoint: .center
                            )
                        )
                }
                .edgesIgnoringSafeArea(.all)
            }

            VStack {
                Spacer()

                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Rectangle()
                            .fill(Color.white)
                            .frame(width: 4, height: 14)

                        Text(nota.localizador ?? "")
                            .font(.caption)
                            .foregroundColor(.white)
                    }

                    Text(nota.titulo)
                        .font(.title2)
                        .foregroundColor(.white)
                        .shadow(radius: 2)
                }
                .padding()

                HStack {
                    Text(nota.autor ?? "")
                        .font(.caption)
                        .bold()
                        .foregroundColor(.white)
                        .shadow(radius: 2)
                        .padding(.leading)

                    Spacer()

                    HStack {
                        Image(systemName: "clock")
                            .foregroundColor(.white.opacity(0.8))
                        Text(nota.fechamod)
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.8))
                    }
                    .padding(.trailing)
                }
                .padding(.bottom, 15)
            }
        }
    }
}

struct SectionDestacadaView: View {
    let nota: Noticia

    var body: some View {
        NavigationLink(destination: NewsDetailView(idNoticia: nota.id)) {
            VStack(alignment: .leading, spacing: 8) {
                sectionImage
                locatorLine
                title
                contenido
                authorAndDate
            }
            .padding(.horizontal)
            .padding(.vertical)
        }
    }

    var sectionImage: some View {
        SectionImageView(
            foto: nota.fotos?.first,
            size: CGSize(width: UIScreen.main.bounds.width - 40, height: 200),
            fecha: nota.fechaFormato
        )
    }

    var locatorLine: some View {
        HStack {
            Rectangle()
                .fill(Color.red)
                .frame(width: 4, height: 14)

            Text(nota.localizador ?? "")
                .font(.caption)
                .foregroundColor(.black)
        }
    }

    var title: some View {
        Text(nota.titulo)
            .font(.headline)
            .foregroundColor(.black)
            .multilineTextAlignment(.leading)  // fuerza alineación multilinea a la izquierda
            .frame(maxWidth: .infinity, alignment: .leading)
    }

    var contenido: some View {
        Text(nota.contenido?.first ?? "")
            .font(.system(size: 14))
            .foregroundColor(.black)
            .multilineTextAlignment(.leading)
            .frame(maxWidth: .infinity, alignment: .leading)
            .fixedSize(horizontal: false, vertical: true) // que haga wrapping
    }

    var authorAndDate: some View {
        HStack {
            Text(nota.autor ?? "")
                .font(.caption)
                .bold()
                .foregroundColor(.black)
                .padding(.leading)

            Spacer()

            HStack {
                Image(systemName: "clock")
                    .foregroundColor(.black.opacity(0.8))
                Text(nota.fechamod)
                    .font(.caption)
                    .foregroundColor(.black.opacity(0.8))
            }
            .padding(.trailing)
        }
    }
}

struct SectionImageView: View {
    let foto: FotoNota?           // ✅ Coincide con .first de fotos
    let size: CGSize
    let fecha: String?
    
    var body: some View {
        VStack(alignment: .trailing, spacing: 4) {
            ZStack {
                if let foto = foto {
                    AsyncImage(url: URL(string: foto.urlFoto)) { phase in
                        switch phase {
                        case .success(let image):
                            image
                                .resizable()
                        case .failure:
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
