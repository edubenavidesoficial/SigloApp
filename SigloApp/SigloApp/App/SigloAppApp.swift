import SwiftUI

@main
struct SigloAppApp: App {
    @AppStorage("isLoggedIn") private var isLoggedIn: Bool = false
    @AppStorage("appearanceMode") private var appearanceMode: AppearanceMode = .automatic

    @StateObject private var articleViewModel = ArticleViewModel()
    @State private var showWelcomeView = true
    @State private var showPromoView = false
    @State private var navigateToPromo = false
    @State private var navigateToHome = false
    @State private var authToken: String = ""

    var body: some Scene {
        WindowGroup {
            Group {
                if showWelcomeView {
                    WelcomeView(navigateToPromo: $navigateToPromo, authToken: $authToken)
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                                self.showWelcomeView = false
                                self.showPromoView = true
                            }
                        }
                } else if showPromoView {
                    PromoView(navigateToHome: $navigateToHome)
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                self.showPromoView = false
                            }
                        }
                } else {
                    if isLoggedIn {
                        TabsLayoutView(articleViewModel: articleViewModel)
                    } else {
                        TabsHomeLayoutView(articleViewModel: articleViewModel)
                    }
                }
            }
            .preferredColorScheme(resolveColorScheme(from: appearanceMode))
        }
    }

    private func resolveColorScheme(from mode: AppearanceMode) -> ColorScheme? {
        switch mode {
        case .automatic:
            return nil
        case .light:
            return .light
        case .dark:
            return .dark
        }
    }
}
