import SwiftUI

struct FotoView: View {
    let foto: Foto

    var body: some View {
        VStack {
            if let url = URL(string: foto.url_foto) {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                    case .success(let image):
                        image.resizable()
                            .scaledToFit()
                            .cornerRadius(13)
                            
                    case .failure:
                        Image(systemName: "photo")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 100)
                            .foregroundColor(.gray)
                    @unknown default:
                        EmptyView()
                    }
                }
            }
            
            if let pieFoto = foto.pie_foto { 
                Text(pieFoto)
                    .font(.caption)
                    .foregroundColor(.gray)
                    .padding(.top, 4)
            }
        }
        .padding(.vertical, 8)
    }
}


struct SigloTvVideoView: View {
    let foto: Foto

    var body: some View {
        VStack {
            if let url = URL(string: foto.url_foto) {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                    case .success(let image):
                        image.resizable()
                            .scaledToFit()
                            .cornerRadius(10)
                            
                    case .failure:
                        Image(systemName: "LS")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 100)
                            .foregroundColor(.gray)
                    @unknown default:
                        EmptyView()
                    }
                }
            }
            
            if let pieFoto = foto.pie_foto {
                Text(pieFoto)
                    .font(.caption)
                    .foregroundColor(.gray)
                    .padding(.top, 4)
            }
        }
        .padding(.vertical, 8)
    }
}
