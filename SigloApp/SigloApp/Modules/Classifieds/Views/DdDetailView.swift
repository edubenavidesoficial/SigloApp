import SwiftUI

struct DdDetailView: View {
    @AppStorage("isLoggedIn") private var isLoggedIn: Bool = false
    @State private var selectedOption: MenuOption? = nil
    @State private var isMenuOpen: Bool = false
    
    let ad: SimpleAd
    
    var body: some View {
        VStack {
            DBlackHeaderView(
                selectedOption: $selectedOption,
                isMenuOpen: $isMenuOpen,
                isLoggedIn: isLoggedIn
            )
             ScrollView {
                VStack(alignment: .leading, spacing: 12) {
                   
                    if let sectionName = ad.seccionNombre, !sectionName.isEmpty {
                        Text(sectionName)
                            .font(.caption)
                            .foregroundColor(.red)
                    }
                    // Imagen principal
                    if let fotos = ad.fotos,
                       let firstFoto = fotos.first,
                       firstFoto != "0",
                       let url = URL(string: firstFoto) {
                        
                        AsyncImage(url: url) { image in
                            image
                                .resizable()
                                .scaledToFill()
                                .frame(maxWidth: .infinity)
                                .cornerRadius(1)
                        } placeholder: {
                            ZStack {
                                Color.gray.opacity(0.2)
                                ProgressView()
                            }
                            .frame(height: 200)
                            .cornerRadius(1)
                        }
                    }
                    
                    // Título o anuncio
                    Text(ad.anuncio)
                        .frame(maxWidth: .infinity)
                        .font(.title3)
                        .padding(.top, 8)
                        .background(Color.customLightGray)
                        .cornerRadius(8)
                        .shadow(color: Color.black.opacity(0.15), radius: 2, x: 0, y: 1)
                    
                }
                .padding()
            }
            
            Spacer()
        }
        .navigationBarHidden(true)
    }
}
