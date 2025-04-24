import Foundation
import UIKit
import CryptoKit

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
    static let shared = TokenService()

    private let tokenBaseURL = "\(API.baseURL)token/"
    private let userDefaultsTokenKey = "apiToken"

    private init() {}

    // Generador de firma usando HMAC-SHA256 con clave secreta en base64
    private func generateSignature(correoHash: String, deviceID: String) -> String {
        let secretKeyBase64 = "OOs9XwOSIVuP/Xb76M13GsShMGNHrowx2oOVMKGc/1o=" // ¡NO en la app para producción!
        let message = "\(correoHash)|\(deviceID)"
        
        guard let keyData = Data(base64Encoded: secretKeyBase64) else {
            fatalError("❌ Clave secreta inválida")
        }
        
        let key = SymmetricKey(data: keyData)
        let signature = HMAC<SHA256>.authenticationCode(for: Data(message.utf8), using: key)
        return Data(signature).base64EncodedString()
    }

    @MainActor
    func getToken(correoHash: String) async throws -> String {
        let u = correoHash
        let d = UIDevice.current.identifierForVendor?.uuidString ?? "demo_id"
        let s = generateSignature(correoHash: u, deviceID: d)

        print("🔐 Solicitando token (async)...")
        print("➡️ URL base: \(tokenBaseURL)")
        print("📨 Parámetros: u=\(u), d=\(d), s=\(s)")

        var components = URLComponents(string: tokenBaseURL)!
        components.queryItems = [
            URLQueryItem(name: "u", value: u),
            URLQueryItem(name: "d", value: d),
            URLQueryItem(name: "s", value: s)
        ]

        guard let finalURL = components.url else {
            throw TokenServiceError.invalidURL
        }

        var request = URLRequest(url: finalURL)
        request.httpMethod = "GET"

        let (data, _) = try await URLSession.shared.data(for: request)

        guard let data = data as Data? else {
            throw TokenServiceError.noData
        }

        do {
            let decoded = try JSONDecoder().decode(TokenResponse.self, from: data)
            self.saveToken(decoded.token)
            print("✅ Token guardado: \(decoded.token)")
            return decoded.token
        } catch {
            print("❌ Error parseando JSON: \(error)")
            throw TokenServiceError.decodingError(error)
        }
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
