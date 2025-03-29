import SwiftUI

struct TabsLayoutView: View {
    @ObservedObject var articleViewModel: ArticleViewModel  // ViewModel principal
    @StateObject private var articleActionHelper: ArticleActionHelper // Helper con StateObject para gestión de artículos

    init(articleViewModel: ArticleViewModel) {
        self.articleViewModel = articleViewModel
        _articleActionHelper = StateObject(wrappedValue: ArticleActionHelper(articleViewModel: articleViewModel))
    }

    var body: some View {
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

            SavedView(articleActionHelper: articleActionHelper)
                .tabItem {
                    Image("ico_save")
                    Text("GUARDADO")
                }

            UserView()
                .tabItem {
                    Image("ico_user")
                    Text("PERFIL")
                }
        }
        .accentColor(.brown)
    }
}

