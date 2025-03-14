//
//  SigloAppApp.swift
//  SigloApp
//
//  Created by Macbook Pro 17 i5R on 3/9/25.
//
import SwiftUI

@main
struct SigloAppApp: App {
    @AppStorage("isLoggedIn") var isLoggedIn: Bool = false

    var body: some Scene {
        WindowGroup {
            if isLoggedIn {
                TabsLayoutView()
            } else {
                TabsHomeLayoutView()
            }
        }
    }
}
