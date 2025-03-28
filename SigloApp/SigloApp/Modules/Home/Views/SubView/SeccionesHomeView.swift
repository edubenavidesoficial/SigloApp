import SwiftUI

struct SeccionesHomeView: View {
    @ObservedObject var viewModel: HomeViewModel

    var body: some View {
        ForEach(viewModel.secciones.filter { $0.seccion == "México, EUA y Mundo" }, id: \.seccion) {
            seccion in Section()
            {
                    let notas = seccion.notas ?? []
                    TabView {
                        ForEach(notas, id: \.id) { nota in
                            HStack(alignment: .top, spacing: 12) {

                                VStack(alignment: .leading, spacing: 6) {
                                    // Etiqueta roja
                                    Text(nota.localizador)
                                        .font(.caption)
                                        .foregroundColor(.red)

                                    // Título
                                    Text(nota.titulo)
                                        .font(.headline)
                                        .foregroundColor(.primary)
                                        .lineLimit(2)

                                    // Autor
                                    Text(nota.autor)
                                        .font(.caption)
                                        .foregroundColor(.gray)

                                    HStack(spacing: 8) {
                                        Text(seccion.seccion ?? "Siglo")
                                            .foregroundColor(.red)
                                            .font(.caption)

                                       
                                    }
                                }
                                // Imagen
                                ZStack(alignment: .topTrailing) {
                                    if !nota.fotos.isEmpty {
                                        ForEach(nota.fotos, id: \.url_foto) { foto in
                                            FotoView(foto: foto)
                                        }
                                        Label("00:00 hrs", systemImage: "clock")
                                            .foregroundColor(.secondary)
                                            .font(.caption)
                                    }
                                }
                               
                            }
                        }
                    }
                    .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
                    .frame(height: 250)
                }
        }
    }
}
