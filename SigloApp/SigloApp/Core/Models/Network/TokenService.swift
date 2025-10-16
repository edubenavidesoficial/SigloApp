import Foundation
import UIKit
import CryptoKit

final class TokenService {
    static let shared = TokenService()

    private let tokenBaseURL = "\(API.baseURL)token/"
    private let userDefaultsTokenKey = "apiToken"
    private let userDefaultsCorreoHashKey = "correoHash"

    private init() {}

    // Obtener correo hash almacenado
    func getStoredCorreoHash() -> String? {
        return UserDefaults.standard.string(forKey: userDefaultsCorreoHashKey)
    }

    // Guardar token
    public func saveToken(_ token: String) {
        UserDefaults.standard.set(token, forKey: userDefaultsTokenKey)
    }

    // Obtener token guardado
    func getStoredToken() -> String? {
        return UserDefaults.standard.string(forKey: userDefaultsTokenKey)
    }

    // Verificar si el token JWT expiró
    func isTokenExpired(_ token: String) -> Bool {
        let parts = token.split(separator: ".")
        guard parts.count > 1 else { return true }
        
        let payloadData = Data(base64Encoded: String(parts[1])
            .replacingOccurrences(of: "-", with: "+")
            .replacingOccurrences(of: "_", with: "/")
            .padding(toLength: ((parts[1].count+3)/4)*4, withPad: "=", startingAt: 0))
        
        guard let data = payloadData,
              let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
              let exp = json["exp"] as? TimeInterval else { return true }
        
        return Date().timeIntervalSince1970 > exp
    }

    // Generar firma HMAC-SHA256 con clave secreta en Base64
    private func generateSignature(correoHash: String, deviceID: String) -> String {
        let secretKeyBase64 = "\(API.firmaSLL)"
        let message = "\(correoHash)|\(deviceID)"
        
        guard let keyData = Data(base64Encoded: secretKeyBase64) else {
            fatalError("❌ Clave secreta inválida")
        }
        
        let key = SymmetricKey(data: keyData)
        let signature = HMAC<SHA256>.authenticationCode(for: Data(message.utf8), using: key)
        return Data(signature).base64EncodedString()
    }

    // Solicitar token a la API
    @MainActor
    func getToken(correoHash: String) async throws -> String {
        let u = correoHash
        let d = UIDevice.current.identifierForVendor?.uuidString ?? "demo_id"
        let s = generateSignature(correoHash: u, deviceID: d)

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
            return decoded.token
        } catch {
            throw TokenServiceError.decodingError(error)
        }
    }
}

extension TokenService {
    
    /// Retorna un token válido, renovándolo si ya expiró
    @MainActor
    func getValidToken() async throws -> String {
        if let storedToken = getStoredToken() {
            if isTokenExpired(storedToken) {
                print("⚠️ Token expirado. Renovando...")
                guard let correoHash = getStoredCorreoHash() else {
                    throw TokenServiceError.invalidURL
                }
                let newToken = try await getToken(correoHash: correoHash)
                print("✅ Token renovado correctamente")
                return newToken
            } else {
                return storedToken
            }
        } else {
            // No hay token guardado → solicitar uno nuevo
            print("ℹ️ No hay token almacenado. Solicitando nuevo...")
            guard let correoHash = getStoredCorreoHash() else {
                throw TokenServiceError.invalidURL
            }
            let newToken = try await getToken(correoHash: correoHash)
            print("✅ Token inicial obtenido correctamente")
            return newToken
        }
    }
}
