import Foundation
import CryptoKit

// MARK: - Modelo de respuesta
struct LoginResponse: Decodable {
    let status: Bool
    let message: String
    let token: String?
}

// MARK: - Errores personalizados
enum LoginServiceError: Error {
    case invalidURL
    case emptyData
    case custom(String)
    case decodingError(Error)
}

// MARK: - Servicio de Login
final class LoginService {
    // Función MD5 usando CryptoKit
    static func md5(_ string: String) -> String {
        let digest = Insecure.MD5.hash(data: Data(string.utf8))
        return digest.map { String(format: "%02x", $0) }.joined()
    }

    @MainActor
    static func login(username: String, password: String, completion: @escaping (Result<String, Error>) -> Void) {
        let correoHash = md5(username)
        let passwordHash = md5(password)

        let urlString = "https://www.elsiglodetorreon.com.mx/api/app/v1/login/s/\(correoHash)/\(passwordHash)"

        guard let url = URL(string: urlString) else {
            print("❌ URL inválida")
            completion(.failure(LoginServiceError.invalidURL))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        // Adjuntamos token si existe
        if let token = TokenService.shared.getStoredToken() {
            print("✅ Usando token guardado")
            request.setValue(token, forHTTPHeaderField: "Authorization")
        } else {
            print("⚠️ No se encontró token guardado")
        }

        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    completion(.failure(error))
                    return
                }

                guard let data = data else {
                    completion(.failure(LoginServiceError.emptyData))
                    return
                }

                do {
                    let loginResponse = try JSONDecoder().decode(LoginResponse.self, from: data)

                    if loginResponse.status, let token = loginResponse.token {
                        TokenService.shared.saveToken(token)
                        print("🔐 Token recibido y guardado")
                        completion(.success(token))
                    } else {
                        let message = loginResponse.message
                        completion(.failure(LoginServiceError.custom(message)))
                    }
                } catch {
                    completion(.failure(LoginServiceError.decodingError(error)))
                }
            }
        }.resume()
    }
}
