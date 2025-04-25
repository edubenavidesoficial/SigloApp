import SwiftUI

@main
struct SigloAppApp: App {
    @AppStorage("isLoggedIn") private var isLoggedIn: Bool = false
    @StateObject private var articleViewModel = ArticleViewModel()
    @State private var showWelcomeView = true

    var body: some Scene {
        WindowGroup {
            if showWelcomeView {
                // Mostrar la vista de bienvenida por unos segundos
                WelcomeView()
                    .onAppear {
                        // Ocultar la vista de bienvenida después de 3 segundos
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                            self.showWelcomeView = false
                        }
                    }
            } else {
                // Mostrar la vista correspondiente según si el usuario está logueado o no
                if isLoggedIn {
                    TabsLayoutView(articleViewModel: articleViewModel)
                } else {
                    TabsHomeLayoutView(articleViewModel: articleViewModel)
                }
            }
        }
    }
}
