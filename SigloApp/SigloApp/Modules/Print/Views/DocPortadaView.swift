import SwiftUI

struct DocPortadaView: View {
    let fecha: String
    let paginas: [String] 

    @State private var pdfData: Data?
    @State private var errorMessage: String?

    var body: some View {
        Group {
            if let data = pdfData {
                PDFViewUI(data: data)
            } else if let err = errorMessage {
                Text("Error: \(err)")
            } else {
                ProgressView("Descargando…")
            }
        }
        .onAppear(perform: loadPDF)
        .navigationTitle("Edición \(fecha)")
    }

    private func loadPDF() {
        Task {
            do {
                var combinedPDF = Data()
                for urlString in paginas {
                    guard let url = URL(string: urlString) else { continue }
                    let (data, _) = try await URLSession.shared.data(from: url)
                    combinedPDF.append(data) // Esto concatena los PDFs; luego PDFViewUI puede abrirlos
                }
                self.pdfData = combinedPDF
            } catch {
                self.errorMessage = error.localizedDescription
            }
        }
    }
}
