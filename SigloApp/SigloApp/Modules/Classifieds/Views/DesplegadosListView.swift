import SwiftUI

struct DesplegadosListView: View {
    @ObservedObject var viewModel: ClassifiedsViewModel
    @StateObject private var adsModel = DdsViewModel()
    
    var filterCategory: String?
    let tipo: String
    
    @State private var selectedAd: SimpleAd? = nil   // <- cambio importante
    @State private var isShowingDetail: Bool = false

    var body: some View {
        NavigationView {
            ZStack {
                Group {
                    if adsModel.isLoading {
                        ProgressView("Cargando desplegados...")
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

                                        if let fotos = ad.fotos, let firstFoto = fotos.first,
                                           firstFoto != "0", let url = URL(string: firstFoto) {
                                            AsyncImage(url: url) { image in
                                                image
                                                    .resizable()
                                                    .scaledToFill()
                                                    .frame(maxWidth: .infinity, alignment: .leading)
                                                    .clipped()
                                                    .cornerRadius(1)
                                            } placeholder: {
                                                ZStack {
                                                    Color.gray.opacity(0.2)
                                                    ProgressView()
                                                }
                                                .frame(maxWidth: .infinity, alignment: .leading)
                                                .cornerRadius(8)
                                            }
                                        }
                                    }
                                    .padding()
                                    .onTapGesture {
                                        selectedAd = ad 
                                        isShowingDetail = true
                                    }
                                }
                            }
                        }
                    }
                }
                
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Button(action: {
                            // Acción buscar
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
                
                // Navegación al detalle con anuncio completo
                NavigationLink(
                    destination: Group {
                        if let ad = selectedAd {
                            DdDetailView(ad: ad)
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
                adsModel.loadAds(tipo: tipo)
            }
        }
    }
    
    private var filteredAds: [SimpleAd] {
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
