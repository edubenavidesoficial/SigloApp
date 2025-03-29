import SwiftUI

struct TabsHomeLayoutView: View {
    @ObservedObject var articleViewModel: ArticleViewModel  // El ViewModel que observamos
    @StateObject private var articleActionHelper: ArticleActionHelper // Usamos StateObject aquí para mantener el ciclo
  
    init(articleViewModel: ArticleViewModel) {
        self.articleViewModel = articleViewModel
        _articleActionHelper = StateObject(wrappedValue: ArticleActionHelper(articleViewModel: articleViewModel))
    }

    var body: some View {
        VStack {
            TabView {
                HomeView()
                    .tabItem {
                        Image("ico_siglo")
                        Text("PORTADA")
                    }

                ImpresoView()
                    .tabItem {
                        Image("ico_print")
                        Text("IMPRESO")
                    }

                // Pasar el helper a SavedView
                SavedView(articleActionHelper: articleActionHelper)
                    .tabItem {
                        Image("ico_save")
                        Text("GUARDADO")
                    }

                ProfileView()
                    .tabItem {
                        Image("ico_user")
                        Text("PERFIL")
                    }
            }
            .accentColor(.brown)
        }
    }
}
