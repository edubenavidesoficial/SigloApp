import SwiftUI

// Extensión para color personalizado hex #F8F8F8
extension Color {
    static let customLightGray = Color(red: 248/255, green: 248/255, blue: 248/255)
}

struct AvisosListView: View {
    @ObservedObject var viewModel: ClassifiedsViewModel
    @StateObject private var adsModel = AdsViewModel()
    
    var filterCategory: String?

    // Estado para la navegación al detalle
    @State private var selectedAdId: String? = nil
    @State private var isShowingDetail: Bool = false

    var body: some View {
        NavigationView {
            ZStack {
                Group {
                    if adsModel.isLoading {
                        ProgressView("Cargando anuncios...")
                    } else if let error = adsModel.errorMessage {
                        Text("Error: \(error)")
                            .foregroundColor(.red)
                            .multilineTextAlignment(.center)
                            .padding()
                    } else {
                        ScrollView {
                            LazyVStack(spacing: 12) {
                                ForEach(filteredAds) { ad in
                                    VStack(alignment: .leading, spacing: 8) {
                                        
                                        if let sectionName = ad.seccionNombre, !sectionName.isEmpty {
                                            Text(sectionName)
                                                .font(.caption)
                                                .foregroundColor(.red)
                                        }

                                        Group {
                                            if let fotos = ad.fotos, let firstFoto = fotos.first,
                                               firstFoto != "0", let url = URL(string: firstFoto) {
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
                                                    .frame(maxWidth: .infinity, alignment: .leading)
                                                    .cornerRadius(8)
                                                }
                                            } else {
                                                EmptyView()
                                            }
                                        }

                                        Text(ad.anuncio)
                                            .font(.body)
                                    }
                                    .padding()
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .background(Color.customLightGray)
                                    .cornerRadius(8)
                                    .shadow(color: Color.black.opacity(0.15), radius: 2, x: 0, y: 1)
                                    .padding(.horizontal)
                                    .onTapGesture {
                                        selectedAdId = ad.id
                                        isShowingDetail = true
                                    }
                                }
                            }
                        }
                    }
                }
                
                // Botón flotante
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Button(action: {
                            // Acción para buscar
                        }) {
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(.white)
                                .font(.system(size: 24))
                        }
                        .frame(width: 56, height: 56)
                        .background(Color.red)
                        .clipShape(Circle())
                        .shadow(radius: 5)
                        .padding()
                    }
                }
                
                // NavigationLink oculto para navegar al detalle
                NavigationLink(
                    destination: Group {
                        if let id = selectedAdId {
                            AdDetailView(adId: id)
                        } else {
                            EmptyView()
                        }
                    },
                    isActive: $isShowingDetail
                ) {
                    EmptyView()
                }
                .hidden()
            }
            .onAppear {
                adsModel.loadAds()
            }
        }
    }
    
    private var filteredAds: [ClassifiedAd] {
        if let filter = filterCategory?.lowercased(), !filter.isEmpty {
            return adsModel.ads.filter {
                ($0.seccionNombre?.lowercased().contains(filter) ?? false)
                || $0.anuncio.lowercased().contains(filter)
            }
        } else {
            return adsModel.ads
        }
    }
}
