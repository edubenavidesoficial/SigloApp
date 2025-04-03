import Foundation
import CryptoKit

// MARK: - Modelo de respuesta
struct LoginResponse: Decodable {
    let response: String
    let payload: UserPayload?
}

struct UserPayload: Decodable {
    let id: Int
    let usuario: String
    let correo: String
    let nombre: String
    let apellidos: String
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
    static func login(username: String, password: String) async throws -> UserPayload {
       // let correoHash = md5(username)
      //  let passwordHash = md5(password)
        let correoHash = md5(username.lowercased())
        let passwordHash = md5(password.lowercased())

        // 📌 Imprimir en consola los valores encriptados para verificar
        print("📌 Usuario encriptado (MD5): \(correoHash)")
        print("📌 Contraseña encriptada (MD5): \(passwordHash)")

        let token: String
        if let storedToken = TokenService.shared.getStoredToken() {
            print("✅ Usando token guardado")
            print("🔑 Token actual: \(storedToken)")
            token = storedToken
        } else {
            print("⚠️ No se encontró token guardado. Solicitando nuevo token...")
            token = try await TokenService.shared.getToken(correoHash: correoHash)
            TokenService.shared.saveToken(token)
            print("✅ Token recibido y guardado desde TokenService")
        }

        return try await loginWithToken(correoHash: correoHash, passwordHash: passwordHash, token: token)
    }

    // Función privada para realizar el login con el token
    private static func loginWithToken(correoHash: String, passwordHash: String, token: String) async throws -> UserPayload {
        let urlString = "\(API.baseURL)login/s/\(correoHash)/\(passwordHash)"
        print("🌐 URL generada: \(urlString)")
        
        guard let url = URL(string: urlString) else {
            print("❌ URL inválida")
            throw LoginServiceError.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.setValue("MyApp/1.0 (iOS)", forHTTPHeaderField: "User-Agent")


        let (data, response) = try await URLSession.shared.data(for: request)

        // 📌 Imprimir respuesta completa en consola para depuración
        if let httpResponse = response as? HTTPURLResponse {
            print("📡 Código de respuesta HTTP: \(httpResponse.statusCode)")
        }
        print("📩 Respuesta cruda de la API: \(String(decoding: data, as: UTF8.self))")

        guard let data = data as Data? else {
            throw LoginServiceError.emptyData
        }

        do {
            let loginResponse = try JSONDecoder().decode(LoginResponse.self, from: data)

            if loginResponse.response == "Success", let user = loginResponse.payload {
                print("✅ Login exitoso: \(user)")
                return user
            } else {
                throw LoginServiceError.custom("Error en el login: \(loginResponse.response)")
            }
        } catch {
            throw LoginServiceError.decodingError(error)
        }
    }
}
