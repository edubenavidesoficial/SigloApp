import SwiftUI

struct PrintCarouselView: View {
    var viewModel: PrintViewModel
    @State private var selectedArticle: PrintModel?

    var body: some View {
        ZStack {
            TabView {
                ForEach(viewModel.printArticlesForCurrentTab()) { article in
                    VStack {
                        Button(action: {
                            selectedArticle = article
                        }) {
                            AsyncImage(url: URL(string: article.imageName)) { phase in
                                if let image = phase.image {
                                    image.resizable()
                                        .scaledToFit()
                                        .cornerRadius(12)
                                        .shadow(color: .black.opacity(0.4), radius: 8, x: 0, y: 5)
                                } else if phase.error != nil {
                                    Image("LS")
                                        .resizable()
                                        .scaledToFit()
                                        .cornerRadius(12)
                                        .frame(height: 100)
                                        .shadow(color: .black.opacity(0.4), radius: 8, x: 0, y: 5)
                                } else {
                                    ProgressView()
                                        .progressViewStyle(CircularProgressViewStyle(tint: .gray))
                                }
                            }
                        }

                        HStack {
                            Text(article.date)
                                .font(.caption2)
                                .foregroundColor(.gray)
                                .padding(.leading, 2)

                            NavigationLink(destination: DocPortadaView()) {
                                Image(systemName: "arrow.down.circle.fill")
                                    .foregroundColor(.black)
                                    .font(.caption2)
                            }
                        }
                        .padding(.top, 4)
                        .padding(.leading, 8)
                    }
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            .frame(height: 470)

            // ✅ NavigationLink con vista destino válida
            NavigationLink(
                destination: selectedArticle.map { PrintViewerView(article: $0) },
                isActive: Binding(
                    get: { selectedArticle != nil },
                    set: { if !$0 { selectedArticle = nil } }
                )
            ) {
                EmptyView()
            }
            .hidden()
            
        }
    }
}


