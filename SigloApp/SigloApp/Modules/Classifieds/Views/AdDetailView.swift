import SwiftUI


struct AdDetailView: View {
    @StateObject private var viewModel = AdDetailViewModel()
    let adId: String

    var body: some View {
        Group {
            if viewModel.isLoading {
                ProgressView("Cargando detalle...")
            } else if let error = viewModel.errorMessage {
                Text("Error: \(error)")
                    .foregroundColor(.red)
                    .multilineTextAlignment(.center)
                    .padding()
            } else if let ad = viewModel.adDetail {
                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        // Sección nombre
                        Text(ad.seccionNombre ?? "")
                            .font(.caption)
                            .foregroundColor(.red)
                        
                        // Imagen si existe
                        if let foto = ad.foto, !foto.isEmpty, foto != "0" {
                            if let url = URL(string: "https://tu-servidor.com/images/\(foto).jpg") {
                                AsyncImage(url: url) { image in
                                    image
                                        .resizable()
                                        .scaledToFit()
                                        .cornerRadius(8)
                                } placeholder: {
                                    ProgressView()
                                }
                                .frame(height: 200)
                            }
                        }
                        
                        // Texto anuncio
                        Text(ad.anuncio)
                            .font(.body)
                       
                    }
                    .padding()
                    .background(Color.customLightGray)
                    .cornerRadius(8)
                    .shadow(color: Color.black.opacity(0.15), radius: 2, x: 0, y: 1)
                    .padding()
                    HStack {
                        Text("Fecha:")
                            .foregroundColor(.secondary)
                            .bold()
                    }
                    HStack {
                        Image(systemName: "message.fill")
                            .foregroundColor(.secondary)
                            .font(.title3)
                        Text("Contactar con vendedor")
                            .foregroundColor(.secondary)
                            .bold()
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading) // Alinea el HStack a la izquierda

                }
                
            } else {
                Text("No hay detalles para mostrar")
            }
        }
        .navigationTitle("Detalle Anuncio")
        .onAppear {
            viewModel.loadAdDetail(id: adId)
        }
    }
}

