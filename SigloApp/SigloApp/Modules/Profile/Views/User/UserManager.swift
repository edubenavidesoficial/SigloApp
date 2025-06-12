import Combine
import Foundation // Para UserDefaults y Codable

class UserManager: ObservableObject {
    @Published var user: UserPayload? = nil

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
        }
    }
}
