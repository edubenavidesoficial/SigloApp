import Foundation
import SwiftUI

class ShareHelper: ObservableObject {
    @Published var showShareSheet: Bool = false
    @Published var shareContent: [Any] = []

    func compartirTexto(_ texto: String) {
        self.shareContent = [texto]
        DispatchQueue.main.async {
            self.showShareSheet = true
        }
    }

    func compartirNota(_ nota: Nota) {
        let imagenURL = nota.fotos.first?.url_foto ?? "ejemplo"
        let texto = "\(nota.titulo)\n\(nota.localizador)"
        compartirTexto(texto)
    }
}
