import SwiftUI

struct SuplementsDocView: View {
    let suplemento: SuplementoPayload

    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 10) {
                        ForEach(suplemento.paginas, id: \.self) { url in
                            AsyncImage(url: URL(string: url)) { image in
                                image
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 150, height: 200)
                                    .cornerRadius(8)
                            } placeholder: {
                                ProgressView()
                            }
                        }
                    }
                }
                .padding(.bottom, 20)
            }
            .padding()
        }
        .navigationTitle("Detalle Suplemento")
    }
}
