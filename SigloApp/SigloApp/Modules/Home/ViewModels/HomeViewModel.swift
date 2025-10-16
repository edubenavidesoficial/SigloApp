import Foundation
import Combine

@MainActor
class HomeViewModel: ObservableObject {
    @Published var secciones: [SeccionPortada] = []
    @Published var videos: [SectionVideo] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    func cargarPortada() {
        isLoading = true
        errorMessage = nil

        Task {
            // Cargar secciones
            let resultado = await PortadaService.shared.obtenerPortada()
            switch resultado {
            case .success(let secciones):
                self.secciones = secciones

                // Cargar videos de SigloTv
                let videosResultado = await VideoService.shared.obtenerVideo(tipo: "SigloTv", id: 0)
                switch videosResultado {
                case .success(let payload):
                    // Convertir VideoPayload y sus relacionados a SectionVideo
                    var allVideos: [SectionVideo] = []

                    // Principal
                    let principal = SectionVideo(
                        id: payload.id,
                        url: payload.url,
                        titulo: payload.titulo,
                        contenido: payload.contenido,
                        cover: payload.cover,
                        fecha: payload.fecha,
                        tipo: payload.tipo,
                        seccion: payload.seccion,
                        fechaformato: payload.fechaFormato
                    )
                    allVideos.append(principal)

                    // Relacionados
                    let relacionados = payload.relacionados.map { rel in
                        SectionVideo(
                            id: rel.id,
                            url: rel.url,
                            titulo: rel.titulo,
                            contenido: rel.contenido,
                            cover: rel.cover,
                            fecha: rel.fecha,
                            tipo: rel.tipo,
                            seccion: rel.seccion,
                            fechaformato: rel.fechaFormato
                        )
                    }
                    allVideos.append(contentsOf: relacionados)

                    self.videos = allVideos

                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                }

            case .failure(let error):
                self.errorMessage = error.localizedDescription
            }

            self.isLoading = false
        }
    }
}
