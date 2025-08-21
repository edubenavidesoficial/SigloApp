import Foundation

final class PrintService {
    static let shared = PrintService()
    private init() {}

    func obtenerPortada(pagina: Int = 1, completion: @escaping (Result<[NewspaperPayload], Error>) -> Void) {

        Task {
            do {
                var token: String
                if let storedToken = TokenService.shared.getStoredToken(),
                   !TokenService.shared.isTokenExpired(storedToken) {
                    token = storedToken
                    print("✅ Usando token almacenado")
                } else {
                    // Obtenemos un token nuevo
                    token = try await TokenService.shared.getToken(correoHash: "")
                    print("✅ Nuevo token generado")
                }

                guard let url = URL(string: "\(API.baseURL)impreso/lista/\(pagina)") else {
                    completion(.failure(NetworkError.invalidURL))
                    return
                }

                var request = URLRequest(url: url)
                request.httpMethod = "GET"
                request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

                let (data, response) = try await URLSession.shared.data(for: request)

                guard let httpResponse = response as? HTTPURLResponse,
                      (200...299).contains(httpResponse.statusCode) else {
                    completion(.failure(NetworkError.invalidResponse))
                    return
                }

                // DEBUG: mostrar parte del JSON recibido
                if let jsonString = String(data: data, encoding: .utf8) {
                    print("📦 JSON recibido Print:\n\(jsonString.prefix(500))...")
                }

                do {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    let responseData = try decoder.decode(NewspaperResponse.self, from: data)
                    completion(.success(responseData.payload))
                } catch {
                    print("❌ Error al decodificar JSON: \(error)")
                    completion(.failure(error))
                }

            } catch {
                completion(.failure(error))
            }
        }
    }
    func descargarPDF(fecha: String, clave: String, completion: @escaping (Result<URL, Error>) -> Void) {
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
                let urlString = "\(API.baseURL)impreso/pdf/\(fecha)/\(clave)/\(token)"
                guard let url = URL(string: urlString) else {
                    completion(.failure(NetworkError.invalidURL))
                    return
                }
                print("🔹 Descargando PDF desde URL: \(url.absoluteString)")

                // 3️⃣ Descargar archivo temporal
                let (tempURL, response) = try await URLSession.shared.download(from: url)

                // 4️⃣ Verificar status code y ajustar clave si tiene "/"
                var claveParaURL = clave
                if let firstPart = clave.split(separator: "/").first {
                    claveParaURL = String(firstPart)
                }

                if let httpResponse = response as? HTTPURLResponse {
                    print("🔹 Status code: \(httpResponse.statusCode)")

                    switch httpResponse.statusCode {
                    case 200...299:
                        break // continuar normalmente
                    case 404:
                        print("❌ PDF no encontrado en el servidor para fecha: \(fecha), clave: \(claveParaURL)")
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
                let uniqueFileName = "\(fecha)-\(clave)-\(UUID().uuidString).pdf"
                let destinationURL = documentsURL.appendingPathComponent(uniqueFileName)

                try fileManager.moveItem(at: tempURL, to: destinationURL)
                print("📄 PDF guardado en: \(destinationURL.path)")

                // 6️⃣ Completar con éxito
                completion(.success(destinationURL))

            } catch {
                print("❌ Error al descargar PDF: \(error)")
                completion(.failure(error))
            }
        }
    }
}
