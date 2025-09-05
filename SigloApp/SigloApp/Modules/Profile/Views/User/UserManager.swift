import Combine
import Foundation

final class UserManager: ObservableObject {
    static let shared = UserManager()   // 👈 Singleton accesible en toda la app
    
    @Published var user: UserPayload? = nil

    private init() {   // 👈 Constructor privado
        loadUserFromDefaults()
    }

    func saveUserToDefaults() {
        if let user = user {
            if let data = try? JSONEncoder().encode(user) {
                UserDefaults.standard.set(data, forKey: "currentUser")
            }
        }
    }

    func loadUserFromDefaults() {
        if let data = UserDefaults.standard.data(forKey: "currentUser"),
           let user = try? JSONDecoder().decode(UserPayload.self, from: data) {
            self.user = user
            print("✅ Usuario cargado: \(user)")
        } else {
            print("⚠️ No hay usuario guardado en UserDefaults")
        }
    }

    func clearUser() {
        UserDefaults.standard.removeObject(forKey: "currentUser")
        self.user = nil
        print("👤 Usuario eliminado de UserDefaults")
    }
}
