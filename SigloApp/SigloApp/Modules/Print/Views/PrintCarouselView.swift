import SwiftUI

struct PrintCarouselView: View {
    var viewModel: PrintViewModel
    @State private var selectedArticle: PrintModel?

    var body: some View {
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
                                    .frame(width: geo.size.width * 0.9, height: geo.size.height * 0.7)
                                    .cornerRadius(12)
                                    .shadow(color: .black.opacity(0.4), radius: 8, x: 0, y: 5)
                            } else if phase.error != nil {
                                Image("LS")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: geo.size.width * 0.9, height: geo.size.height * 0.7)
                                    .cornerRadius(12)
                                    .shadow(color: .black.opacity(0.4), radius: 8, x: 0, y: 5)
                            } else {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .gray))
                                    .cornerRadius(3)
                                    .frame(width: geo.size.width * 0.9, height: geo.size.height * 0.7)
                            }
                        }

                        // Fecha y botón de descarga centrados
                        HStack(alignment: .center) {
                            Text(formattedDate(from: article.date))
                                .font(.caption)
                                .foregroundColor(.gray)
                                .multilineTextAlignment(.center)
                            
                            Spacer()
                            NavigationLink(
                                destination: DocPortadaView(
                                    fecha: article.date,
                                    paginas: article.paginas
                                )
                            ) {
                                Image(systemName: "arrow.down.circle.fill")
                                    .foregroundColor(.black)
                                    .font(.title3)
                            }

                        }
                        .padding(.horizontal, 16)
                        .frame(maxWidth: .infinity)

                        Spacer()
                    }
                    .frame(width: geo.size.width, height: geo.size.height)
                    .onTapGesture {
                        selectedArticle = article
                    }
                }
                .tag(article.id)
            }
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
        .frame(height: 720)

        // NavigationLink principal para la vista de detalles
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

    // Función para dar formato largo a la fecha
    func formattedDate(from dateString: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd" // Ajusta según tu formato de origen
        guard let date = formatter.date(from: dateString) else { return dateString }

        formatter.locale = Locale(identifier: "es_ES")
        formatter.dateFormat = "EEEE d 'de' MMMM 'del' yyyy"
        return formatter.string(from: date).capitalized
    }
}
