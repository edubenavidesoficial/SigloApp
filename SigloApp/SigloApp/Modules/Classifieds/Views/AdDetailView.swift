import SwiftUI


struct AdDetailView: View {
    @StateObject private var viewModel = AdDetailViewModel()
    let adId: String

    var body: some View {
        Group {
          if let ad = viewModel.adDetail {
                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        HStack {
                            // Texto 1 (Clasificación 1)
                            Text(ad.clasif1Nombre ?? "VARIOS")
                                .fontWeight(.bold)
                                .foregroundColor(.primary)
                            // Flecha a la derecha
                            Image(systemName: "chevron.right")
                                .foregroundColor(.gray)
                            
                            // Texto 2 (Clasificación 2)
                            Text(ad.clasif2Nombre ?? "VARIOS")
                                .foregroundColor(.primary)

                            // Espaciador
                            Spacer()
                        }
                        .padding(.horizontal)

                        
                        if let fotos = ad.fotos, !fotos.isEmpty {
                            TabView {
                                ForEach(fotos, id: \.self) { foto in
                                    if let url = URL(string: foto) {
                                        AsyncImage(url: url) { image in
                                            image
                                                .resizable()
                                                .scaledToFill()
                                                .frame(maxWidth: .infinity, alignment: .leading)
                                                .clipped()
                                                .cornerRadius(8)
                                        } placeholder: {
                                            ZStack {
                                                Color.gray.opacity(0.2)
                                                ProgressView()
                                            }
                                            .frame(height: 250)
                                            .cornerRadius(8)
                                        }
                                    }
                                }
                            }
                            .tabViewStyle(PageTabViewStyle())
                            .frame(height: 250)
                        }
                       
                    }
                    .padding()
                    let words = ad.anuncio.split(separator: " ", maxSplits: 1, omittingEmptySubsequences: true)
                    let firstWord = words.first.map(String.init) ?? ""
                    let remainingText = words.count > 1 ? String(words[1]) : ""
                    (
                        Text(firstWord + " ").bold() +
                        Text(remainingText)
                    )
                    .font(.body)
                    .padding()
                    .background(Color.customLightGray)
                    .cornerRadius(8)
                    .shadow(color: Color.black.opacity(0.15), radius: 2, x: 0, y: 1)
                    .padding(.horizontal)


                    // Texto anuncioHTML
                    Text(ad.masTexto ?? "")
                        .font(.body)
                        .padding()
                        .background(Color.customLightGray)
                        .cornerRadius(8)
                        .shadow(color: Color.black.opacity(0.15), radius: 2, x: 0, y: 1)
                        .padding(.horizontal)

                    // Fecha
                    HStack {
                        Text("Fecha:")
                            .foregroundColor(.secondary)
                            .bold()

                        Text("00-00-00")
                            .foregroundColor(.secondary)
                            .bold()

                        Spacer()
                    }
                    .padding(.horizontal)

                    // Contactar con vendedor (botón WhatsApp)
                    HStack(spacing: 10) {
                        Text("Contactar con vendedor:")
                            .foregroundColor(.secondary)
                            .bold()

                        Spacer()

                        if let whatsapp = ad.whatsapp,
                           !whatsapp.isEmpty,
                           let url = URL(string: "https://wa.me/+\(whatsapp)") {
                            Link(destination: url) {
                                Image(systemName: "phone.fill")
                                    .foregroundColor(.white)
                                    .padding()
                                    .background(Color.green)
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                            }
                        }
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 8)
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



