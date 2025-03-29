import SwiftUI

struct SeccionsNotesView: View {
    @ObservedObject var viewModel: HomeViewModel
    @ObservedObject var articleViewModel: ArticleViewModel
    var title: String

    var body: some View {
        VStack {
            ForEach(viewModel.secciones.filter { $0.seccion == title }, id: \.seccion) { seccion in
                Section {
                    let notas = seccion.notas ?? []
                    
                   // TabView {
                        ForEach(notas, id: \.id) { nota in
                            HStack(alignment: .top, spacing: 12) {
                                VStack(alignment: .leading, spacing: 6) {
                                    // Línea roja antes del texto
                                    HStack {
                                        Rectangle()
                                            .fill(Color.red)
                                            .frame(width: 4, height: 14)

                                        Text(nota.localizador)
                                            .font(.caption)
                                            .foregroundColor(.red)

                                        Spacer()

                                        // Botón de menú con los tres puntos
                                        Menu {
                                            Button(action: {
                                                compartirNota(nota)
                                            }) {
                                                Label("Compartir", systemImage: "square.and.arrow.up")
                                            }

                                        } label: {
                                            Image(systemName: "ellipsis")
                                                .foregroundColor(.gray)
                                                .padding(.trailing, 8)
                                        }
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
                                    // Contenido de la nota (texto largo)
                                    ScrollView {
                                        Text(nota.contenido ?? "Contenido no disponible.")
                                            .font(.body)
                                            .foregroundColor(.primary)
                                            .padding(.vertical, 8)
                                            .lineLimit(nil) // Esto permite que el texto se muestre completo, sin límite de líneas
                                    }
                                    
                                }

                                Spacer()

                                ZStack(alignment: .bottomTrailing) {
                                    if let foto = nota.fotos.first {
                                        FotoView(foto: foto)
                                            .scaledToFill()
                                            .frame(width: 100, height: 100) // Tamaño cuadrado
                                            .clipped()
                                            .cornerRadius(8)
                                    }
                                }
                            }
                            .padding()
                        }
                    //}
                    .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
                    .frame(height: 180)
                }
            }
        }
    }

    // Función para compartir una nota
    func compartirNota(_ nota: Nota) {
        print("Compartir: \(nota.titulo)")
        // Implementación del sistema de compartir
    }
}
