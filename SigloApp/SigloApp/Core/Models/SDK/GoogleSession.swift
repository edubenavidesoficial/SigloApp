
/*import Foundation
import SwiftUI
import Firebase
import GoogleSignIn

final class GoogleSession: ObservableObject {
  @Published var user: GIDGoogleUser?
  @Published var isSignedIn = false
  @Published var errorMessage: String?

  private let clientID = FirebaseApp.app()?.options.clientID
    
  func signIn() {
    guard let clientID = clientID else {
      errorMessage = "No se encontró clientID de Firebase"
      return
    }

    // Configura el objeto de Google Sign-In
    let config = GIDConfiguration(clientID: clientID)

    // Presenta el flujo de autenticación
    guard let root = UIApplication.shared.windows.first?.rootViewController else {
      errorMessage = "No se encontró ViewController para presentar Google Sign-In"
      return
    }

    GIDSignIn.sharedInstance.signIn(with: config, presenting: root) { [weak self] user, error in
      if let error = error {
        self?.errorMessage = error.localizedDescription
        return
      }
      guard
        let authentication = user?.authentication,
        let idToken = authentication.idToken
      else {
        self?.errorMessage = "No se pudo obtener token de Google"
        return
      }

      // Crea credenciales para Firebase
      let credential = GoogleAuthProvider.credential(
        withIDToken: idToken,
        accessToken: authentication.accessToken
      )

      // Autentica con Firebase
      Auth.auth().signIn(with: credential) { result, error in
        if let error = error {
          self?.errorMessage = error.localizedDescription
          return
        }
        // Usuario autenticado con éxito
        self?.user = user
        self?.isSignedIn = true
      }
    }
  }

  /// Cierra la sesión de Firebase y Google
  func signOut() {
    do {
      try Auth.auth().signOut()
      GIDSignIn.sharedInstance.signOut()
      self.user = nil
      self.isSignedIn = false
    } catch {
      self.errorMessage = error.localizedDescription
    }
  }
}
*/
