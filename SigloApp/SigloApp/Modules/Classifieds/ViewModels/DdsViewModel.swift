import SwiftUI
import Combine

class DdsViewModel: ObservableObject {
    @Published var ads: [SimpleAd] = []
    @Published var isLoading = false
    @Published var errorMessage: String? = nil
    
    func loadAds(tipo: String = "desplegados") {
        isLoading = true
        errorMessage = nil
        
        AnunciosService.shared.obtenerAnuncios(tipo: tipo) { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.isLoading = false
                
                switch result {
                case .success(let secciones):
                    self.ads = secciones.flatMap { seccion in
                        seccion.items.map { item in
                            SimpleAd(
                                id: String(item.id),
                                seccionNombre: seccion.nombreSeccion, // <- corregido
                                anuncio: item.titulo,
                                fotos: item.imagen.isEmpty ? [] : [item.imagen] // <- validación
                            )
                        }
                    }
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }
}
