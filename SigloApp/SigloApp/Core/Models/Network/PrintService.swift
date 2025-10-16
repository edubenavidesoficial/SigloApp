import Foundation

final class PrintService {
    static let shared = PrintService()
    private init() {}

    func obtenerPortada(pagina: Int = 1, completion: @escaping (Result<[NewspaperPayload], Error>) -> Void) {
        Task {
            do {
                // Obtener token válido automáticamente
                let token = try await TokenService.shared.getValidToken()

                // Construir URL
                guard let url = URL(string: "\(API.baseURL)impreso/lista/\(pagina)") else {
                    completion(.failure(NetworkError.invalidURL))
                    return
                }

                // Crear request con BaseService
                let base = BaseService()
                let request = try await base.authorizedRequest(url: url, method: "GET")

                // Realizar request
                let (data, response) = try await URLSession.shared.data(for: request)

                guard let httpResponse = response as? HTTPURLResponse,
                      (200...299).contains(httpResponse.statusCode) else {
                    completion(.failure(NetworkError.invalidResponse))
                    return
                }

                // Decodificar JSON
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let responseData = try decoder.decode(NewspaperResponse.self, from: data)
                completion(.success(responseData.payload))

            } catch {
                completion(.failure(error))
            }
        }
    }

    func descargarPDF(pdfPath: String, completion: @escaping (Result<URL, Error>) -> Void) {
        Task {
            do {
                // Obtener token válido automáticamente
                let token = try await TokenService.shared.getValidToken()

                // Construir URL final correctamente
                let fullURLString = "\(pdfPath)/\(token)"
                guard let url = URL(string: fullURLString) else {
                    completion(.failure(NetworkError.invalidURL))
                    return
                }
                print("🔹 Descargando PDF desde URL: \(url.absoluteString)")

                // Crear request con BaseService
                let base = BaseService()
                let request = try await base.authorizedRequest(url: url, method: "GET")

                // Descargar archivo temporal
                let (tempURL, response) = try await URLSession.shared.download(for: request)

                // Verificar status code
                if let httpResponse = response as? HTTPURLResponse {
                    print("🔹 Status code: \(httpResponse.statusCode)")
                    switch httpResponse.statusCode {
                    case 200...299:
                        break // todo bien
                    case 404:
                        print("❌ PDF no encontrado en el servidor para URL: \(url.absoluteString)")
                        completion(.failure(NetworkError.notFound))
                        return
                    default:
                        completion(.failure(NetworkError.invalidResponse))
                        return
                    }
                }

                // Guardar PDF en Documents con nombre único
                let fileManager = FileManager.default
                let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
                let clave = pdfPath.split(separator: "/").last ?? "document"
                let uniqueFileName = "\(clave)-\(UUID().uuidString).pdf"
                let destinationURL = documentsURL.appendingPathComponent(uniqueFileName)

                try fileManager.moveItem(at: tempURL, to: destinationURL)
                print("📄 PDF guardado en: \(destinationURL.path)")

                completion(.success(destinationURL))

            } catch {
                print("❌ Error al descargar PDF: \(error)")
                completion(.failure(error))
            }
        }
    }
}
