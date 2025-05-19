import SwiftUI

struct SuplementsCarouselView: View {
    @ObservedObject var viewModel: SuplementsViewModel

    var body: some View {
        TabView {
            ForEach(viewModel.suplementsForCurrentTab()) { article in
                VStack {
                    AsyncImage(url: URL(string: article.imageName)) { phase in
                        if let image = phase.image {
                            image.resizable()
                                 .scaledToFit()
                                 .cornerRadius(12)
                                 .shadow(color: .black.opacity(0.4), radius: 8, x: 0, y: 5)
                        } else if phase.error != nil {
                            Image("logo")
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

                    HStack {
                        Text(article.date)
                            .font(.caption2)
                            .foregroundColor(.gray)
                            .padding(.leading, 2)
                        Image(systemName: "arrow.down.circle.fill")
                            .foregroundColor(.black)
                            .font(.caption2)
                    }
                    .padding(.top, 4)
                    .padding(.leading, 8)
                }
            }
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
        .frame(height: 470)
        VStack {
            Text("Total: \(viewModel.suplementsForCurrentTab().count)")
                .foregroundColor(.blue)
                .padding()

            TabView {
                ForEach(viewModel.suplementsForCurrentTab()) { article in
                    VStack {
                        AsyncImage(url: URL(string: article.imageName)) { phase in
                            if let image = phase.image {
                                image.resizable()
                                     .scaledToFit()
                            } else if phase.error != nil {
                                Image(systemName: "exclamationmark.triangle.fill")
                            } else {
                                ProgressView()
                            }
                        }
                        Text(article.title)
                        Text(article.date)
                    }
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
        }
    }
}
