import Foundation
import Combine

// Enum para errores específicos
enum PortadaViewModelError: Error {
    case networkError(String)
    case emptyData
    case decodingError
}

// ViewModel
class PortadaViewModel: ObservableObject {
    @Published var secciones: [SeccionPortada] = []
    @Published var errorMessage: String?

    // Obtener las secciones de la portada
    func obtenerPortada() {
        PortadaService.shared.obtenerPortada { result in
            switch result {
            case .success(let secciones):
                DispatchQueue.main.async {
                    if secciones.isEmpty {
                        self.errorMessage = "No se encontraron secciones."
                    } else {
                        self.secciones = secciones
                    }
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    // Manejar errores específicos
                    if let portadaError = error as? PortadaServiceError {
                        switch portadaError {
                        case .invalidURL:
                            self.errorMessage = "La URL de la portada no es válida."
                        case .invalidResponse:
                            self.errorMessage = "La respuesta del servidor no es válida."
                        case .emptyData:
                            self.errorMessage = "No se recibieron datos del servidor."
                        case .missingPayload(let mensaje):
                            self.errorMessage = "Falta el payload en la respuesta: \(mensaje)"
                        case .decodingError(let error):
                            self.errorMessage = "Error al procesar los datos: \(error.localizedDescription)"
                        }
                    } else {
                        // Error genérico
                        self.errorMessage = "Hubo un error desconocido al cargar la portada."
                    }
                }
            }
        }
    }
}
