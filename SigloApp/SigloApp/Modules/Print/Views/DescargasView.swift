import SwiftUI
import PDFKit

struct DescargasView: View {
    @ObservedObject var viewModel: PrintViewModel

    var body: some View {
        ScrollView {
            if viewModel.downloads.isEmpty {
                VStack {
                    Image(systemName: "tray.and.arrow.down.fill")
                        .resizable()
                        .frame(width: 60, height: 60)
                        .foregroundColor(.red)
                        .padding()

                    Text("Aún no tienes descargas")
                        .font(.title3)
                        .foregroundColor(.gray)

                    Text("Aquí aparecerá lo que descargues")
                        .multilineTextAlignment(.center)
                        .padding()
                }
            } else {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 120), spacing: 16)]) {
                    ForEach(viewModel.downloads, id: \.self) { url in
                        NavigationLink(destination: PDFKitView(url: url)) {
                            VStack {
                                Image(systemName: "doc.richtext.fill")
                                    .resizable()
                                    .frame(width: 60, height: 80)
                                    .foregroundColor(.blue)
                                Text(url.lastPathComponent)
                                    .font(.caption)
                                    .lineLimit(1)
                                    .multilineTextAlignment(.center)
                            }
                            .padding()
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(12)
                        }
                    }
                }
                .padding()
            }
        }
    }
}
