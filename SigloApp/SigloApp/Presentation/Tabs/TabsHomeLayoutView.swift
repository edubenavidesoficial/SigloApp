import SwiftUI

struct TabsHomeLayoutView: View {
    @ObservedObject var articleViewModel: ArticleViewModel  // ViewModel que se observa

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

                // Solo pasamos `articleViewModel`, eliminando `articleActionHelper`
                SavedView(articleViewModel: articleViewModel)
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
