import Foundation
import AuthenticationServices
import FirebaseAuth
import FirebaseCore
import FirebaseFirestore
import GoogleSignIn
import UIKit
import SwiftUI
import CryptoKit

final class AuthService: NSObject, ObservableObject {
    
    static let shared = AuthService()
    
    @Published var user: User? // Usuario de Firebase
    @Published var currentNonce: String? // ✅ Ahora accesible desde LoginView
    
    private let db = Firestore.firestore()
    
    private override init() {
        super.init()
    }
    
    // MARK: - Google Sign-In
    
    func signInWithGoogle(presenting: UIViewController) {
        GIDSignIn.sharedInstance.signIn(withPresenting: presenting) { [weak self] result, error in
            if let error = error {
                print("❌ Error Google Sign-In: \(error.localizedDescription)")
                return
            }

            guard let user = result?.user,
                  let idToken = user.idToken?.tokenString else { return }

            let accessToken = user.accessToken.tokenString
            let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: accessToken)

            Auth.auth().signIn(with: credential) { authResult, error in
                if let error = error {
                    print("❌ Firebase login error (Google): \(error.localizedDescription)")
                } else if let authResult = authResult {
                    self?.user = authResult.user
                    print("✅ Usuario logueado con Google: \(authResult.user.email ?? "")")
                    self?.saveUserData(user: authResult.user, provider: "Google")
                    Task {
                        await self?.loginWithElsigloAPI(provider: "g", user: authResult.user, providerID: user.userID ?? "")
                    }
                }
            }
        }
    }
    
    // MARK: - Apple Sign-In
    
    func generateNonce() {
        currentNonce = randomNonceString()
    }
    
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
    
    private func randomNonceString(length: Int = 32) -> String {
        let charset: [Character] = Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        var result = ""
        var remainingLength = length

        while remainingLength > 0 {
            let randoms: [UInt8] = (0..<16).map { _ in
                var random: UInt8 = 0
                let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
                if errorCode != errSecSuccess {
                    fatalError("Unable to generate nonce. SecRandomCopyBytes failed.")
                }
                return random
            }

            randoms.forEach { random in
                if remainingLength == 0 { return }
                if random < charset.count {
                    result.append(charset[Int(random)])
                    remainingLength -= 1
                }
            }
        }

        return result
    }

    private func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashed = SHA256.hash(data: inputData)
        return hashed.map { String(format: "%02x", $0) }.joined()
    }
    
    // MARK: - Firestore
    
    private func saveUserData(user: User, provider: String) {
        let userRef = db.collection("users").document(user.uid)
        let data: [String: Any] = [
            "uid": user.uid,
            "email": user.email ?? "",
            "displayName": user.displayName ?? "",
            "provider": provider,
            "lastLogin": Timestamp(date: Date())
        ]
        
        userRef.setData(data, merge: true) { error in
            if let error = error {
                print("❌ Error guardando usuario en Firestore: \(error.localizedDescription)")
            } else {
                print("✅ Datos del usuario guardados en Firestore")
            }
        }
    }
    
    // MARK: - API El Siglo
    
    private func loginWithElsigloAPI(provider: String, user: User, providerID: String) async {
        guard let email = user.email else { return }
        let correoHash = md5(email.lowercased())
        let idHash = md5(providerID)
        let urlString = "https://www.elsiglodetorreon.com.mx/api/app/v1/login/\(provider)/\(correoHash)/\(idHash)"
        
        guard let url = URL(string: urlString) else { return }
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            if let httpResponse = response as? HTTPURLResponse {
                print("📡 Código de respuesta API El Siglo: \(httpResponse.statusCode)")
            }
            print("📩 Respuesta API El Siglo: \(String(decoding: data, as: UTF8.self))")
        } catch {
            print("❌ Error llamando API El Siglo: \(error.localizedDescription)")
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
        UIApplication.shared.windows.first { $0.isKeyWindow } ?? ASPresentationAnchor()
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        guard let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential,
              let identityToken = appleIDCredential.identityToken,
              let tokenString = String(data: identityToken, encoding: .utf8),
              let nonce = currentNonce else { return }

        let credential = OAuthProvider.credential(withProviderID: "apple.com", idToken: tokenString, rawNonce: nonce)

        Auth.auth().signIn(with: credential) { [weak self] result, error in
            if let error = error {
                print("❌ Firebase login error (Apple): \(error.localizedDescription)")
            } else if let result = result {
                self?.user = result.user
                print("✅ Usuario logueado con Apple: \(result.user.email ?? "")")
                self?.saveUserData(user: result.user, provider: "Apple")
                Task {
                    await self?.loginWithElsigloAPI(provider: "a", user: result.user, providerID: appleIDCredential.user)
                }
            }
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("❌ Apple Sign-In failed: \(error.localizedDescription)")
    }
}
