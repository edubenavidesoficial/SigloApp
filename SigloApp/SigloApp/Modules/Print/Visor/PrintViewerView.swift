import SwiftUI

struct PrintViewerView: View {
    let fecha: String
    let paginas: [String]
    
    var body: some View {
        ZStack {
            Color.black
                .edgesIgnoringSafeArea(.all)
            
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 20) {
                    ForEach(paginas, id: \.self) { paginaURL in
                        AsyncImage(url: URL(string: paginaURL)) { phase in
                            switch phase {
                            case .empty:
                                ProgressView()
                                    .frame(maxWidth: .infinity, minHeight: 300)
                            case .success(let image):
                                image
                                    .resizable()
                                    .scaledToFit()
                                    .cornerRadius(8)
                                    .shadow(radius: 5)
                            case .failure:
                                Image(systemName: "xmark.octagon.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .foregroundColor(.red)
                                    .frame(width: 10, height: 10)
                                    .padding()
                            @unknown default:
                                EmptyView()
                            }
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("Edición \(fecha)")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
