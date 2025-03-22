import Foundation
import UIKit

// MARK: - Modelo para decodificar la respuesta del token
struct TokenResponse: Codable {
    let request_date: String
    let response: String
    let token: String
    let processing_time: String
}

// MARK: - Definición de errores personalizados
enum TokenServiceError: Error {
    case invalidURL
    case noData
    case decodingError(Error)
}

// MARK: - Servicio de Token
final class TokenService {
    // Podrías usar inyección de dependencias en lugar de singleton si deseas testear
    static let shared = TokenService()

    private let tokenBaseURL = "https://www.elsiglodetorreon.com.mx/api/app/v1/token/"
    private let userDefaultsTokenKey = "apiToken"

    private init() {}

    @MainActor
    func getToken(correoHash: String, completion: @escaping (Result<String, Error>) -> Void) {
        let u = correoHash
        let d = UIDevice.current.identifierForVendor?.uuidString ?? "demo_id"
        let s = "firma_demo" // En producción debería generarse con OpenSSL o backend seguro

        var components = URLComponents(string: tokenBaseURL)!
        components.queryItems = [
            URLQueryItem(name: "u", value: u),
            URLQueryItem(name: "d", value: d),
            URLQueryItem(name: "s", value: s)
        ]

        guard let finalURL = components.url else {
            completion(.failure(TokenServiceError.invalidURL))
            return
        }

        var request = URLRequest(url: finalURL)
        request.httpMethod = "GET"

        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    completion(.failure(error))
                    return
                }

                guard let data = data else {
                    completion(.failure(TokenServiceError.noData))
                    return
                }

                do {
                    let decoded = try JSONDecoder().decode(TokenResponse.self, from: data)
                    self.saveToken(decoded.token)
                    print("✅ Token guardado: \(decoded.token)")
                    completion(.success(decoded.token))
                } catch {
                    print("❌ Error parseando JSON: \(error)")
                    completion(.failure(TokenServiceError.decodingError(error)))
                }
            }
        }.resume()
    }

    // Guardar token
    public func saveToken(_ token: String) {
        UserDefaults.standard.set(token, forKey: userDefaultsTokenKey)
    }

    // Obtener token guardado
    func getStoredToken() -> String? {
        return UserDefaults.standard.string(forKey: userDefaultsTokenKey)
    }
}
