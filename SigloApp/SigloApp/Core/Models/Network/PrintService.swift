import Foundation

final class PrintService {
    static let shared = PrintService()
    private init() {}

    func obtenerPortada(pagina: Int = 1, completion: @escaping (Result<[NewspaperPayload], Error>) -> Void) {

        Task {
            do {
                // 1️⃣ Obtener token válido
                var token: String
                if let storedToken = TokenService.shared.getStoredToken(),
                   !TokenService.shared.isTokenExpired(storedToken) {
                    token = storedToken
                    print("✅ Usando token almacenado")
                } else {
                    token = try await TokenService.shared.getToken(correoHash: "")
                    print("✅ Nuevo token generado")
                }

                // 2️⃣ Construir URL
                guard let url = URL(string: "\(API.baseURL)impreso/lista/\(pagina)") else {
                    completion(.failure(NetworkError.invalidURL))
                    return
                }

                var request = URLRequest(url: url)
                request.httpMethod = "GET"
                request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

                // 3️⃣ Realizar request
                let (data, response) = try await URLSession.shared.data(for: request)

                guard let httpResponse = response as? HTTPURLResponse,
                      (200...299).contains(httpResponse.statusCode) else {
                    completion(.failure(NetworkError.invalidResponse))
                    return
                }

                // 4️⃣ Decodificar JSON
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
                // 1️⃣ Obtener token válido
                var token: String
                if let storedToken = TokenService.shared.getStoredToken(),
                   !TokenService.shared.isTokenExpired(storedToken) {
                    token = storedToken
                    print("✅ Usando token almacenado")
                } else {
                    token = try await TokenService.shared.getToken(correoHash: "")
                    print("✅ Nuevo token generado")
                }

                // 2️⃣ Construir URL final correctamente
                let fullURLString = "\(pdfPath)/\(token)"
                guard let url = URL(string: fullURLString) else {
                    completion(.failure(NetworkError.invalidURL))
                    return
                }
                print("🔹 Descargando PDF desde URL: \(url.absoluteString)")

                // 3️⃣ Descargar archivo temporal
                let (tempURL, response) = try await URLSession.shared.download(from: url)

                // 4️⃣ Verificar status code
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

                // 5️⃣ Guardar PDF en Documents con nombre único
                let fileManager = FileManager.default
                let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
                
                // Extraemos solo la última parte del pdfPath para el nombre
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
