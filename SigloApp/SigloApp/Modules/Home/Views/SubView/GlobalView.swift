import SwiftUI

struct GlobalView: View {
    @ObservedObject var viewModel: HomeViewModel  // Asegura que `viewModel` esté disponible

    var body: some View {
        ForEach(viewModel.secciones.filter { $0.seccion == "México, EUA y Mundo" }, id: \.seccion) { seccion in
            Section(header: Text(seccion.seccion ?? "Siglo")
                .font(.title2)
                .bold()
                .padding(.horizontal)) {
                    
                    let notas = seccion.notas ?? []  // Evita crash si `notas` es nil
                    ForEach(notas, id: \.id) { nota in
                        VStack(alignment: .leading, spacing: 8) {
                            Text(nota.titulo)
                                .font(.headline)

                            if !nota.fotos.isEmpty {
                                ForEach(nota.fotos, id: \.url_foto) { foto in
                                    FotoView(foto: foto)
                                }
                            }
                        }
                    }
                }
        }
    }
}
