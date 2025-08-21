import SwiftUI
import PDFKit

class PrintViewModel: ObservableObject {
    @Published var downloads: [URL] = []
    @Published var isNewspaperLoaded = false
    @Published var isLoading: Bool = false
    @Published var selectedTab: TabTypetwo = .hemeroteca
    @Published var hemeroteca: [PrintModel] = []
    @Published var errorMessage: String?

    private let printService = PrintService.shared

    // Obtener portadas
    func fetchNewspaper() {
        guard !isNewspaperLoaded && !isLoading else { return }
        isLoading = true
        errorMessage = nil

        printService.obtenerPortada { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.isLoading = false

                switch result {
                case .success(let payloads):
                    guard let firstPayload = payloads.first else {
                        self.isNewspaperLoaded = false
                        return
                    }

                    self.hemeroteca = firstPayload.portadas.map { portada in
                        PrintModel(
                            title: portada.titulo,
                            imageName: portada.cover,
                            date: firstPayload.fecha ?? "",
                            paginas: firstPayload.paginas
                        )
                    }
                    self.isNewspaperLoaded = true

                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                    self.isNewspaperLoaded = false
                }
            }
        }
    }

    func printArticlesForCurrentTab() -> [PrintModel] {
        switch selectedTab {
        case .hemeroteca: return hemeroteca
        default: return []
        }
    }

    // Descargar todos los PDFs de una portada
    func descargarPortadaCompleta(paginas: [String], nombreArchivo: String) {
        var pdfDocuments: [PDFDocument] = []
        let group = DispatchGroup()

        for pdfPath in paginas {
            group.enter()
            PrintService.shared.descargarPDF(pdfPath: pdfPath) { result in
                switch result {
                case .success(let url):
                    if let doc = PDFDocument(url: url) {
                        pdfDocuments.append(doc)
                    }
                case .failure(let error):
                    print("❌ Error al descargar PDF \(pdfPath): \(error.localizedDescription)")
                }
                group.leave()
            }
        }

        group.notify(queue: .main) {
            let mergedPDF = PDFDocument()
            var pageIndex = 0
            for doc in pdfDocuments {
                for i in 0..<doc.pageCount {
                    if let page = doc.page(at: i) {
                        mergedPDF.insert(page, at: pageIndex)
                        pageIndex += 1
                    }
                }
            }

            let fileManager = FileManager.default
            let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let destinationURL = documentsURL.appendingPathComponent("\(nombreArchivo).pdf")

            if mergedPDF.write(to: destinationURL) {
                print("✅ PDF combinado guardado en: \(destinationURL.path)")
                self.downloads.append(destinationURL)
            } else {
                print("❌ Error al guardar PDF combinado")
            }
        }
    }
}
