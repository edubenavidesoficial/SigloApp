import SwiftUI

struct PrintViewerView: View {
    let article: PrintModel

    var body: some View {
        ZStack {
            Color.black
                .edgesIgnoringSafeArea(.all) // Asegura que cubra toda la pantalla

            VStack {
                AsyncImage(url: URL(string: article.imageName)) { phase in
                    if let image = phase.image {
                        image
                            .resizable()
                            .scaledToFit()
                            .edgesIgnoringSafeArea(.all)
                    } else if phase.error != nil {
                        Image("LS")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 200)
                    } else {
                        ProgressView()
                    }
                }

                Spacer()
            }
            .padding()
        }
    }
}
