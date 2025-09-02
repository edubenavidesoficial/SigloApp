import SwiftUI

struct PhotoView: View {
    let foto: FotoNota

    var body: some View {
        AsyncImage(url: URL(string: foto.urlFoto)) { image in
            image
                .resizable()
                .scaledToFill()
        } placeholder: {
            Color.gray.opacity(0.3)
        }
        .overlay(
            VStack {
                Spacer()
                if let pie = foto.pieFoto {
                    Text(pie)
                        .font(.caption)
                        .padding(6)
                        .background(Color.black.opacity(0.5))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            .padding()
        )
    }
}
