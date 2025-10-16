import Foundation

enum PortadaServiceError: Error {
    case invalidURL
    case invalidResponse
    case emptyData
    case missingPayload(String)
    case decodingError(Error)
}

final class PortadaService {
    static let shared = PortadaService()
    private init() {}

    @MainActor
    func obtenerPortada() async -> Result<[SeccionPortada], Error> {
        guard let url = URL(string: "\(API.baseURL)portada/") else {
            print("❌ URL inválida")
            return .failure(PortadaServiceError.invalidURL)
        }

        do {
            // Creamos la request usando BaseService
            let base = BaseService()
            let request = try await base.authorizedRequest(url: url, method: "GET")
            
            let (data, response) = try await URLSession.shared.data(for: request)

            guard let httpResponse = response as? HTTPURLResponse else {
                print("❌ Respuesta no válida")
                return .failure(PortadaServiceError.invalidResponse)
            }

            print("📡 Código de estado: \(httpResponse.statusCode)")

            guard (200...299).contains(httpResponse.statusCode) else {
                let message = HTTPURLResponse.localizedString(forStatusCode: httpResponse.statusCode)
                print("❌ Error HTTP: \(httpResponse.statusCode) - \(message)")
                return .failure(PortadaServiceError.invalidResponse)
            }

            // No es necesario hacer guard let data, porque ya no es opcional
            // DEBUG opcional
            if let jsonString = String(data: data, encoding: .utf8) {
                print("📦 JSON recibido Portada:\n\(jsonString.prefix(1000000))...")
            }

            // Decodificamos la respuesta completa
            let decoder = JSONDecoder()
            let decodedResponse = try decoder.decode(PortadaResponse.self, from: data)

            // Iteramos sobre las secciones y verificamos si contienen 'notas'
            var seccionesConNotas: [SeccionPortada] = []

            for (key, seccion) in decodedResponse.payload {
                if let notas = seccion.notas {
                    print("Sección \(key): \(String(describing: seccion.seccion))")
                    for _ in notas {}
                    seccionesConNotas.append(seccion)
                } else {
                    print("Sección \(key) no contiene 'notas'")
                }
            }

            return .success(seccionesConNotas)

        } catch {
            print("❌ Error PortadaService: \(error)")
            return .failure(error)
        }
    }
}
