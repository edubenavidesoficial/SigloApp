import Foundation
import CryptoKit

// MARK: - Modelo de respuesta
struct LoginResponse: Decodable {
    let status: Bool
    let message: String
    let token: String?
}
// MARK: - Servicio de Login
@MainActor
final class LoginService {

    // Función MD5 usando CryptoKit
    static func md5(_ string: String) -> String {
        let digest = Insecure.MD5.hash(data: Data(string.utf8))
        return digest.map { String(format: "%02x", $0) }.joined()
    }

    // Función principal de login usando async/await
    static func login(username: String, password: String) async throws -> String {
        let correoHash = md5(username)
        let passwordHash = md5(password)

        let token: String
        if let storedToken = TokenService.shared.getStoredToken() {
            print("✅ Usando token guardado")
            print("🔑 Token actual: \(storedToken)")
            token = storedToken
        }
        else {
            print("⚠️ No se encontró token guardado. Solicitando nuevo token...")
            token = try await TokenService.shared.getToken(correoHash: correoHash)
            TokenService.shared.saveToken(token)
            print("✅ Token recibido y guardado desde TokenService")
        }

        return try await loginWithToken(correoHash: correoHash, passwordHash: passwordHash, token: token)
    }

    // Función privada para realizar el login con el token
    private static func loginWithToken(correoHash: String, passwordHash: String, token: String) async throws -> String {
        let urlString = "https://www.elsiglodetorreon.com.mx/api/app/v1/login/s/\(correoHash)/\(passwordHash)"

        guard let url = URL(string: urlString) else {
            print("❌ URL inválida")
            throw LoginServiceError.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue(token, forHTTPHeaderField: "Authorization")

        let (data, _) = try await URLSession.shared.data(for: request)

        guard let data = data as Data? else {
            throw LoginServiceError.emptyData
        }

        do {
            let loginResponse = try JSONDecoder().decode(LoginResponse.self, from: data)

            if loginResponse.status, let token = loginResponse.token {
                TokenService.shared.saveToken(token)
                print("🔐 Token recibido y guardado desde loginWithToken")
                return token
            } else {
                throw LoginServiceError.custom(loginResponse.message)
            }
        } catch {
            throw LoginServiceError.decodingError(error)
        }
    }
}
