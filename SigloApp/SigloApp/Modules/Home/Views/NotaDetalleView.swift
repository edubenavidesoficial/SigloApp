import SwiftUI

struct NotaDetalleView: View {
    let nota: Nota // Recibimos el objeto nota para mostrar sus detalles

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text(nota.titulo)
                    .font(.largeTitle)
                    .fontWeight(.bold)
               

                // Si hay fotos, las mostramos
                /*if let foto = nota.fotos {
                    AsyncImage(url: URL(string: foto.url)) { image in
                        image.resizable()
                            .scaledToFit()
                            .frame(maxWidth: .infinity, maxHeight: 300)
                    } placeholder: {
                        ProgressView()
                    }
                    .padding(.top, 10)
                }*/
            }
            .padding()
        }
        .navigationTitle("Detalle de Nota")
    }
}
