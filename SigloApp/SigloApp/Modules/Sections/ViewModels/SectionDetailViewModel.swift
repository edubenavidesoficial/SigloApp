import Foundation
import Combine

final class SectionDetailViewModel: ObservableObject {
    @Published var secciones: [SectionPayload] = []
    @Published var videos: [SectionVideo]? = nil
    @Published var isLoading = false
    @Published var errorMessage: String? = nil

    func cargarPortada(idSeccion: Int) {
        guard !isLoading else { return }

        isLoading = true
        errorMessage = nil

        SectionService.shared.obtenerContenidoDeSeccion(idSeccion: idSeccion) { [weak self] result in
            guard let self = self else { return }

            DispatchQueue.main.async {
                self.isLoading = false

                switch result {
                case .success(let contenido):
                    self.secciones = [contenido]

                    if idSeccion == 903 {
                        self.videos = contenido.videos
                    } else {
                        self.videos = nil
                    }

                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                    print("❌ Error al cargar sección: \(error.localizedDescription)")
                }
            }
        }
    }
}

