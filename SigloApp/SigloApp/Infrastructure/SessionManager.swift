//
//  TokenManager.swift
//  SigloApp
//
//  Created by Macbook Pro 17 i5R on 3/20/25.
//

import Foundation

class SessionManager: ObservableObject {
    @Published var isLoggedIn: Bool = false

    func logout() {
        UserDefaults.standard.removeObject(forKey: "authToken")
        isLoggedIn = false
    }

    func checkLogin() {
        isLoggedIn = UserDefaults.standard.string(forKey: "authToken") != nil
    }
}
