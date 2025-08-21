import SwiftUI
import PDFKit

struct PrintCarouselView: View {
    @ObservedObject var viewModel: PrintViewModel
    @State private var showAlert = false

    var body: some View {
        VStack {
            TabView {
                ForEach(viewModel.printArticlesForCurrentTab()) { article in
                    GeometryReader { geo in
                        VStack(spacing: 16) {
                            // Fecha arriba
                            HStack {
                                Image(systemName: "calendar")
                                    .foregroundColor(.black)
                                    .font(.caption2)
                                Text(article.date)
                                    .font(.caption2)
                                    .foregroundColor(.gray)
                            }
                            .padding(.top, 8)

                            // Imagen central
                            AsyncImage(url: URL(string: article.imageName)) { phase in
                                if let image = phase.image {
                                    image
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: geo.size.width * 0.9,
                                               height: geo.size.height * 0.7)
                                        .cornerRadius(12)
                                        .shadow(color: .black.opacity(0.4), radius: 8, x: 0, y: 5)
                                } else if phase.error != nil {
                                    Image("LS")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: geo.size.width * 0.9,
                                               height: geo.size.height * 0.7)
                                        .cornerRadius(12)
                                        .shadow(color: .black.opacity(0.4), radius: 8, x: 0, y: 5)
                                } else {
                                    ProgressView()
                                        .progressViewStyle(CircularProgressViewStyle(tint: .gray))
                                        .frame(width: geo.size.width * 0.9,
                                               height: geo.size.height * 0.7)
                                }
                            }

                            // Botón de descarga
                            HStack {
                                Spacer()
                                Button(action: {
                                    viewModel.descargarPDFs(from: article.paginas)
                                    showAlert = true
                                }) {
                                    Image(systemName: "arrow.down.circle.fill")
                                        .foregroundColor(.black)
                                        .font(.title3)
                                }
                            }
                            .padding(.horizontal, 16)

                            Spacer()
                        }
                        .frame(width: geo.size.width, height: geo.size.height)
                    }
                    .tag(article.id)
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            .frame(height: 720)
        }
        .alert("PDF guardado en tus descargas", isPresented: $showAlert) {
            Button("OK", role: .cancel) { }
        }
    }
}
