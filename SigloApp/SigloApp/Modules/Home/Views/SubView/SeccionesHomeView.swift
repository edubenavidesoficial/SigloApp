import SwiftUI

struct SeccionesHomeView: View {
    @ObservedObject var viewModel: HomeViewModel

    var body: some View {
        ForEach(viewModel.secciones.filter { $0.seccion == "México, EUA y Mundo" }, id: \.seccion) { seccion in
            Section(header: Text(seccion.seccion ?? "Siglo")
                .font(.title2)
                .bold()
                .padding(.horizontal)) {
                    
                    let notas = seccion.notas ?? []
                    TabView {
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
                    .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
                    .frame(height: 250)
                }
        }
    }
}
