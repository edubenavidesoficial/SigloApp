import SwiftUI

struct SuplementsCarouselView: View {
    @ObservedObject var viewModel: SuplementsViewModel
    var filterTitle: String

    var body: some View {
        let filteredArticles = viewModel.suplementsFiltered(by: filterTitle)
            .filter { !$0.imageName.trimmingCharacters(in: .whitespaces).isEmpty }

        if !filteredArticles.isEmpty {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(filteredArticles) { article in
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
                                    Image("LS")
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
                            Image(systemName: "arrow.down.circle.fill")
                                .foregroundColor(.red)
                                .font(.caption2)
                        }
                        .frame(width: 150)
                    }
                }
                .padding(.horizontal)
            }
        }
    }
}
