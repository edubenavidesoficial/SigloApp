import SwiftUI

struct SeccionesHomeView: View {
    @ObservedObject var viewModel: HomeViewModel

    var body: some View {
        ForEach(viewModel.secciones.filter { $0.seccion == "México, EUA y Mundo" }, id: \.seccion) { seccion in
            Section {
                let notas = seccion.notas ?? []
                TabView {
                    ForEach(notas, id: \.id) { nota in
                        HStack(alignment: .top, spacing: 12) {
                            VStack(alignment: .leading, spacing: 6) {
                                
                                // Línea roja antes del texto
                                HStack {
                                    Rectangle()
                                        .fill(Color.red)
                                        .frame(width: 4, height: 14) // Ajusta el tamaño según necesidad

                                    Text(nota.localizador)
                                        .font(.caption)
                                        .foregroundColor(.red)
                                }

                                // Título en negrita
                                Text(nota.titulo)
                                    .font(.headline)
                                    .foregroundColor(.primary)
                                    .lineLimit(2)

                                // Autor en gris
                                Text(nota.autor)
                                    .font(.caption)
                                    .foregroundColor(.gray)

                                // Sección en rojo
                                HStack(spacing: 8) {
                                    Text(seccion.seccion ?? "Siglo")
                                        .foregroundColor(.red)
                                        .font(.caption)
                                }
                            }

                            Spacer()

                            ZStack(alignment: .bottomTrailing) {
                                if let foto = nota.fotos.first {
                                    FotoView(foto: foto)
                                        .scaledToFill() // La imagen llenará completamente el cuadrado
                                        .clipped() // Recorta cualquier exceso
                                        .cornerRadius(8) // Bordes redondeados
                                }

                                Label("07:35 hrs", systemImage: "clock")
                                    .foregroundColor(.secondary)
                                    .font(.caption)
                                    .padding(4)
                            }


                        }
                        .padding()
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
                .frame(height: 160)
            }
        }
    }
}
