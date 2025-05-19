import SwiftUI

struct SuplementsCarouselView: View {
    @ObservedObject var viewModel: SuplementsViewModel

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 16) {
                ForEach(viewModel.suplementsForCurrentTab()) { article in
                    VStack(alignment: .leading) {
                        AsyncImage(url: URL(string: article.imageName)) { phase in
                            if let image = phase.image {
                                image.resizable()
                                     .scaledToFill()
                                     .frame(width: 150, height: 180)
                                     .clipped()
                                     .cornerRadius(10)
                                     .shadow(radius: 4)
                            } else if phase.error != nil {
                                Image("logo") // Imagen de respaldo si hay error
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 150, height: 180)
                                    .cornerRadius(10)
                                    .shadow(radius: 4)
                            } else {
                                ProgressView()
                                    .frame(width: 150, height: 180)
                            }
                        }

                        Text(article.title)
                            .font(.caption)
                            .lineLimit(1)
                            .padding(.top, 4)

                        Text(article.date)
                            .font(.caption2)
                            .foregroundColor(.gray)
                    }
                    .frame(width: 150)
                }
            }
            .padding(.horizontal)
        }
    }
}
