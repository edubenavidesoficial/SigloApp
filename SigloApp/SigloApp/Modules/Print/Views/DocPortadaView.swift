import SwiftUI

struct DocPortadaView: View {
    @State private var pdfData: Data?
    @State private var errorMessage: String?

    let fecha    = "2002-12-31"
    let edicion  = "31torg02"

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
        .navigationTitle("Portada")
    }

    private func loadPDF() {
        PrintDocService.shared.descargarPortada(fecha: fecha, edicion: edicion) { result in
            switch result {
            case .success(let data):
                self.pdfData = data
            case .failure(let error):
                self.errorMessage = error.localizedDescription
            }
        }
    }
}
