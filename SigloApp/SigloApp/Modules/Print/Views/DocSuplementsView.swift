import SwiftUI

struct DocSuplementsView: View {
    let suplementos: [SuplementoPayload]

    var body: some View {
        NavigationView {
            List(suplementos) { suplemento in
                NavigationLink(destination: SuplementoDetailView(suplemento: suplemento)) {
                    HStack {
                        AsyncImage(url: URL(string: suplemento.portada)) { image in
                            image.resizable()
                        } placeholder: {
                            ProgressView()
                        }
                        .frame(width: 60, height: 80)
                        .cornerRadius(8)

                        VStack(alignment: .leading, spacing: 4) {
                            Text(suplemento.titulo)
                                .font(.headline)
                            Text("Fecha: \(suplemento.fecha)")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                          /*  Text("Número: \(suplemento.numero) - Año: \(suplemento.anio)")
                                .font(.caption)
                                .foregroundColor(.gray)*/
                        }
                    }
                }
            }
            .navigationTitle("Suplementos")
        }
    }
}

struct SuplementoDetailView: View {
    let suplemento: SuplementoPayload

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 10) {
                AsyncImage(url: URL(string: suplemento.portada)) { image in
                    image.resizable()
                        .aspectRatio(contentMode: .fit)
                } placeholder: {
                    ProgressView()
                }

                Text(suplemento.titulo)
                    .font(.title)
                    .padding(.bottom, 4)

                Text("Fecha: \(suplemento.fecha)")
                Text("Sitio Web: \(suplemento.sitioWeb)")
                /*Text("Páginas: \(suplemento.paginasCuantas)")
                
                if suplemento.paginas.count > 0 {
                    Text("Ver páginas:")
                        .font(.headline)
                    ForEach(suplemento.paginas, id: \.self) { pagina in
                        Link(pagina, destination: URL(string: pagina)!)
                            .foregroundColor(.blue)
                    }
                }*/
            }
            .padding()
        }
        .navigationTitle("Detalle")
    }
}
