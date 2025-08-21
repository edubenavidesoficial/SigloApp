import SwiftUI

struct DocPortadaView: View {
    let pdfURL: URL

    var body: some View {
        PDFKitView(url: pdfURL)
            .navigationTitle("Documento Impreso")
            .navigationBarTitleDisplayMode(.inline)
    }
}
