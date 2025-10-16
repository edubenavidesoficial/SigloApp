import SwiftUI
import FirebaseAuth
import FirebaseCore
import GoogleSignIn
import AuthenticationServices
import CryptoKit

// MARK: - AuthService
@MainActor
final class AuthService: NSObject, ObservableObject {
    
    static let shared = AuthService()
    
    @Published var user: User? // Usuario Firebase
    @Published var currentNonce: String?
    
    private override init() { super.init() }
    
    // MARK: - Google Sign-In
    func signInWithGoogle() {
        guard let rootVC = UIApplication.shared.keyWindow?.rootViewController else {
            print("❌ No se encontró rootViewController para Google Sign-In")
            return
        }
        guard let clientID = FirebaseApp.app()?.options.clientID else {
            print("❌ Google Sign-In: No se encontró clientID de Firebase")
            return
        }
        
        // Nota: 'config' ya no es necesario guardarlo si no se usa
        _ = GIDConfiguration(clientID: clientID)
        
        GIDSignIn.sharedInstance.signIn(withPresenting: rootVC) { [weak self] result, error in
            if let error = error {
                print("❌ Google Sign-In error: \(error.localizedDescription)")
                return
            }
            guard let user = result?.user,
                  let idToken = user.idToken?.tokenString else { return }
            let accessToken = user.accessToken.tokenString
            let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: accessToken)
            
            Auth.auth().signIn(with: credential) { authResult, error in
                if let error = error {
                    print("❌ Firebase login (Google): \(error.localizedDescription)")
                } else if let authResult = authResult {
                    Task { @MainActor in
                        self?.user = authResult.user
                        UserDefaults.standard.set(true, forKey: "isLoggedIn")
                        print("✅ Usuario logueado con Google: \(authResult.user.email ?? "")")
                        await self?.loginWithElsigloAPI(provider: "g", user: authResult.user, providerID: user.userID ?? "")
                    }
                }
            }
        }
    }
    
    // MARK: - Apple Sign-In
    func generateNonce() { currentNonce = randomNonceString() }
    
    func startSignInWithAppleFlow() {
        guard let nonce = currentNonce else {
            print("❌ Nonce no generado")
            return
        }
        
        let request = ASAuthorizationAppleIDProvider().createRequest()
        request.requestedScopes = [.fullName, .email]
        request.nonce = sha256(nonce)
        
        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.delegate = self
        controller.presentationContextProvider = self
        controller.performRequests()
    }
    
    // MARK: - Helpers Nonce
    private func randomNonceString(length: Int = 32) -> String {
        let charset: [Character] =
        Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        var result = ""
        var remainingLength = length
        while remainingLength > 0 {
            let randoms: [UInt8] = (0..<16).map { _ in
                var random: UInt8 = 0
                let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
                if errorCode != errSecSuccess { fatalError("No se pudo generar nonce") }
                return random
            }
            randoms.forEach {
                if remainingLength == 0 { return }
                if $0 < charset.count { result.append(charset[Int($0)]); remainingLength -= 1 }
            }
        }
        return result
    }
    
    private func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashed = SHA256.hash(data: inputData)
        return hashed.map { String(format: "%02x", $0) }.joined()
    }
    
    // MARK: - API El Siglo
    func loginWithElsigloAPI(provider: String, user: User, providerID: String) async {
        guard let email = user.email else { return }
        let correoHash = md5(email.lowercased())
        let idHash = md5(providerID)
        let urlString = "\(API.baseURL)login/\(provider)/\(correoHash)/\(idHash)"
        guard let url = URL(string: urlString) else { return }
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            if let httpResponse = response as? HTTPURLResponse {
                print("📡 API El Siglo: \(httpResponse.statusCode)")
            }
            print("📩 Respuesta API El Siglo: \(String(decoding: data, as: UTF8.self))")
        } catch {
            print("❌ Error API El Siglo: \(error.localizedDescription)")
        }
    }
    
    private func md5(_ string: String) -> String {
        let digest = Insecure.MD5.hash(data: Data(string.utf8))
        return digest.map { String(format: "%02x", $0) }.joined()
    }
}

// MARK: - Apple Sign-In Delegates
extension AuthService: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return UIApplication.shared.keyWindow ?? ASPresentationAnchor()
    }
    
    func authorizationController(controller: ASAuthorizationController,
                                 didCompleteWithAuthorization authorization: ASAuthorization) {
        guard let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential,
              let identityToken = appleIDCredential.identityToken,
              let tokenString = String(data: identityToken, encoding: .utf8),
              let nonce = currentNonce else { return }
        
        let credential = OAuthProvider.credential(
            providerID: .apple,     // 🔹 AuthProviderID actualizado
            idToken: tokenString,
            rawNonce: nonce,
            accessToken: nil
        )
        
        Auth.auth().signIn(with: credential) { [weak self] result, error in
            if let error = error {
                print("❌ Firebase login (Apple): \(error.localizedDescription)")
            } else if let result = result {
                Task { @MainActor in
                    self?.user = result.user
                    UserDefaults.standard.set(true, forKey: "isLoggedIn")
                    print("✅ Usuario logueado con Apple: \(result.user.email ?? "")")
                    await self?.loginWithElsigloAPI(provider: "a", user: result.user, providerID: appleIDCredential.user)
                }
            }
        }
    }
    
    func authorizationController(controller: ASAuthorizationController,
                                 didCompleteWithError error: Error) {
        print("❌ Apple Sign-In failed: \(error.localizedDescription)")
    }
}

// MARK: - Extensión para obtener ventana clave
extension UIApplication {
    var keyWindow: UIWindow? {
        connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .first { $0.isKeyWindow }
    }
}
