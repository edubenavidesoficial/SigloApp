import SwiftUI

struct NotaDetalleView: View {
    let nota: Nota // Recibimos el objeto nota para mostrar sus detalles

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text(nota.titulo)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                if let balazo = nota.balazo {
                    Text(balazo)
                        .font(.title2)
                        .foregroundColor(.secondary)
                }
                
                // Mostrar el contenido de la nota
                if let contenido = nota.contenido {
                    ForEach(contenido, id: \.self) { parrafo in
                        Text(parrafo)
                            .font(.body)
                            .padding(.top, 5)
                    }
                }

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
