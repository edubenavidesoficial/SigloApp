import SwiftUI

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
    func descargarPDFs(from paginas: [String]) {
        for pdfPath in paginas {
            PrintService.shared.descargarPDF(pdfPath: pdfPath) { [weak self] result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let url):
                        // ✅ Agregar al array de descargas si no existe
                        if !(self?.downloads.contains(url) ?? false) {
                            self?.downloads.append(url)
                            print("✅ PDF agregado a descargas: \(url.lastPathComponent)")
                        }
                    case .failure(let error):
                        print("❌ Error al descargar PDF \(pdfPath): \(error.localizedDescription)")
                    }
                }
            }
        }
    }

}
