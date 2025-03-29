import SwiftUI

@main
struct SigloAppApp: App {
    @AppStorage("isLoggedIn") private var isLoggedIn: Bool = false
    @StateObject private var articleViewModel = ArticleViewModel()  // Inicializamos el viewModel a nivel de la app

    var body: some Scene {
        WindowGroup {
            if isLoggedIn {
                TabsLayoutView(articleViewModel: articleViewModel)  // Pasamos el viewModel
            } else {
                TabsHomeLayoutView(articleViewModel: articleViewModel)  // También lo pasamos aquí
            }
        }
    }
}
